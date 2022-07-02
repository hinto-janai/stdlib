#git <stdlib/alloc.sh/6cf3ad6>
# malloc && free
# ------------------------------------
# INITIALIZE global variables only if
# they are completely unset. ASSIGNING
# a value to variables with malloc is
# forbidden, only initialization.
# Null-but-initialized variables count
# as already set variables, and will
# cause malloc to return error:
# e.g. local VAR; malloc VAR

malloc() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		[[ $i = *=* ]] && return 22
		declare -p $i &>/dev/null && return 33
		declare -g $i || return 44
	done
	return 0
}

free() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		[[ $i = *=* ]] && return 22
		declare -p $i &>/dev/null || return 33
		unset -v $i || return 44
	done
	return 0
}
