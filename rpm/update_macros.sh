rm -f $(pwd)/lua/common.lua $(pwd)/lua/forge.lua $(pwd)/build/macros.d/macros.forge
wget https://src.fedoraproject.org/cgit/rpms/redhat-rpm-config.git/plain/common.lua -O $(pwd)/lua/common.lua
wget https://src.fedoraproject.org/cgit/rpms/redhat-rpm-config.git/plain/forge.lua -O $(pwd)/lua/forge.lua
wget https://src.fedoraproject.org/cgit/rpms/redhat-rpm-config.git/plain/macros.forge -O $(pwd)/build/macros.d/macros.forge
