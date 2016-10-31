#!/bin/bash
#
# tuned-percona-mongodb (https://github.com/Percona-Lab/tuned-percona-mongodb)
#
# Disable/Enable Transparent Huge Pages 'defrag'.
# The [vm] transparent_hugepages=never flag doesn't
# do this and mongod will complain about it.

set_thp_defrag() {
	grep -q '\['$1'\]' /sys/kernel/mm/transparent_hugepage/defrag
	if [ "$?" -gt 0 ]; then
		echo $1 >/sys/kernel/mm/transparent_hugepage/defrag
		grep -q '\['$1'\]' /sys/kernel/mm/transparent_hugepage/defrag
		[ "$?" -gt 0 ] && exit 1
	fi
}

if [ -e /sys/kernel/mm/transparent_hugepage/defrag ]; then
	case $1 in
		start)
			set_thp_defrag "never"
			;;
		stop)
			set_thp_defrag "always"
			;;
		*)
			exit 1
	esac
fi
