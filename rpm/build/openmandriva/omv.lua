local omv = omv or {}

-- Make a directory hierarchy -- same as the "mkdir -p" shell command
function omv.mkdir_p(path, uid, gid, mode)
	local curr = ""
	for segment in path:gmatch("([^/]+)") do
		curr = curr .. "/" .. segment
		if not posix.stat(curr) then
			posix.mkdir(curr)
			if uid and gid then posix.chown(curr, uid, gid) end
			if mode then posix.chmod(curr, mode) end
		end
	end
end

-- Helper: Get total size of a directory in bytes (Recursive)
function omv.dirSize(path)
	local total = 0
	local st = posix.stat(path)
	if not st then return 0 end
	
	if st.type == "directory" then
		local files = posix.dir(path)
		for _, f in ipairs(files) do
			if f ~= "." and f ~= ".." then
				total = total + omv.dirSize(path .. "/" .. f)
			end
		end
	else
		total = st.size
	end
	return total
end

-- Helper: Check if destination has enough space to move a directory
-- from another filesystem
function omv.hasSpaceFor(source, dest_parent)
	local required = omv.dirSize(source)
	-- statvfs needs an existing directory to check the mount point
	local vfs = posix.statvfs(dest_parent)
	if not vfs then return true end -- Can't check, assume okay or handle error

	-- f_frsize is the fragment size (block size)
	-- f_bavail is blocks available to unprivileged users
	local available = vfs.f_frsize * vfs.f_bavail

	-- We want a 5% safety margin
	return available > (required * 1.05)
end

-- Copy a file (e.g. for cross-device moves)
function omv.cp(src, dst)
	local st = posix.stat(src)
	if not st then return false end

	local f_src = io.open(src, "rb")
	if not f_src then return false end

	local f_dst = io.open(dst, "wb")
	if not f_dst then f_src:close(); return false end

	-- Use a 1MB buffer for efficiency
	while true do
		local block = f_src:read(1024*1024)
		if not block then break end
		f_dst:write(block)
	end

	f_src:close()
	f_dst:close()
	
	-- Preserve permissions and ownership
	local ok, err = posix.chown(dst, st.uid, st.gid)
	if not ok then
		rpm.expand("%{warn: OMV Migration: Failed to chown " .. dst .. ": " .. err .. "}")
	end
	return true
end

-- Move a file or directory (e.g. for cross-device moves)
function omv.mv(s, d)
	if not os.rename(s, d) then
		local st = posix.stat(s)
		if st.type == "directory" then
			omv.mkdir_p(d, st.uid, st.gid, st.mode)
			for _, f in ipairs(posix.dir(s)) do
				if f ~= "." and f ~= ".." then
					omv.mv(s .. "/" .. f, d .. "/" .. f)
				end
			end
			posix.rmdir(s)
		else
			-- It's a file or link, use the cp fallback
			omv.cp(s, d)
			posix.unlink(s)
		end
	end
end

-- Move a directory out of the way, renaming it to *.rpmmoved
function omv.movedir(path)
	local st = posix.stat(path)
	if st and st.type == "directory" then
		local status = os.rename(path, path .. ".rpmmoved")
		if not status then
			local suffix = 0
			while not status do
				suffix = suffix + 1
				status = os.rename(path .. ".rpmmoved", path .. ".rpmmoved" .. suffix)
			end
			os.rename(path, path .. ".rpmmoved")
		end
	end
end

-- Helper: Returns the relative path from 'base' to 'target'
function omv.relativePath(base, target)
	-- Remove trailing slashes
	local base = base:gsub("/+$", "")
	local target = target:gsub("/+$", "")

	local b_parts = {}
	for s in base:gmatch("([^/]+)") do table.insert(b_parts, s) end
	local t_parts = {}
	for s in target:gmatch("([^/]+)") do table.insert(t_parts, s) end

	-- Find the common prefix
	local i = 1
	while b_parts[i] and t_parts[i] and b_parts[i] == t_parts[i] do
		i = i + 1
	end

	-- How many levels to go up from the directory containing 'base'
	local rel = ""
	for j = i, #b_parts - 1 do
		rel = rel .. "../"
	end

	-- Add the remaining parts of the target
	for j = i, #t_parts do
		rel = rel .. t_parts[j] .. (j == #t_parts and "" or "/")
	end

	return rel == "" and "." or rel
end

-- Replace a directory with a symlink, merging the directories if both
-- already exist
-- Parameters:
-- old -- Old directory to be replaced
-- new -- New location of the files
-- relative_target -- optional: manually 
function omv.dir2Symlink(old, new, relative_target)
	local st_old = posix.stat(old)
	local dest_parent = new:match("(.+)/")
	omv.mkdir_p(dest_parent)

	if st_old and st_old.type == "directory" then
		local st_dest_p = posix.stat(dest_parent)
		if st_dest_p and (st_old.dev ~= st_dest_p.dev) then
			-- Cross device move detected: Verify space!
			if not omv.hasSpaceFor(old, dest_parent) then
				error("OMV Migration Error: Not enough space on " .. dest_parent .. " to move " .. old)
				return false
			end
		end
		omv.mv(old, new)
	end

	-- Create symlink (relative by default)
	if not posix.stat(old) then
		local rel = relative_target or omv.relativePath(old, new)
		if rel ~= "ignore" then posix.symlink(rel, old) end
	end
end

function omv.symlink2Dir(link_path, new_dir_path)
	local st = posix.stat(link_path)
	
	-- 1. If it's already a directory, we're done
	if st and st.type == "directory" then
		return true
	end

	-- 2. If it's a symlink, handle the transition
	if st and st.type == "link" then
		-- Optional: If the symlink was pointing to data we want to keep,
		-- we could os.rename the target of the link back to link_path.
		-- For now, we simply remove the link to make room for a directory.
		posix.unlink(link_path)
	end

	-- 3. Create the new directory
	-- If new_dir_path isn't provided, we assume link_path is the new dir
	local target_path = new_dir_path or link_path
	omv.mkdir_p(target_path)
	
	-- If we created it elsewhere, we might need a symlink back, 
	-- but usually 'replacing link with dir' means link_path BECOMES the dir.
	if target_path ~= link_path then
		posix.symlink(target_path, link_path)
	end
end

-- Merge files in a source directory to a destination directory - unless
-- they already exist in the destination directory. Also, if they exist in
-- both directories and one is a symlink, keep the "good" one. Useful when
-- collecting multiple previous directories (e.g. /bin and /usr/bin) in
-- one...
function omv.mergedirs(source, dest)
	print("=== mergedirs " .. source .. " -> " .. dest)
	local src=posix.stat(source)
	if not src then
		-- Source doesn't exist
		return false
	end
	if src.type ~= "directory" then
		-- Source is already a symlink
		return true
	end
	-- Only "." and ".."
	if #posix.dir(source) <= 2 then
		-- Nothing in the source directory
		posix.rmdir(source)
		return true
	end
	local d=posix.stat(dest)
	if not d then
		-- Destination doesn't exist yet, may be a
		-- fresh install
		posix.mkdir(dest)
	elseif d.type == "link" then
		-- This really shouldn't happen, but let's be safe
		posix.unlink(dest)
		posix.mkdir(dest)
	end
	for i,p in pairs(posix.dir(source)) do
		if(p ~= "." and p ~= "..") then
			local keep=nil
			local sts=posix.stat(source .. "/" .. p)
			local std=posix.stat(dest .. "/" .. p)
			if (sts and not std) then
				keep=source
			elseif (std and not sts) then
				-- Can't really happen given it was in posix.dir(),
				-- but let's err on the safe side
				keep=dest
			else
				if (sts.type == "link" and std.type == "link") then
					-- Link in both... Let's see if either one
					-- is dangling first...
					local rls=posix.readlink(source .. "/" .. p)
					if rls == nil then return false end
					local rld=posix.readlink(dest .. "/" .. p)
					if rld == nil then return false end
					local wd=posix.getcwd()
					posix.chdir(source)
					if (not posix.stat(rls)) then
						-- Dangling in source -- keep dest
						keep=dest
					end
					posix.chdir(dest)
					if (not posix.stat(rld)) then
						-- Dangling in dest -- keep source
						keep=source
					end
					posix.chdir(wd)
					if not keep then
						if (string.find(rls, dest) == 1) then
							-- Source is symlink to dest -- keep dest
							keep=dest
						elseif (string.find(rld, source) == 1) then
							-- Dest is symlink to source -- keep source
							keep=source

						else
							-- Last resort, let's keep a symlink that
							-- doesn't go outside of the directory first
							-- and default to keeping dest if we're
							-- still unsure
							if (string.find(rls, "../") ~= 1 and string.find(rls, "/") ~= 1) then
								keep=source
							else
								keep=dest
							end
						end
					end
				elseif (sts.type == "link") then
					-- Link in source, file in dest -- keep the file
					keep=dest
				else
					-- Link in dest, file in source -- keep the file
					keep=source
				end
			end
			if(keep == source) then
				posix.unlink(dest .. "/" .. p)
				omv.mv(source .. "/" .. p, dest .. "/" .. p)
			else
				posix.unlink(source .. "/" .. p)
				omv.mv(dest .. "/" .. p, source .. "/" .. p)
			end
		end
	end
	-- If anything remains (e.g. /lib/systemd vs /usr/lib/systemd directories)
	-- move it around to be on the safe side
	for i,p in pairs(posix.dir(source)) do
		if(p ~= "." and p ~= "..") then
			omv.mv(source .. "/" .. p, dest .. "/" .. p .. ".rpmsave")
		end
	end
	posix.rmdir(source)
	-- Just in case rmdir failed (e.g. because of a file left
	-- for whatever reason)
	omv.movedir(source)
	return true
end

return omv
