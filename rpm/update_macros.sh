rm -f $(pwd)/build/fedora/common.lua $(pwd)/build/fedora/forge.lua $(pwd)/build/macros.d/macros.forge
wget https://src.fedoraproject.org/rpms/redhat-rpm-config/raw/rawhide/f/common.lua -O $(pwd)/build/fedora/common.lua
wget https://src.fedoraproject.org/rpms/redhat-rpm-config/raw/rawhide/f/forge.lua -O $(pwd)/build/fedora/forge.lua
wget https://src.fedoraproject.org/rpms/redhat-rpm-config/raw/rawhide/f/macros.forge -O $(pwd)/build/macros.d/macros.forge
