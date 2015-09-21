FROM debian:jessie
MAINTAINER ccondit@randomcoder.com

ENV	LFS_VERSION=20150825-systemd

# intial setup ; download all components, setup tmp dirs, add  

ADD     scripts/setup /setupscripts
RUN \
	echo "deb http://ftp.us.debian.org/debian/ jessie main" > /etc/apt/sources.list && \
	echo "deb http://security.debian.org/ jessie/updates main" >> /etc/apt/sources.list && \
	echo "deb http://ftp.us.debian.org/debian/ jessie-updates main" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get install --no-install-recommends -y -q wget build-essential bison gawk m4 texinfo aria2 && \
	rm -rf /var/cache/apt && \
	bash /setupscripts/version-check.sh && \
	bash /setupscripts/library-check.sh && \
	rm -rf /setupscripts && \
	umask 022 && \
	export LC_ALL=POSIX && \
	export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
	export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	mkdir -p /mnt/lfs /mnt/lfs/tools /mnt/lfs/sources && \
	chmod -v a+wt /mnt/lfs/sources && \
	ln -sv /mnt/lfs/tools / && \
	cd /mnt/lfs/sources && \
	wget http://www.linuxfromscratch.org/lfs/view/${LFS_VERSION}/wget-list && \
	wget http://www.linuxfromscratch.org/lfs/view/${LFS_VERSION}/md5sums && \
        aria2c -i /mnt/lfs/sources/wget-list -d /mnt/lfs/sources --check-certificate=false && \
	md5sum -c md5sums

# binutils pass 1
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	cd /mnt/lfs/sources && \
	tar xf binutils-2.25.1.tar.bz2 && \
	cd binutils-2.25.1 && \
	mkdir -p ../binutils-build && \
	cd ../binutils-build && \
	../binutils-2.25.1/configure \
		--prefix=/tools --with-sysroot=/mnt/lfs --with-lib-path=/tools/lib \
		--target=$LFS_TFT --disable-nls --disable-werror && \
	MAKE="make -j4" make && \
	mkdir -v /tools/lib && \
	ln -sv lib /tools/lib64 && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf binutils-2.25.1 binutils-build

# gcc pass 1
ADD scripts/gcc-fix-paths.sh /mnt/lfs/sources/gcc-fix-paths.sh
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	cd /mnt/lfs/sources && \
	tar xf gcc-5.2.0.tar.bz2 && \
	cd gcc-5.2.0 && \
	tar xf ../mpfr-3.1.3.tar.xz && \
	mv -v mpfr-3.1.3 mpfr && \
	tar xf ../gmp-6.0.0a.tar.xz && \
	mv -v gmp-6.0.0 gmp && \
	tar xf ../mpc-1.0.3.tar.gz && \
	mv -v mpc-1.0.3 mpc && \
	bash /mnt/lfs/sources/gcc-fix-paths.sh && \
	mkdir -p ../gcc-build && \
	cd ../gcc-build && \
	../gcc-5.2.0/configure \
		--target=$LFS_TFT --prefix=/tools --with-glibc-version=2.11 --with-sysroot=/mnt/lfs \
		--with-newlib --without-headers --with-local-prefix=/tools \
		--with-native-system-header-dir=/tools/include --disable-nls --disable-shared \
		--disable-multilib --disable-decimal-float --disable-threads --disable-libatomic \
		--disable-libgomp --disable-libquadmath --disable-libssp --disable-libvtv \
		--disable-libstdcxx --enable-languages=c,c++ && \
	MAKE="make -j4" make && make install && \
	cd /mnt/lfs/sources && \
	rm -rf gcc-5.2.0 gcc-build

# linux headers
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf linux-4.1.6.tar.xz && \
	cd linux-4.1.6 && \
	make mrproper && \
	make INSTALL_HDR_PATH=dest headers_install && \
	cp -rv dest/include/* /tools/include && \
	cd /mnt/lfs/sources && \
	rm -rf linux-4.1.6

# glibc
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
        tar xf glibc-2.22.tar.xz && \
	cd glibc-2.22 && \
	patch -Np1 -i ../glibc-2.22-upstream_i386_fix-1.patch && \
	mkdir -p ../glibc-build && \
	cd ../glibc-build && \
	../glibc-2.22/configure \
		--prefix=/tools --host=$LFS_TFT --build=$(../glibc-2.22/scripts/config.guess) \
		--disable-profile --enable-kernel=2.6.32 --enable-obsolete-rpc \
		--with-headers=/tools/include libc_cv_forced_unwind=yes \
		libc_cv_ctors_header=yes libc_cv_c_cleanup=yes && \
	MAKE="make -j4" make && \
	make install && \
	echo 'main(){}' > dummy.c && \
	$LFS_TFT-gcc dummy.c && \
	readelf -l a.out | grep ': /tools' && \
	rm -v dummy.c a.out && \
	cd /mnt/lfs/sources && \
	rm -rf glibc-2.22 glibc-build

# libstdc++
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
        tar xf gcc-5.2.0.tar.bz2 && \
        cd gcc-5.2.0 && \
	mkdir -p ../gcc-build && \
	cd ../gcc-build && \
	../gcc-5.2.0/libstdc++-v3/configure \
		--host=$LFS_TFT --prefix=/tools --disable-multilib --disable-nls \
		--disable-libstdcxx-threads --disable-libstdcxx-pch \
		--with-gxx-include-dir=/tools/$LFS_TFT/include/c++/5.2.0 && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf gcc-5.2.0

# binutils pass 2
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	cd /mnt/lfs/sources && \
	tar xf binutils-2.25.1.tar.bz2 && \
	cd binutils-2.25.1 && \
	mkdir -p ../binutils-build && \
	cd ../binutils-build && \
	CC=$LFS_TFT-gcc AR=$LFS_TFT-ar RANLIB=$LFS_TFT-ranlib \
	../binutils-2.25.1/configure \
		--prefix=/tools --disable-nls --disable-werror \
		--with-lib-path=/tools/lib --with-sysroot && \
	MAKE="make -j4" make && \
	make install && \
	make -C ld clean && \
	MAKE="make -j4" make -C ld LIB_PATH=/usr/lib:/lib && \
	cp -v ld/ld-new /tools/bin && \
	cd /mnt/lfs/sources && \
	rm -rf binutils-2.25.1 binutils-build

# gcc pass 2
ADD scripts/gcc-pass2-make-limits-h.sh /mnt/lfs/sources/gcc-pass2-make-limits-h.sh

RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	cd /mnt/lfs/sources && \
	tar xf gcc-5.2.0.tar.bz2 && \
	cd gcc-5.2.0 && \
	tar xf ../mpfr-3.1.3.tar.xz && \
	mv -v mpfr-3.1.3 mpfr && \
	tar xf ../gmp-6.0.0a.tar.xz && \
	mv -v gmp-6.0.0 gmp && \
	tar xf ../mpc-1.0.3.tar.gz && \
	mv -v mpc-1.0.3 mpc && \
	bash /mnt/lfs/sources/gcc-pass2-make-limits-h.sh && \
	bash /mnt/lfs/sources/gcc-fix-paths.sh && \
	mkdir -p ../gcc-build && \
	cd ../gcc-build && \
	CC=$LFS_TFT-gcc CXX=$LFS_TFT-g++ AR=$LFS_TFT-ar RANLIB=$LFS_TFT-ranlib \
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
	cd /mnt/lfs/sources && \
	rm -rf gcc-5.2.0 gcc-build

# tcl-core
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	cd /mnt/lfs/sources && \
	tar xf tcl-core8.6.4-src.tar.gz && \
	cd tcl8.6.4 && \
	cd unix && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make install && \
	chmod -v u+w /tools/lib/libtcl8.6.so && \
	make install-private-headers && \
	ln -sv tclsh8.6 /tools/bin/tclsh && \
	cd /mnt/lfs/sources && \
	rm -rf tcl8.6.4

# expect
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	cd /mnt/lfs/sources && \
	tar xf expect5.45.tar.gz && \
	cd expect5.45 && \
	cp -fv configure configure.orig && \
	sed 's:/usr/local/bin:/bin:' configure.orig > configure && \
	./configure --prefix=/tools --with-tcl=/tools/lib --with-tclinclude=/tools/include && \
	MAKE="make -j4" make && \
	make SCRIPTS="" install && \
	cd /mnt/lfs/sources && \
	rm -rf expect5.45

# dejagnu
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf dejagnu-1.5.3.tar.gz && \
	cd dejagnu-1.5.3 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make install && \
	cd /mnt/lfs/sources && \
	rm -rf dejagnu-1.5.3

# check
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf check-0.10.0.tar.gz && \
	cd check-0.10.0 && \
	PKG_CONFIG= ./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf check-0.10.0

# ncurses
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf ncurses-6.0.tar.gz && \
	cd ncurses-6.0 && \
	sed -i s/mawk// configure && \
	./configure \
		--prefix=/tools --with-shared --without-debug --without-ada \
		--enable-widec --enable-overwrite && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf ncurses-6.0

# bash
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf bash-4.3.30.tar.gz && \
	cd bash-4.3.30 && \
	./configure --prefix=/tools --without-bash-malloc && \
	MAKE="make -j4" make && \
	make install && \
	ln -sv bash /tools/bin/sh && \
	cd /mnt/lfs/sources && \
	rm -rf bash-4.3.30

# bzip2
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf bzip2-1.0.6.tar.gz && \
	cd bzip2-1.0.6 && \
	MAKE="make -j4" make && \
	make PREFIX=/tools install && \
	cd /mnt/lfs/sources && \
	rm -rf bzip2-1.0.6

# coreutils 
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf coreutils-8.24.tar.xz && \
	cd coreutils-8.24 && \
	FORCE_UNSAFE_CONFIGURE=1 ./configure \
		--prefix=/tools --enable-install-program=hostname && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf coreutils-8.24

# diffutils
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf diffutils-3.3.tar.xz && \
	cd diffutils-3.3 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf diffutils-3.3

# file
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf file-5.24.tar.gz && \
	cd file-5.24 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf file-5.24

# findutils
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf findutils-4.4.2.tar.gz && \
	cd findutils-4.4.2 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf findutils-4.4.2

# gawk
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf gawk-4.1.3.tar.xz && \
	cd gawk-4.1.3 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf gawk-4.1.3

# gettext
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf gettext-0.19.5.1.tar.xz && \
	cd gettext-0.19.5.1 && \
	cd gettext-tools && \
	EMACS="no" ./configure --prefix=/tools --disable-shared && \
	MAKE="make -j4" make -C gnulib-lib && \
	MAKE="make -j4" make -C intl pluralx.c && \
	MAKE="make -j4" make -C src msgfmt && \
	MAKE="make -j4" make -C src msgmerge && \
	MAKE="make -j4" make -C src xgettext && \
	cp -f src/msgfmt src/msgmerge src/xgettext /tools/bin && \
	cd /mnt/lfs/sources && \
	rm -rf gettext-0.19.5.1

# grep
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf grep-2.21.tar.xz && \
	cd grep-2.21 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf grep-2.21

# gzip
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf gzip-1.6.tar.xz && \
	cd gzip-1.6 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf gzip-1.6

# m4
RUN \
	umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf m4-1.4.17.tar.xz && \
	cd m4-1.4.17 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf m4-1.4.17

# make
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf make-4.1.tar.bz2 && \
	cd make-4.1 && \
	./configure --prefix=/tools --without-guile && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf make-4.1

# patch
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf patch-2.7.5.tar.xz && \
	cd patch-2.7.5 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf patch-2.7.5

# perl
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
        tar xf perl-5.22.0.tar.bz2 && \
	cd perl-5.22.0 && \
	sh Configure -des -Dprefix=/tools -Dlibs=-lm && \
	MAKE="make -j4" make && \
	cp -v perl cpan/podlators/pod2man /tools/bin && \
	mkdir -pv /tools/lib/perl5/5.22.0 && \
	cp -Rv lib/* /tools/lib/perl5/5.22.0 && \
	cd /mnt/lfs/sources && \
	rm -rf perl-5.22.0

# sed
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
        tar xf sed-4.2.2.tar.bz2 && \
	cd sed-4.2.2 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf sed-4.2.2

# tar
ADD patches/tar-1.28-inode-fix.patch /mnt/lfs/sources/tar-1.28-inode-fix.patch

RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
        tar xf tar-1.28.tar.xz && \
	cd tar-1.28 && \
	patch -p1 < ../tar-1.28-inode-fix.patch && \
	FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/tools && \
	make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf tar-1.28

# texinfo
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
	tar xf texinfo-6.0.tar.xz && \
	cd texinfo-6.0 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf texinfo-6.0

# util-linux
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
        tar xf util-linux-2.26.2.tar.xz && \
	cd util-linux-2.26.2 && \
	./configure \
		--prefix=/tools --without-python --disable-makeinstall-chown \
		 --without-systemdsystemunitdir PKG_CONFIG="" && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf util-linux-2.26.2

# xz
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
        cd /mnt/lfs/sources && \
        tar xf xz-5.2.1.tar.xz && \
	cd xz-5.2.1 && \
	./configure --prefix=/tools && \
	MAKE="make -j4" make && \
	make install && \
	cd /mnt/lfs/sources && \
	rm -rf xz-5.2.1

# cleanup
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        export LFS_TGT=$(uname -m)-lfs-linux-gnu && \
        export PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin && \
	strip --strip-debug /tools/lib/* || /bin/true && \
	/usr/bin/strip --strip-unneeded /tools/bin/* /tools/sbin/* || /bin/true && \
	rm -rf \
		/tools/info /tools/man /tools/doc \
		/tools/share/info /tools/share/man /tools/share/doc && \
	chown -R root:root /mnt/lfs/tools && \
	rm /tools && \
	mv /mnt/lfs/tools /tools && \
	mv /mnt/lfs/sources /sources && \
	rm -rf /mnt/lfs && \
	rm -rf /bin /boot /etc /home /lib /lib64 /media /mnt /opt /root /sbin /srv /tmp /usr /var || //tools/bin/true && \
	/tools/bin/mkdir /root

ENV PATH=/bin:/sbin:/usr/bin:/usr/sbin:/tools/bin:/tools/sbin

CMD ["/tools/bin/bash"]
