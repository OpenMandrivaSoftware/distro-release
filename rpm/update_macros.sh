rm -f $(pwd)/build/fedora/common.lua $(pwd)/build/fedora/forge.lua $(pwd)/build/macros.d/macros.forge
wget https://src.fedoraproject.org/cgit/rpms/redhat-rpm-config.git/plain/common.lua -O $(pwd)/build/fedora/common.lua
wget https://src.fedoraproject.org/cgit/rpms/redhat-rpm-config.git/plain/forge.lua -O $(pwd)/build/fedora/forge.lua
wget https://src.fedoraproject.org/cgit/rpms/redhat-rpm-config.git/plain/macros.forge -O $(pwd)/build/macros.d/macros.forge
