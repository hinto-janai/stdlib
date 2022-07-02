#git <stdlib/alloc.sh/6cf3ad6>
# malloc() && free()
# ------------------------------------
# INITIALIZE global variables only if
# they are completely unset. ASSIGNING
# a value to variables with malloc() is
# possible, using: malloc VAR=value.
# Null-but-initialized variables count
# as already set variables, and will
# cause malloc() to return error:
# e.g. local VAR; malloc VAR
# free() will unset any variable,
# whether set by malloc() or not.

malloc() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 22
		declare -g $i || return 33
	done
	return 0
}

free() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null || return 22
		unset -v $i || return 33
	done
	return 0
}
