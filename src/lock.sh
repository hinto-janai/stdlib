#git <stdlib/lock.sh/7be5004>
lock::alloc() {
	exec 200<"$0" || return 2
	flock -n 200 || return 66
	return 0
}

lock::free() {
	exec 200<&-
}
