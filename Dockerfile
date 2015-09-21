FROM debian:jessie
MAINTAINER ccondit@randomcoder.com

ADD	scripts /scripts/

ENV	LFS=/mnt/lfs LFS_VERSION=20150825-systemd

# download all components
RUN \
	echo "deb http://ftp.us.debian.org/debian/ jessie main" > /etc/apt/sources.list && \
	echo "deb http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
	echo "deb http://ftp.us.debian.org/debian/ jessie-updates main" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get install --no-install-recommends -y -q wget build-essential bison gawk m4 texinfo aria2 && \
	rm -rf /var/cache/apt && \
	bash /scripts/version-check.sh && \
	bash /scripts/library-check.sh && \
	umask 022 && \
	export LC_ALL=POSIX && \
	export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
	export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	mkdir -p $LFS $LFS/tools $LFS/sources && \
	chmod -v a+wt $LFS/sources && \
	ln -sv $LFS/tools / && \
	cd $LFS/sources && \
	wget http://www.linuxfromscratch.org/lfs/view/${LFS_VERSION}/wget-list && \
	wget http://www.linuxfromscratch.org/lfs/view/${LFS_VERSION}/md5sums && \
        aria2c -i $LFS/sources/wget-list -d $LFS/sources --check-certificate=false && \
	md5sum -c md5sums

# binutils pass 1
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	cd $LFS/sources && \
	tar xf binutils-2.25.1.tar.bz2 && \
	cd binutils-2.25.1 && \
	mkdir -p ../binutils-build && \
	cd ../binutils-build && \
	../binutils-2.25.1/configure \
		--prefix=/tools --with-sysroot=$LFS --with-lib-path=/tools/lib \
		--target=$LFS_TGT --disable-nls --disable-werror && \
	MAKE="make -j4" make && \
	mkdir -v /tools/lib && \
	ln -sv lib /tools/lib64 && \
	make install && \
	cd $LFS/sources && \
	rm -rf binutils-2.25.1 binutils-build

# gcc pass 1
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	cd $LFS/sources && \
	tar xf gcc-5.2.0.tar.bz2 && \
	cd gcc-5.2.0 && \
	tar xf ../mpfr-3.1.3.tar.xz && \
	mv -v mpfr-3.1.3 mpfr && \
	tar xf ../gmp-6.0.0a.tar.xz && \
	mv -v gmp-6.0.0 gmp && \
	tar xf ../mpc-1.0.3.tar.gz && \
	mv -v mpc-1.0.3 mpc && \
	bash /scripts/gcc-pass1-fix-paths.sh && \
	mkdir -p ../gcc-build && \
	cd ../gcc-build && \
	../gcc-5.2.0/configure \
		--target=$LFS_TGT --prefix=/tools --with-glibc-version=2.11 --with-sysroot=$LFS \
		--with-newlib --without-headers --with-local-prefix=/tools \
		--with-native-system-header-dir=/tools/include --disable-nls --disable-shared \
		--disable-multilib --disable-decimal-float --disable-threads --disable-libatomic \
		--disable-libgomp --disable-libquadmath --disable-libssp --disable-libvtv \
		--disable-libstdcxx --enable-languages=c,c++ && \
	MAKE="make -j4" make && make install && \
	cd $LFS/sources && \
	rm -rf gcc-5.2.0 gcc-build

# linux headers
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd $LFS/sources && \
	tar xf linux-4.1.6.tar.xz && \
	cd linux-4.1.6 && \
	make mrproper && \
	make INSTALL_HDR_PATH=dest headers_install && \
	cp -rv dest/include/* /tools/include && \
	cd $LFS/sources && \
	rm -rf linux-4.1.6

# glibc
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd $LFS/sources && \
        tar xf glibc-2.22.tar.xz && \
	cd glibc-2.22 && \
	patch -Np1 -i ../glibc-2.22-upstream_i386_fix-1.patch && \
	mkdir -p ../glibc-build && \
	cd ../glibc-build && \
	../glibc-2.22/configure \
		--prefix=/tools --host=$LFS_TGT --build=$(../glibc-2.22/scripts/config.guess) \
		--disable-profile --enable-kernel=2.6.32 --enable-obsolete-rpc \
		--with-headers=/tools/include libc_cv_forced_unwind=yes \
		libc_cv_ctors_header=yes libc_cv_c_cleanup=yes && \
	MAKE="make -j4" make && \
	make install && \
	echo 'main(){}' > dummy.c && \
	$LFS_TGT-gcc dummy.c && \
	readelf -l a.out | grep ': /tools' && \
	rm -v dummy.c a.out && \
	cd $LFS/sources && \
	rm -rf glibc-2.22

# libstdc++
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd $LFS/sources && \
        tar xf gcc-5.2.0.tar.bz2 && \
        cd gcc-5.2.0 && \
	mkdir -p ../gcc-build && \
	cd ../gcc-build && \
	../gcc-5.2.0/libstdc++-v3/configure \
		--host=$LFS_TGT --prefix=/tools --disable-multilib --disable-nls \
		--disable-libstdcxx-threads --disable-libstdcxx-pch \
		--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/5.2.0 && \
	MAKE="make -j4" make && \
	make install && \
	cd $LFS/sources && \
	rm -rf gcc-5.2.0

# binutils pass 2
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	cd $LFS/sources && \
	tar xf binutils-2.25.1.tar.bz2 && \
	cd binutils-2.25.1 && \
	mkdir -p ../binutils-build && \
	cd ../binutils-build && \
	CC=$LFS_TGT-gcc AR=$LFS_TGT-ar RANLIB=$LFS_TGT-ranlib \
	../binutils-2.25.1/configure \
		--prefix=/tools --disable-nls --disable-werror \
		--with-lib-path=/tools/lib --with-sysroot && \
	MAKE="make -j4" make && \
	make install && \
	make -C ld clean && \
	MAKE="make -j4" make -C ld LIB_PATH=/usr/lib:/lib && \
	cp -v ld/ld-new /tools/bin && \
	cd $LFS/sources && \
	rm -rf binutils-2.25.1 binutils-build

# gcc pass 2
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	cd $LFS/sources && \
	tar xf gcc-5.2.0.tar.bz2 && \
	cd gcc-5.2.0 && \
	tar xf ../mpfr-3.1.3.tar.xz && \
	mv -v mpfr-3.1.3 mpfr && \
	tar xf ../gmp-6.0.0a.tar.xz && \
	mv -v gmp-6.0.0 gmp && \
	tar xf ../mpc-1.0.3.tar.gz && \
	mv -v mpc-1.0.3 mpc && \
	bash /scripts/gcc-pass2-make-limits-h.sh && \
	bash /scripts/gcc-pass2-fix-paths.sh && \
	mkdir -p ../gcc-build && \
	cd ../gcc-build && \
	CC=$LFS_TGT-gcc CXX=$LFS_TGT-g++ AR=$LFS_TGT-ar RANLIB=$LFS_TGT-ranlib \
	../gcc-5.2.0/configure \
		--prefix=/tools --with-local-prefix=/tools \
		--with-native-system-header-dir=/tools/include --enable-languages=c,c++ \
		--disable-libstdcxx-pch --disable-multilib --disable-bootstrap \
		--disable-libgomp && \
	MAKE="make -j4" make && \
	make install && \
	ln -sv gcc /tools/bin/cc && \
	echo 'main(){}' > dummy.c && \
	cc dummy.c && \
	readelf -l a.out | grep ': /tools' && \
	rm -v dummy.c a.out && \
	cd $LFS/sources && \
	rm -rf gcc-5.2.0 gcc-build

# tcl-core
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	cd $LFS/sources && \
	tar xf tcl-core8.6.4-src.tar.gz && \
	cd tcl8.6.4 && \
	cd unix && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	TZ=UTC make test && \
	make install && \
	chmod -v u+w /tools/lib/libtcl8.6.so && \
	make install-private-headers && \
	ln -sv tclsh8.6 /tools/bin/tclsh && \
	cd $LFS/sources && \
	rm -rf tcl8.6.4

# expect
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	cd $LFS/sources && \
	tar xf expect5.45.tar.gz && \
	cd expect5.45 && \
	cp -fv configure configure.orig && \
	sed 's:/usr/local/bin:/bin:' configure.orig > configure && \
	./configure --prefix=/tools --with-tcl=/tools/lib --with-tclinclude=/tools/include && \
	MAKE="make -j4" make && \
	make test && \
	make SCRIPTS="" install && \
	cd $LFS/sources && \
	rm -rf expect5.45

# dejagnu
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd $LFS/sources && \
	tar xf dejagnu-1.5.3.tar.gz && \
	cd dejagnu-1.5.3 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make install && \
	make check && \
	cd $LFS/sources && \
	rm -rf dejagnu-1.5.3

CMD ["/bin/bash"]
