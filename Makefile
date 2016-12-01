all: install

/etc/tuned/percona-mongodb: percona-mongodb/tuned.conf percona-mongodb/*.sh
	if [ -d /etc/tuned ]; then \
		cp -dpR percona-mongodb /etc/tuned/percona-mongodb; \
		chown -R root.root /etc/tuned/percona-mongodb; \
		echo "### 'tuned-percona-mongodb' is installed. Enable with 'make enable'."; \
	else \
		echo "### ERROR: cannot find tuned config dir at /etc/tuned!"; \
		exit 1; \
	fi

install: /etc/tuned/percona-mongodb

enable: /etc/tuned/percona-mongodb
	tuned-adm profile percona-mongodb
	tuned-adm active

disable:
	if [ -d /etc/tuned/percona-mongodb ]; then \
		echo "### Disabling tuned profile 'tuned-percona-mongodb'"; \
		echo "### Changing tuned profile to 'latency-performance', adjust if necessary after!"; \
		tuned-adm profile latency-performance; \
		tuned-adm active; \
	else \
		echo "tuned-percona-mongodb profile not installed!"; \
	fi

uninstall: disable
	if [ -d /etc/tuned/percona-mongodb ]; then rm -rf /etc/tuned/percona-mongodb; fi
