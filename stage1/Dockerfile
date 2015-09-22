FROM ccondit/linuxfromscratch-stage0
MAINTAINER ccondit@randomcoder.com

ENV	LFS_VERSION=20150825-systemd

# initial setup ; create base filesystem assets
ADD assets/etc/passwd /etc/passwd
ADD assets/etc/group /etc/group

RUN \
	umask 022 && \
	mkdir -pv /bin /boot /etc/opt /etc/sysconfig /home /lib/firmware /mnt /opt && \
	mkdir -pv /media/floppy /media/cdrom /sbin /srv /var && \
	install -dv -m 0750 /root && \
	install -dv -m 1777 /tmp /var/tmp && \
	mkdir -pv /usr/bin /usr/include /usr/lib /usr/sbin /usr/src && \
	mkdir -pv /usr/local/bin /usr/local/include /usr/local/lib /usr/local/sbin && \
	mkdir -pv /usr/local/src && \
	mkdir -pv /usr/share/color /usr/share/dict /usr/share/doc /usr/share/info && \
	mkdir -pv /usr/share/locale /usr/share/man && \
	mkdir -pv /usr/local/share/color /usr/local/share/dict && \
	mkdir -pv /usr/local/share/doc /usr/local/share/info && \
	mkdir -pv /usr/local/share/locale /usr/local/share/man && \
	mkdir -pv /usr/share/misc /usr/share/terminfo /usr/share/zoneinfo && \
	mkdir -pv /usr/local/share/misc /usr/local/share/terminfo /usr/local/share/zoneinfo && \
	mkdir -pv /usr/libexec && \
	for dir in 1 2 3 4 5 6 7 8 ; do mkdir -p /usr/share/man/man1 ; done && \
	for dir in 1 2 3 4 5 6 7 8 ; do mkdir -p /usr/local/share/man/man1 ; done && \
	ln -sfv lib /lib64 && \
	ln -sfv lib /usr/lib64 && \
	ln -sfv lib /usr/local/lib64 && \
	mkdir -pv /var/log /var/mail /var/spool && \
	ln -sfv /run /var/run && \
	ln -sfv /run/lock /var/lock && \
	mkdir -pv /var/opt /var/cache /var/lib/color /var/lib/misc /var/lib/locate /var/local && \
	ln -sfv /tools/bin/bash /bin && \
	ln -sfv /tools/bin/cat /bin && \
	ln -sfv /tools/bin/echo /bin && \
	ln -sfv /tools/bin/pwd /bin && \
	ln -sfv /tools/bin/stty /bin && \
	ln -sfv /tools/bin/perl /usr/bin && \
	ln -sfv /tools/lib/libgcc_s.so /usr/lib && \
	ln -sfv /tools/lib/libgcc_s.so.1 /usr/lib && \
	ln -sfv /tools/lib/libstdc++.so /usr/lib && \
	ln -sfv /tools/lib/libstdc++.so.6 /usr/lib && \
	sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la && \
	ln -sfv bash /bin/sh && \
	ln -sfv /proc/self/mounts /etc/mtab && \
	chmod 644 /etc/passwd /etc/group && \
	touch /var/log/btmp /var/log/lastlog /var/log/wtmp && \
	chgrp -v utmp /var/log/lastlog && \
	chmod -v 664 /var/log/lastlog && \
	chmod -v 600 /var/log/btmp

# linux headers
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf linux-4.1.6.tar.xz && \
	cd linux-4.1.6 && \
	make mrproper && \
	make INSTALL_HDR_PATH=dest headers_install && \
	find dest/include \( -name .install -o -name ..install.cmd \) -delete && \
	cp -rv dest/include/* /usr/include && \
	cd /sources && \
	rm -rf linux-4.1.6

# man-pages
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf man-pages-4.02.tar.xz && \
	cd man-pages-4.02 && \
	make install && \
	cd /sources && \
	rm -rf man-pages-4.02

# glibc
ADD assets/etc/nsswitch.conf /etc/nsswitch.conf
ADD assets/etc/ld.so.conf /etc/ld.so.conf

RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf glibc-2.22.tar.xz && \
	cd glibc-2.22 && \
	patch -Np1 -i ../glibc-2.22-fhs-1.patch && \
	patch -Np1 -i ../glibc-2.22-upstream_i386_fix-1.patch && \
	mkdir -pv ../glibc-build && \
	cd ../glibc-build && \
	../glibc-2.22/configure \
		--prefix=/usr --disable-profile --enable-kernel=2.6.32 --enable-obsolete-rpc && \
	MAKE="make -j4" make && \
	touch /etc/ld.so.conf && \
	make install && \
	cp -v ../glibc-2.22/nscd/nscd.conf /etc/nscd.conf && \
	mkdir -pv /var/cache/nscd && \
	install -v -Dm644 ../glibc-2.22/nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf && \
	install -v -Dm644 ../glibc-2.22/nscd/nscd.service /lib/systemd/system/nscd.service && \
	mkdir -pv /usr/lib/locale && \
	localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8 && \
	localedef -i de_DE -f ISO-8859-1 de_DE && \
	localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro && \
	localedef -i de_DE -f UTF-8 de_DE.UTF-8 && \
	localedef -i en_GB -f UTF-8 en_GB.UTF-8 && \
	localedef -i en_HK -f ISO-8859-1 en_HK && \
	localedef -i en_PH -f ISO-8859-1 en_PH && \
	localedef -i en_US -f ISO-8859-1 en_US && \
	localedef -i en_US -f UTF-8 en_US.UTF-8 && \
	localedef -i es_MX -f ISO-8859-1 es_MX && \
	localedef -i fa_IR -f UTF-8 fa_IR && \
	localedef -i fr_FR -f ISO-8859-1 fr_FR && \
	localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro && \
	localedef -i fr_FR -f UTF-8 fr_FR.UTF-8 && \
	localedef -i it_IT -f ISO-8859-1 it_IT && \
	localedef -i it_IT -f UTF-8 it_IT.UTF-8 && \
	localedef -i ja_JP -f EUC-JP ja_JP && \
	localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R && \
	localedef -i ru_RU -f UTF-8 ru_RU.UTF-8 && \
	localedef -i tr_TR -f UTF-8 tr_TR.UTF-8 && \
	localedef -i zh_CN -f GB18030 zh_CN.GB18030 && \
	chmod 644 /etc/nsswitch.conf /etc/ld.so.conf && \
	tar -xf ../tzdata2015f.tar.gz && \
	mkdir -pv /usr/share/zoneinfo/posix /usr/share/zoneinfo/right && \
	for tz in \
		etcetera southamerica northamerica europe africa antarctica \
		asia australasia backward pacificnew systemv ; do \
		zic -L /dev/null -d /usr/share/zoneinfo -y "sh yearistype.sh" ${tz} && \
		zic -L /dev/null -d /usr/share/zoneinfo/posix -y "sh yearistype.sh" ${tz} && \
		zic -L leapseconds -d /usr/share/zoneinfo/right -y "sh yearistype.sh" ${tz} ; done && \
	cp -v zone.tab zone1970.tab iso3166.tab /usr/share/zoneinfo && \
	zic -d /usr/share/zoneinfo -p America/New_York && \
	ln -sfv /usr/share/zoneinfo/UTC /etc/localtime && \
	cd /sources && \
	rm -rf glibc-2.22 glibc-build

# toolchain

RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	mv -v /tools/bin/ld /tools/bin/ld-old && \
	mv -v /tools/$(gcc -dumpmachine)/bin/ld /tools/$(gcc -dumpmachine)/bin/ld-old && \
	mv -v /tools/bin/ld-new /tools/bin/ld && \
	ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld && \
	gcc -dumpspecs | sed -e 's@/tools@@g' \
		-e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
		-e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
		`dirname $(gcc --print-libgcc-file-name)`/specs && \
	echo 'main(){}' > dummy.c && \
	cc dummy.c -v -Wl,--verbose &> dummy.log && \
	readelf -l a.out | grep ': /lib' && \
	grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log && \
	grep -B1 '^ /usr/include' dummy.log && \
	grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g' && \
	grep "/lib.*/libc.so.6 " dummy.log && \
	grep found dummy.log && \
	rm -v dummy.c a.out dummy.log

# zlib
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf zlib-1.2.8.tar.xz && \
	cd zlib-1.2.8 && \
	./configure --prefix=/usr && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	mv -v /usr/lib/libz.so.* /lib && \
	ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so && \
	cd /sources && \
	rm -rf zlib-1.2.8

# file
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf file-5.24.tar.gz && \
	cd file-5.24 && \
	./configure --prefix=/usr && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	cd /sources && \
	rm -rf file-5.24

# binutils
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf binutils-2.25.1.tar.bz2 && \
	cd binutils-2.25.1 && \
	mkdir -pv ../binutils-build && \
	cd ../binutils-build && \
	../binutils-2.25.1/configure --prefix=/usr --enable-shared --disable-werror && \
	MAKE="make -j4" make tooldir=/usr && \
	make check && \
	make tooldir=/usr install && \
	cd /sources && \
	rm -rf binuitls-2.25.1 binutils-build

# gmp
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf gmp-6.0.0a.tar.xz && \
	cd gmp-6.0.0 && \
	./configure \
		--prefix=/usr --enable-cxx --disable-static --docdir=/usr/share/doc/gmp-6.0.0a && \
	MAKE="make -j4" make && \
	make html && \
	make check 2>&1 | tee gmp-check-log && \
	awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log && \
	make install && \
	make install-html && \
	cd /sources && \
	rm -rf gmp-6.0.0

# mpfr
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf mpfr-3.1.3.tar.xz && \
	cd mpfr-3.1.3 && \
	patch -Np1 -i ../mpfr-3.1.3-upstream_fixes-1.patch && \
	./configure \
		--prefix=/usr --disable-static --enable-thread-safe \
		--docdir=/usr/share/doc/mpfr-3.1.3 && \
	MAKE="make -j4" make && \
	make html && \
	make check && \
	make install && \
	make install-html && \
	cd /sources && \
	rm -rf mpfr-3.1.3

# mpc
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf mpc-1.0.3.tar.gz && \
	cd mpc-1.0.3 && \
	./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/mpc-1.0.3 && \
	MAKE="make -j4" make && \
	make html && \
	make check && \
	make install && \
	make install-html && \
	cd /sources && \
	rm -rf mpc-1.0.3

# gcc
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf gcc-5.2.0.tar.bz2 && \
	cd gcc-5.2.0 && \
	mkdir -pv ../gcc-build && \
	cd ../gcc-build && \
	SED=sed ../gcc-5.2.0/configure \
		--prefix=/usr --enable-languages=c,c++ --disable-multilib \
		--disable-bootstrap --with-system-zlib && \
	MAKE="make -j4" make && \
	make install && \
	ln -sv ../usr/bin/cpp /lib && \
	ln -sv gcc /usr/bin/cc && \
	install -v -dm755 /usr/lib/bfd-plugins && \
	ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/5.2.0/liblto_plugin.so \
		/usr/lib/bfd-plugins/ && \
	echo 'main(){}' > dummy.c && \
	cc dummy.c -v -Wl,--verbose &> dummy.log && \
	readelf -l a.out | grep ': /lib' && \
	grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log && \
	grep -B4 '^ /usr/include' dummy.log && \
	grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g' && \
	grep "/lib.*/libc.so.6 " dummy.log && \
	grep found dummy.log && \
	rm -v dummy.c a.out dummy.log && \
	mkdir -pv /usr/share/gdb/auto-load/usr/lib && \
	mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib && \
	cd /sources && \
	rm -rf gcc-5.2.0 gcc-build

# bzip2
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf bzip2-1.0.6.tar.gz && \
	cd bzip2-1.0.6 && \
	patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch && \
	sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile && \
	sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile && \
	make -f Makefile-libbz2_so && \
	make clean && \
	MAKE="make -j4" make && \
	make PREFIX=/usr install && \
	cp -v bzip2-shared /bin/bzip2 && \
	cp -av libbz2.so* /lib && \
	ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so && \
	rm -v /usr/bin/bunzip2 /usr/bin/bzcat /usr/bin/bzip2 && \
	ln -sv bzip2 /bin/bunzip2 && \
	ln -sv bzip2 /bin/bzcat && \
	cd /sources && \
	rm -rf bzip2-1.0.6

# pkg-config
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf pkg-config-0.28.tar.gz && \
	cd pkg-config-0.28 && \
	./configure \
		--prefix=/usr --with-internal-glib --disable-host-tool \
		--docdir=/usr/share/doc/pkg-config-0.28 && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	cd /sources && \
	rm -rf pkg-config-0.28

# ncurses
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf ncurses-6.0.tar.gz && \
	cd ncurses-6.0 && \
	sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in && \
	./configure \
		--prefix=/usr --mandir=/usr/share/man --with-shared --without-debug \
		--without-normal --enable-pc-files --enable-widec && \
	MAKE="make -j4" make && \
	make install && \
	mv -v /usr/lib/libncursesw.so.6* /lib && \
	ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so && \
	for lib in ncurses form panel menu ; do \
		rm -vf /usr/lib/lib${lib}.so && \
		echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so && \
		ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc ; done && \
	rm -vf /usr/lib/libcursesw.so && \
	echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so && \
	ln -sfv libncurses.so /usr/lib/libcurses.so && \
	mkdir -v /usr/share/doc/ncurses-6.0 && \
	cp -v -R doc/* /usr/share/doc/ncurses-6.0 && \
	make distclean && \
	./configure \
		--prefix=/usr --with-shared --without-normal \
		--without-debug --without-cxx-binding && \
	make sources libs && \
	cp -av lib/lib*.so.6* /usr/lib && \
	cd /sources && \
	rm -rf ncurses-6.0

# attr
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf attr-2.4.47.src.tar.gz && \
	cd attr-2.4.47 && \
	sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in && \
	sed -i -e "/SUBDIRS/s|man2||" man/Makefile && \
	./configure --prefix=/usr --disable-static && \
	MAKE="make -j4" make && \
	make install install-dev install-lib && \
	chmod -v 755 /usr/lib/libattr.so && \
	mv -v /usr/lib/libattr.so.* /lib && \
	ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so && \
	cd /sources && \
	rm -rf attr-2.4.47


# acl
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf acl-2.2.52.src.tar.gz && \
	cd acl-2.2.52 && \
	sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in && \
	sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test && \
	sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" libacl/__acl_to_any_text.c && \
	./configure --prefix=/usr --disable-static --libexecdir=/usr/lib && \
	MAKE="make -j4" make && \
	make install install-dev install-lib && \
	chmod -v 755 /usr/lib/libacl.so && \
	mv -v /usr/lib/libacl.so.* /lib && \
	ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so && \
	cd /sources && \
	rm -rf acl-2.2.52

# libcap
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf libcap-2.24.tar.xz && \
	cd libcap-2.24 && \
	sed -i '/install.*STALIBNAME/d' libcap/Makefile && \
	MAKE="make -j4" make && \
	make RAISE_SETFCAP=no prefix=/usr install && \
	chmod -v 755 /usr/lib/libcap.so && \
	mv -v /usr/lib/libcap.so.* /lib && \
	ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so && \
	cd /sources && \
	rm -rf libcap-2.24

# sed
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf sed-4.2.2.tar.bz2 && \
	cd sed-4.2.2 && \
	./configure --prefix=/usr --bindir=/bin --htmldir=/usr/share/doc/sed-4.2.2 && \
	MAKE="make -j4" make && \
	make html && \
	make check && \
	make install && \
	make -C doc install-html && \
	cd /sources && \
	rm -rf sed-4.2.2

# shadow
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf shadow-4.2.1.tar.xz && \
	cd shadow-4.2.1 && \
	sed -i 's/groups$(EXEEXT) //' src/Makefile.in && \
	find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \; && \
	sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
		-e 's@/var/spool/mail@/var/mail@' etc/login.defs && \
	sed -i 's/1000/999/' etc/useradd && \
	./configure --sysconfdir=/etc --with-group-name-max-length=32 && \
	MAKE="make -j4" make && \
	make install && \
	mv -v /usr/bin/passwd /bin && \
	pwconv && \
	grpconv && \
	sed -i 's/yes/no/' /etc/default/useradd && \
	cd /sources && \
	rm -rf shadow-4.2.1

# psmisc
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf psmisc-22.21.tar.gz && \
	cd psmisc-22.21 && \
	./configure --prefix=/usr && \
	MAKE="make -j4" make && \
	make install && \
	mv -v /usr/bin/fuser /bin && \
	mv -v /usr/bin/killall /bin && \
	cd /sources && \
	rm -rf psmisc-22.21

# procps-ng
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf procps-ng-3.3.11.tar.xz && \
	cd  procps-ng-3.3.11 && \
	./configure \
		--prefix=/usr --exec-prefix= --libdir=/usr/lib \
		--docdir=/usr/share/doc/procps-ng-3.3.11 --disable-static --disable-kill && \
	MAKE="make -j4" make && \
	sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp && \
	make check && \
	make install && \
	mv -v /usr/lib/libprocps.so.* /lib && \
	ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so && \
	cd /sources && \
	rm -rf procps-ng-3.3.11	

# e2fsprogs
RUN \
	umask 022 && \
	export LC_ALL=POSIX && \
	cd /sources && \
	tar xf e2fsprogs-1.42.13.tar.gz && \
	cd e2fsprogs-1.42.13 && \
	sed -e '/int.*old_desc_blocks/s/int/blk64_t/' \
		-e '/if (old_desc_blocks/s/super->s_first_meta_bg/desc_blocks/' \
		-i lib/ext2fs/closefs.c && \
	mkdir -v build && \
	cd build && \
	LIBS=-L/tools/lib CFLAGS=-I/tools/include PKG_CONFIG_PATH=/tools/lib/pkgconfig \
	../configure \
		--prefix=/usr --bindir=/bin --with-root-prefix="" --enable-elf-shlibs \
		--disable-libblkid --disable-libuuid --disable-uuidd --disable-fsck && \
	MAKE="make -j4" make && \
	ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib && \
	make LD_LIBRARY_PATH=/tools/lib check && \
	make install && \
	make install-libs && \
	chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a && \
	gunzip -v /usr/share/info/libext2fs.info.gz && \
	install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info && \
	makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo && \
	install -v -m644 doc/com_err.info /usr/share/info && \
	install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info && \
	cd /sources && \
	rm -rf e2fsprogs-1.42.13

# coreutils
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf coreutils-8.24.tar.xz && \
	cd coreutils-8.24 && \
	patch -Np1 -i ../coreutils-8.24-i18n-1.patch && \
	sed -i '/tests\/misc\/sort.pl/ d' Makefile.in && \
	FORCE_UNSAFE_CONFIGURE=1 ./configure \
		--prefix=/usr --enable-no-install-program=kill,uptime && \
	MAKE="make -j4" make && \
	make install && \
	mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin && \
	mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin && \
	mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin && \
	mv -v /usr/bin/chroot /usr/sbin && \
	mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8 && \
	sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8 && \
	mv -v /usr/bin/{head,sleep,nice,test,[} /bin && \
	cd /sources && \
	rm -rf coreutils-8.24

# iana-etc
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf iana-etc-2.30.tar.bz2 && \
	cd iana-etc-2.30 && \
	MAKE="make -j4" make && \
	make install && \
	cd /sources && \
	rm -rf iana-etc-2.30

# m4
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
	tar xf m4-1.4.17.tar.xz && \
	cd m4-1.4.17 && \
	./configure --prefix=/usr && \
	MAKE="make -j4" make && \
	make install && \
	cd /sources && \
	rm -rf m4-1.4.17

# flex
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
	tar xf flex-2.5.39.tar.xz && \
	cd flex-2.5.39 && \
	sed -i -e '/test-bison/d' tests/Makefile.in && \
	./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.5.39 && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	ln -sv flex /usr/bin/lex && \
	cd /sources && \
	rm -rf flex-2.5.39

# bison
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
	tar xf bison-3.0.4.tar.xz && \
	cd bison-3.0.4 && \
	./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4 && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	cd /sources && \
	rm -rf bison-3.0.4

# grep
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
	tar xf grep-2.21.tar.xz && \
	cd grep-2.21 && \
	sed -i -e '/tp++/a  if (ep <= tp) break;' src/kwset.c && \
	./configure --prefix=/usr --bindir=/bin && \
	MAKE="make -j4" make && \
	make install && \
	cd /sources && \
	rm -rf grep-2.21

# readline
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf readline-6.3.tar.gz && \
	cd readline-6.3 && \
	patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch && \
	sed -i '/MV.*old/d' Makefile.in && \
	sed -i '/{OLDSUFF}/c:' support/shlib-install && \
	./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/readline-6.3 && \
	MAKE="make -j4" make SHLIB=LIBS=-lncurses && \
	make SHLIB_LIBS=-lncurses install && \
	mv -v /usr/lib/lib{readline,history}.so.* /lib && \
	ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so && \
	ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so && \
	install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-6.3 && \
	cd /sources && \
	rm -rf readline-6.3

# bash
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf bash-4.3.30.tar.gz && \
	cd bash-4.3.30 && \
	patch -Np1 -i ../bash-4.3.30-upstream_fixes-2.patch && \
	./configure \
		--prefix=/usr --bindir=/bin --docdir=/usr/share/doc/bash-4.3.30 \
		--without-bash-malloc --with-installed-readline && \
	MAKE="make -j4" make && \
	chown -Rv nobody . && \
	su nobody -s /bin/bash -c "PATH=$PATH make tests" && \
	make install && \
	cd /sources && \
	rm -rf bash-4.3.30
# bc
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf bc-1.06.95.tar.bz2 && \
	cd bc-1.06.95 && \
	patch -Np1 -i ../bc-1.06.95-memory_leak-1.patch && \
	./configure \
		--prefix=/usr --with-readline --mandir=/usr/share/man --infodir=/usr/share/info && \
	MAKE="make -j4" make && \
	echo "quit" | ./bc/bc -l Test/checklib.b && \
	make install && \
	cd /sources && \
	rm -rf bc-1.06.95

# libtool
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf libtool-2.4.6.tar.xz && \
	cd libtool-2.4.6 && \
	./configure --prefix=/usr && \
	MAKE="make -j4" make && \
	make install && \
	cd /sources && \
	rm -rf libtool-2.4.6

# gdbm
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf gdbm-1.11.tar.gz && \
	cd gdbm-1.11 && \
	./configure --prefix=/usr --disable-static --enable-libgdbm-compat && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	cd /sources && \
	rm -rf gdbm-1.11

# expat
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf expat-2.1.0.tar.gz && \
	cd expat-2.1.0 && \
	./configure --prefix=/usr --disable-static && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	install -v -dm755 /usr/share/doc/expat-2.1.0 && \
	install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.1.0 && \
	cd /sources && \
	rm -rf expat-2.1.0

# inetutils
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf inetutils-1.9.4.tar.xz && \
	cd inetutils-1.9.4 && \
	./configure \
		--prefix=/usr --localstatedir=/var --disable-logger --disable-whois \
		--disable-rcp --disable-rexec --disable-rlogin --disable-rsh \
		--disable-servers && \
	MAKE="make -j4" make && \
	make install && \
	mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin && \
	mv -v /usr/bin/ifconfig /sbin && \
	cd /sources && \
	rm -rf inetutils-1.9.4

# perl
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf perl-5.22.0.tar.bz2 && \
	cd perl-5.22.0 && \
	BUILD_ZLIB=False BUILD_BZIP2=0 sh Configure \
		-des -Dprefix=/usr -Dvendorprefix=/usr -Dman1dir=/usr/share/man/man1 \
		-Dman3dir=/usr/share/man/man3 -Dpager="/usr/bin/less -isR" -Duseshrplib && \
	BUILD_ZLIB=False BUILD_BZIP2=0 MAKE="make -j4" make && \
	BUILD_ZLIB=False BUILD_BZIP2=0 make -k test && \
	BUILD_ZLIB=False BUILD_BZIP2=0 make install && \
	cd /sources && \
	rm -rf perl-5.22.0

# XML-Parser
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf XML-Parser-2.44.tar.gz && \
	cd XML-Parser-2.44 && \
	perl Makefile.PL && \
	MAKE="make -j4" make && \
	make test && \
	make install && \
	cd /sources && \
	rm -rf XML-Parser-2.44

# autoconf
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf autoconf-2.69.tar.xz && \
	cd autoconf-2.69 && \
	./configure --prefix=/usr && \
	MAKE="make -j4" make && \
	make install && \
	cd /sources && \
	rm -rf autoconf-2.69

# automake
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf automake-1.15.tar.xz && \
	cd automake-1.15 && \
	sed -i 's:/\\\${:/\\\$\\{:' bin/automake.in && \
	./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.15 && \
	MAKE="make -j4" make && \
	make install && \
	cd /sources && \
	rm -rf automake-1.15

# diffutils
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf diffutils-3.3.tar.xz && \
	cd diffutils-3.3 && \
	sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in && \
	./configure --prefix=/usr && \
	MAKE="make -j4" make && \
	make install && \
	cd /sources && \
	rm -rf diffutils-3.3

# gawk
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf gawk-4.1.3.tar.xz && \
	cd gawk-4.1.3 && \
	./configure --prefix=/usr && \
	MAKE="make -j4" make && \
	make install && \
	mkdir -v /usr/share/doc/gawk-4.1.3 && \
	cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.1.3 && \
	cd /sources && \
	rm -rf gawk-4.1.3

# findutils
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf findutils-4.4.2.tar.gz && \
	cd findutils-4.4.2 && \
	./configure --prefix=/usr --localstatedir=/var/lib/locate && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	mv -v /usr/bin/find /bin && \
	sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb && \
	cd /sources && \
	rm -rf findutils-4.4.2

# gettext
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf gettext-0.19.5.1.tar.xz && \
	cd gettext-0.19.5.1 && \
	./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/gettext-0.19.5.1 && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	cd /sources && \
	rm -rf gettext-0.19.5.1

# intltool
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf intltool-0.51.0.tar.gz && \
	cd intltool-0.51.0 && \
	sed -i 's:\\\${:\\\$\\{:' intltool-update.in && \
	./configure --prefix=/usr && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO && \
	cd /sources && \
	rm -rf intltool-0.51.0

# gperf
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf gperf-3.0.4.tar.gz && \
	cd gperf-3.0.4 && \
	./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.0.4 && \
	MAKE="make -j4" make && \
	make -j1 check && \
	make install && \
	cd /sources && \
	rm -rf gperf-3.0.4

# groff
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf groff-1.22.3.tar.gz && \
	cd groff-1.22.3 && \
	PAGE=letter ./configure --prefix=/usr && \
	MAKE="make -j1" make && \
	make install && \
	cd /sources && \
	rm -rf groff-1.22.3

# xz
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf xz-5.2.1.tar.xz && \
	cd xz-5.2.1 && \
	./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/xz-5.2.1 && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin && \
	mv -v /usr/lib/liblzma.so.* /lib && \
	ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so && \
	cd /sources && \
	rm -rf xz-5.2.1

# less
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf less-458.tar.gz && \
	cd less-458 && \
	./configure --prefix=/usr --sysconfdir=/etc && \
	MAKE="make -j4" make && \
	make install && \
	cd /sources && \
	rm -rf less-458

# gzip
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf gzip-1.6.tar.xz && \
	cd gzip-1.6 && \
	./configure --prefix=/usr --bindir=/bin && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	mv -v /bin/{gzexe,uncompress,zcmp,zdiff,zegrep} /usr/bin && \
	mv -v /bin/{zfgrep,zforce,zgrep,zless,zmore,znew} /usr/bin && \
	cd /sources && \
	rm -rf gzip-1.6

# libpipeline
RUN \
        umask 022 && \
        export LC_ALL=POSIX && \
        cd /sources && \
        tar xf libpipeline-1.4.1.tar.gz && \
	cd libpipeline-1.4.1 && \
	PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr && \
	MAKE="make -j4" make && \
	make check && \
	make install && \
	cd /sources && \
	rm -rf libpipeline-1.4.1

CMD ["/bin/bash"]

