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

CMD ["/bin/bash"]
