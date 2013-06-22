# Please update release notes:
# make -C SOURCES release-notes.{html,txt}
#

%define am_i_cooker 1
%if %am_i_cooker
%define distrib Cooker
%else
%define distrib Official
%endif
%define version 2013.0
%define distname Beta (Twelve Angry Penguins)
%define _distribution %(echo %{distribution} | tr A-Z a-z |sed -e 's#[ /()!?]#_#g')

%define product_vendor %{vendor}
%define product_distribution %{distribution}
%define product_type Basic
%define product_version %{version}
%if %am_i_cooker
%define product_branch Devel
%else
%define product_branch Official
%endif
%define product_release 1
%define product_arch %{_target_cpu}

%define product_id_base vendor=%product_vendor,distribution=%product_distribution,type=%product_type,version=%product_version,branch=%product_branch,release=%product_release,arch=%product_arch

%if %am_i_cooker
    %define unstable %%_with_unstable --with-unstable
%endif

# The mandriva release, what is written on box
%define mandriva_release %{version}

# The mandriva branch: Cooker, Community or Official
%define mandriva_branch %{distrib}

# The mandriva arch, notice: using %_target_cpu is bad
# elsewhere because this depend of the config of the packager
# _target_cpu => package build for
# mandriva_arch => the distribution we are using
%define mandriva_arch %{_target_cpu}

# To be coherent with %mandriva_arch I provide os too
# be I wonder it will be linux for a long time
%define mandriva_os %{_target_os}

%define realversion %{version}
%define mdkver %(echo %{version} | sed 's/\\.//')0

Summary:	%{distribution} release file
Name:		distro-release
Version:	2013.0
Release:	0.14
Epoch:		1
License:	GPLv2+
URL:		%{disturl}
Group:		System/Configuration/Other
Source0:	%{name}.tar.xz
Source3:	CREDITS
# edited lynx -dump of wiki:
Source4:	release-notes.txt
Source5:	release-notes.html

%description
%{distribution} release file.

%package	common
Summary:	%{distribution} release common files
Group:		System/Configuration/Other
Conflicts:	%{name} < %{version}-%{release}
Obsoletes:	mandriva-release-Discovery
Obsoletes:	mandriva-release-Powerpack+
Obsoletes:	%{name} < %{version}-%{release}
Obsoletes:	rawhide-release
Obsoletes:	redhat-release
Obsoletes:	mandrake-release
Obsoletes:	mandrakelinux-release
%rename		rosa-release-common
%rename		mandriva-release-common
%rename		opemandriva-release-common
# (tpg) older releases provides %{_sysconfdir}/os-release
Conflicts:	systemd < 37-5
Requires:	lsb-release

# cf mdvbz#32631
Provides:	arch(%_target_cpu)
Provides:	%arch_tagged %{_vendor}-release-common

%description	common
Common files for %{distribution} release packages.

%define release_package(s) \
%{-s:%package %1} \
Summary:	%{distribution} release file%{?1: for %1} \
Group:		System/Configuration/Other \
Requires:	%{arch_tagged %{_vendor}-release-common} \
Requires(post):	coreutils \
Provides:	redhat-release rawhide-release mandrake-release \
Provides:	mandrakelinux-release \
Provides:	%{name} = %{version}-%{release} \
Provides:	mandriva-release = %{version}-%{release} \

%define release_descr(s) \
%description %{-s:%1} \
%{distribution} release file for %1 flavor. \


%define release_post(s) \
%post %{-s:%1} \
ln -fs product.id.%1 %{_sysconfdir}/product.id


%define release_install(s) \
cat > %{buildroot}%{_sysconfdir}/product.id.%{1} << EOF \
%{product_id_base},product=%1\
EOF\
 \
mkdir -p %{buildroot}%_sys_macros_dir \
cat > %{buildroot}%_sys_macros_dir/%{1}.macros << EOF \
%%mandriva_release  %mandriva_release\
%%mandriva_branch   %mandriva_branch\
%%mandriva_arch     %mandriva_arch\
%%mandriva_os       %mandriva_os\
%%mandriva_class    %%(. %{_sysconfdir}/sysconfig/system; echo \\\$META_CLASS)\
%%mdkver            %mdkver\
%%mdvver            %%mdkver\
\
# productid variable\
%%product_id %{product_id_base},product=%{1}\
\
%%product_vendor        %product_vendor\
%%product_distribution  %product_distribution\
%%product_type          %product_type\
%%product_version       %product_version\
%%product_branch        %product_branch\
%%product_release       %product_release\
%%product_arch          %product_arch\
%%product_product       %1\
\
 %{?unstable}\
EOF\
 \
mkdir -p %{buildroot}%{_sysconfdir}/sysconfig \
cat > %{buildroot}%{_sysconfdir}/sysconfig/system << EOF \
SECURITY=3\
CLASS=beginner\
LIBSAFE=no\
META_CLASS=download\
EOF\


%release_package -s Moondrake
%release_package -s OpenMandriva

%rename		mandriva-release-Free
%rename		mandriva-release-One
%rename		mandriva-release-Powerpack
%rename		mandriva-release-Mini
%rename		openmandriva-release-Free
%rename		openmandriva-release-One
%rename		openmandriva-release-Powerpack
%rename		openmandriva-release-Mini

%release_descr -s Moondrake
%release_descr -s OpenMandriva


%prep
%setup -q -n %{name}

cp -a %{SOURCE3} CREDITS
cp -a %{SOURCE4} release-notes.txt
cp -a %{SOURCE5} release-notes.html

cat > README.urpmi << EOF
This is %{distribution} %{version}

You can find the release notes in %{_docdir}/%{name}-common/release-notes.txt

or on the web at http://wiki.%{_vendor}.com/en/%{version}_Notes
EOF

# check that CREDITS file is in UTF-8, fail otherwise
if iconv -f utf-8 -t utf-8 < CREDITS > /dev/null
then
	true
else
	echo "the CREDITS file *MUST* be encoded in UTF-8"
	echo "please fix it before continuing"
	false
fi

%install
mkdir -p %{buildroot}%{_sysconfdir}
touch %{buildroot}%{_sysconfdir}/product.id

echo "%{distribution} release %{realversion} %{distname} for %{_target_cpu}" > %{buildroot}%{_sysconfdir}/mandriva-release
ln -sf mandriva-release %{buildroot}%{_sysconfdir}/redhat-release
ln -sf mandriva-release %{buildroot}%{_sysconfdir}/mandrake-release
ln -sf mandriva-release %{buildroot}%{_sysconfdir}/release
ln -sf mandriva-release %{buildroot}%{_sysconfdir}/mandrakelinux-release
ln -sf mandriva-release %{buildroot}%{_sysconfdir}/rosa-release
ln -sf mandriva-release %{buildroot}%{_sysconfdir}/system-release

echo "%{version}.0 %{release} %{distname}" > %{buildroot}%{_sysconfdir}/version

# (tpg) follow standard specifications http://0pointer.de/blog/projects/os-release
cat > %{buildroot}%{_sysconfdir}/os-release << EOF
NAME="%{distribution}"
VERSION="%{realversion} %{distname}"
ID=%{_vendor}
VERSION_ID=%{realversion}
PRETTY_NAME="%{distribution} %{realversion} %{distname}"
ANSI_COLOR="1;43"
CPE_NAME="cpe:/o:%{_vendor}:%{_distribution}:%{realversion}"
HOME_URL="%{disturl}"
BUG_REPORT_URL="%{bugurl}"
EOF

mkdir -p %{buildroot}%{_sysconfdir}/profile.d
cat > %{buildroot}%{_sysconfdir}/profile.d/10distro-release.csh << EOF
if ( -r %{_sysconfdir}/sysconfig/system ) then
	eval `sed 's|^#.*||' %{_sysconfdir}/sysconfig/system | sed 's|\([^=]*\)=\([^=]*\)|set \1=\2|g' | sed 's|$|;|' `
	setenv META_CLASS $META_CLASS
else
	setenv META_CLASS unknown
endif
EOF

cat > %{buildroot}%{_sysconfdir}/profile.d/10distro-release.sh << EOF
if [ -r %{_sysconfdir}/sysconfig/system ]; then
	. %{_sysconfdir}/sysconfig/system
	export META_CLASS
else
	export META_CLASS=unknown
fi
EOF

%release_install Moondrake Moondrake
%release_install OpenMandriva OpenMandriva


%check
%if %{am_i_cooker}
case %{release} in
    0.*) ;;
    *)
    echo "Cooker distro should have this package with release < %{mkrel 1}"
    exit 1
    ;;
esac
%endif

%release_post -s Moondrake
%release_post -s OpenMandriva


%define release_files(s:) \
%files %{-s:%{-s*}} \
%{_sys_macros_dir}/%{1}.macros \
%{_sysconfdir}/product.id.%1

%release_files -s Moondrake Moondrake
%release_files -s OpenMandriva OpenMandriva


%files common
%doc CREDITS distro.txt README.urpmi release-notes.*
%ghost %{_sysconfdir}/product.id
%{_sysconfdir}/*-release
%{_sysconfdir}/release
%{_sysconfdir}/version
%{_sysconfdir}/profile.d/10distro-release.sh
%{_sysconfdir}/profile.d/10distro-release.csh
%config(noreplace) %verify(not md5 size mtime) %{_sysconfdir}/sysconfig/system
