#git <stdlib/lock.sh/83ca8ba>
lock::alloc() {
	# remove lock on exit
	trap 'lock::free' EXIT || return 11
	# make lock file var global
	declare -g STD_LOCK_FILE || return 22
	# $1 = the locks name
	if [[ $1 ]]; then
		STD_LOCK_FILE="$1" || return 33
	else
		STD_LOCK_FILE="$0" || return 44
	fi
	# attach UUID to lock name
	local STD_LOCK_UUID || return 55
	mapfile -n 1 STD_LOCK_UUID < /proc/sys/kernel/random/uuid || return 66
	STD_LOCK_UUID=${STD_LOCK_UUID[0]//$'\n'/}
	STD_LOCK_UUID=${STD_LOCK_UUID//-/}
	STD_LOCK_FILE="${STD_LOCK_FILE}_${STD_LOCK_UUID}"
	# create file in /tmp with 600 perms
	local STD_DEFAULT_UMASK
	STD_DEFAULT_UMASK=$(umask)
	umask 177
	echo "" > /tmp/"$STD_LOCK_FILE" || return 77
	umask $STD_DEFAULT_UMASK
	return 0
}

lock::free() { command rm /tmp/"$STD_LOCK_FILE"; }
