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
	ln -sfv /usr/share/zoneinfo/UTC /etc/localtime

CMD ["/bin/bash"]
