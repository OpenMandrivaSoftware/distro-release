#
# Macros for cmake
#

%__cmake	%{_bindir}/cmake

%_cmake_lib_suffix64	-DLIB_SUFFIX=64
%_cmake_skip_rpath	-DCMAKE_SKIP_RPATH:BOOL=ON
%_cmake_debug		%{?with_debug:Debug}%{?!with_debug:RelWithDebInfo}
%_cmake_verbose		%{?with_debug:-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON}%{nil}
%_cmake_version		%(%{__cmake} --version|sed -e 's#.* \(\S*\)$#\1#g')

%cmake \
	%set_build_flags \
	mkdir -p ${CMAKE_BUILD_DIR:-build} \
	cd ${CMAKE_BUILD_DIR:-build} \
	CROSSCOMPILE="" ; \
%ifnarch noarch \
%if %{cross_compiling} \
	PKG_CONFIG_LIBDIR="%{_prefix}/%{_target_platform}/%{_lib}/pkgconfig:%{_prefix}/%{_target_platform}/lib/pkgconfig:%{_datadir}/pkgconfig:$PKG_CONFIG_LIBDIR" \\\
	PKG_CONFIG_PATH="%{_prefix}/%{_target_platform}/%{_lib}/pkgconfig:%{_prefix}/%{_target_platform}/lib/pkgconfig:%{_datadir}/pkgconfig:$PKG_CONFIG_PATH" \\\
	CROSSCOMPILE="-DCMAKE_TOOLCHAIN_FILE=\"%{_datadir}/cmake/toolchains/%{_target_platform}%{?prefer_gcc:-gcc}.toolchain\" -DCMAKE_CROSSCOMPILING:BOOL=ON -DPKG_CONFIG_EXECUTABLE=%{_bindir}/pkg-config -DPYTHON_EXECUTABLE=%{_bindir}/python -DPython3_EXECUTABLE=%{_bindir}/python" ; \
%endif \
%endif \
	export CROSSCOMPILE ; \
	%__cmake .. \\\
		$CROSSCOMPILE \\\
		%{_cmake_skip_rpath} \\\
		%{_cmake_verbose} \\\
		-DCMAKE_INSTALL_PREFIX:PATH=%{_prefix} \\\
		-DCMAKE_INSTALL_LIBDIR:PATH=%{_lib} \\\
		-DCMAKE_INSTALL_SBINDIR:PATH=bin \\\
		-DCMAKE_INSTALL_DO_STRIP:BOOL=OFF \\\
		-DLIB_INSTALL_DIR:PATH=%{_lib} \\\
		-DSYSCONF_INSTALL_DIR:PATH=%{_sysconfdir} \\\
		-DCMAKE_BUILD_TYPE=%{_cmake_debug} \\\
		-DOpenGL_GL_PREFERENCE=GLVND \\\
		-DKDE_USE_QT_SYS_PATHS:BOOL=ON \\\
%if "%{?_lib}" == "lib64" \
		%{?_cmake_lib_suffix64} \\\
%endif \
		%{?_cmake_skip_rpath} \\\
		%{?_cmake_verbose: -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON} \\\
		-DBUILD_SHARED_LIBS:BOOL=ON \\\
		-DBUILD_STATIC_LIBS:BOOL=OFF \\\
		-DCMAKE_C_FLAGS="${CFLAGS:-%{optflags}}" \\\
		-DCMAKE_C_FLAGS_RELEASE="${CFLAGS:-%{optflags}} -DNDEBUG" \\\
		-DCMAKE_C_FLAGS_RELWITHDEBINFO="${CFLAGS:-%{optflags}}" \\\
		-DCMAKE_CXX_FLAGS="${CXXFLAGS:-%{optflags}}" \\\
		-DCMAKE_CXX_FLAGS_RELEASE="${CXXFLAGS:-%{optflags}} -DNDEBUG" \\\
		-DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${CXXFLAGS:-%{optflags}}" \\\
		-DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS:-%{build_ldflags}}" \\\
		-DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS:-%{build_ldflags}}" \\\
		-DCMAKE_MODULE_LINKER_FLAGS="%(echo ${LDFLAGS:-%{build_ldflags}}|sed -e 's#-Wl,--no-undefined##')"

%cmake32 \
	mkdir -p ${CMAKE_BUILD_DIR32:-build32} \
	cd ${CMAKE_BUILD_DIR32:-build32} \
	CROSSCOMPILE="" ; \
%ifnarch noarch \
%if %{cross_compiling} \
	CROSSCOMPILE="-DCMAKE_TOOLCHAIN_FILE=\"%_prefix/%_target_platform/share/cmake/%_target_platform.toolchain\" -DCMAKE_CROSSCOMPILING:BOOL=ON -DPKG_CONFIG_EXECUTABLE=%{_bindir}/pkg-config -DPYTHON_EXECUTABLE=%{_bindir}/python -DPython3_EXECUTABLE=%{_bindir}/python" ; \
%endif \
%endif \
	export CROSSCOMPILE ; \
	[ -z "$CFLAGS32"] && CFLAGS32="$(echo ${CFLAGS:-%{optflags}} | sed -e 's, -m64,,g;s, -mx32,,g;s,^-m64 ,,;s,^-mx32 ,,;s, -flto,,g') -m32" ; \
	[ -z "$CXXFLAGS32"] && CXXFLAGS32="$(echo ${CXXFLAGS:-%{optflags}} | sed -e 's, -m64,,g;s, -mx32,,g;s,^-m64 ,,;s,^-mx32 ,,;s, -flto,,g') -m32" ; \
	[ -z "$LDFLAGS32"] && LDFLAGS32="$(echo ${LDFLAGS:-%{build_ldflags}} | sed -e 's, -m64,,g;s, -mx32,,g;s,^-m64 ,,;s,^-mx32 ,,;s, -flto,,g') -m32" ; \
	PKG_CONFIG_LIBDIR="%{_prefix}/lib/pkgconfig:%{_datadir}/pkgconfig:$PKG_CONFIG32_LIBDIR" \\\
	PKG_CONFIG_PATH="%{_prefix}/lib/pkgconfig:%{_datadir}/pkgconfig:$PKG_CONFIG32_PATH" \\\
	%__cmake .. \\\
		$CROSSCOMPILE \\\
		%{_cmake_skip_rpath} \\\
		%{_cmake_verbose} \\\
		-DCMAKE_INSTALL_PREFIX:PATH=%{_prefix} \\\
		-DCMAKE_INSTALL_LIBDIR:PATH=lib \\\
		-DCMAKE_INSTALL_SBINDIR:PATH=bin \\\
		-DCMAKE_INSTALL_DO_STRIP:BOOL=OFF \\\
		-DLIB_INSTALL_DIR:PATH=lib \\\
		-DSYSCONF_INSTALL_DIR:PATH=%{_sysconfdir} \\\
		-DCMAKE_BUILD_TYPE=%{_cmake_debug} \\\
		-DOpenGL_GL_PREFERENCE=GLVND \\\
		-DKDE_USE_QT_SYS_PATHS:BOOL=ON \\\
		%{?_cmake_skip_rpath} \\\
		%{?_cmake_verbose: -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON} \\\
		-DBUILD_SHARED_LIBS:BOOL=ON \\\
		-DBUILD_STATIC_LIBS:BOOL=OFF \\\
		-DCMAKE_C_FLAGS="${CFLAGS32}" \\\
		-DCMAKE_C_FLAGS_RELEASE="${CFLAGS32} -DNDEBUG" \\\
		-DCMAKE_C_FLAGS_RELWITHDEBINFO="${CFLAGS32}" \\\
		-DCMAKE_CXX_FLAGS="${CFLAGS32}" \\\
		-DCMAKE_CXX_FLAGS_RELEASE="${CFLAGS32} -DNDEBUG" \\\
		-DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${CFLAGS32}" \\\
		-DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS32}" \\\
		-DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS32}" \\\
		-DCMAKE_MODULE_LINKER_FLAGS="${LDFLAGS32/-Wl,--no-undefined/}"

#==============================================================================
# Spec file fragments for declarative builds with
# BuildSystem: cmake

%buildsystem_cmake_generate_buildrequires() \
	echo 'cmake' \
	CMAKE_GENERATOR="" \
	ARG_IS_GENERATOR=false \
	for i in %*; do \
		if $ARG_IS_GENERATOR; then \
			CMAKE_GENERATOR="$i" \
			break \
		elif [ "$i" = "-G" ]; then \
			ARG_IS_GENERATOR=true \
		fi \
	done \
	if [ "$CMAKE_GENERATOR" = "Unix Makefiles" ]; then \
		echo 'make' \
	else \
		echo 'ninja' \
	fi

%buildsystem_cmake_conf() \
	CMAKE_BUILD_DIR=_OMV_rpm_build \
	CMAKE_GENERATOR="" \
	EXTRA_ARGS="" \
	ARG_IS_GENERATOR=false \
	for i in %*; do \
		if $ARG_IS_GENERATOR; then \
			CMAKE_GENERATOR="$i" \
			break \
		elif [ "$i" = "-G" ]; then \
			ARG_IS_GENERATOR=true \
		fi \
	done \
	if [ -z "$CMAKE_GENERATOR" ]; then \
		CMAKE_GENERATOR=Ninja \
		EXTRA_ARGS="$EXTRA_ARGS -G Ninja" \
	fi \
	%cmake %* $EXTRA_ARGS \
	cd .. \
%if %{with compat32} \
	CMAKE_BUILD_DIR32=_OMV_rpm_build32 \
	%cmake32 %* $EXTRA_ARGS \
	cd .. \
%endif

%buildsystem_cmake_build() \
%if %{with compat32} \
	%__cmake --build _OMV_rpm_build32 \
%endif \
	%__cmake --build _OMV_rpm_build

%buildsystem_cmake_install() \
%if %{with compat32} \
	DESTDIR="%{buildroot}" %__cmake --install _OMV_rpm_build32 \
%endif \
	DESTDIR="%{buildroot}" %__cmake --install _OMV_rpm_build \
	%find_lang %{name} --all-name --with-qt --with-html --with-man || :
