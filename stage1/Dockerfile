FROM ccondit/linuxfromscratch-stage0
MAINTAINER ccondit@randomcoder.com

ENV	LFS_VERSION=20150825-systemd

# initial setup ; create dirs
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
	ln -sfv /tools/cat /bin && \
	ln -sfv /tools/echo /bin && \
	ln -sfv /tools/pwd /bin && \
	ln -sfv /tools/stty /bin && \
	ln -sfv /tools/bin/perl /usr/bin && \
	ln -sfv /tools/lib/libgcc_s.so /usr/lib && \
	ln -sfv /tools/lib/libgcc_s.so.1 /usr/lib && \
	ln -sfv /tools/lib/libstdc++.so /usr/lib && \
	ln -sfv /tools/lib/libstdc++.so.6 /usr/lib && \
	sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la && \
	ln -sfv bash /bin/sh

CMD ["/bin/bash"]
