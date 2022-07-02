#git <stdlib/alloc.sh/e37073d>
# malloc:
# 1. read input (stdin, arguments)
# 2. make sure $input is an UNSET variable
# 3. initiate input as a global variable(s)
malloc() {
	# stdin
	local i || return 11
	if [[ -p /dev/stdin ]]; then
		for i in $(</dev/stdin); do
			declare -p $i &>/dev/null && return 22
			declare -g $i || return 33
		done
		return 0
	fi
	# args
	[[ $# = 0 ]] && return
	for i in $@; do
		declare -p $i &>/dev/null && return 44
		declare -g $i || return 55
	done
	return 0
}

# free:
# 1. read input (stdin, arguments)
# 2. make sure $input is a SET variable
# 3. unset input as variables
free() {
	# stdin
	local i || return 11
	if [[ -p /dev/stdin ]]; then
		for i in $(</dev/stdin); do
			declare -p $i &>/dev/null || return 22
			unset -v $i || return 33
		done
		return 0
	fi
	# args
	[[ $# = 0 ]] && return
	for i in $@; do
		declare -p $i &>/dev/null || return 44
		unset -v $i || return 55
	done
	return 0
}
