#git <stdlib/lock.sh/6cf3ad6>
lock::alloc() {
	trap 'lock::free' INT QUIT TERM || return 11
	flock -n $0 || return 22
	return 0
}

lock::free() {
	exec 200<&- || return 11
}
