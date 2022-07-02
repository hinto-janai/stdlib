#git <stdlib/is.sh/e37073d>
is::int() {
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i || return 11
		for i in $(</dev/stdin); do
			[ $i -eq $i ] &>/dev/null || return 22
		done
		return 0
	fi
	# regular input
	[[ $# = 0 ]] && return 33
	local i || return 44
	for i in $@; do
		[ $i -eq $i ] &>/dev/null || return 55
	done
}

is::int_pos() {
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i || return 11
		for i in $(</dev/stdin); do
			[ $i -gt -1 ] &>/dev/null || return 22
			[ $i -eq $i ] &>/dev/null || return 33
		done
		return 0
	fi
	# regular input
	[[ $# = 0 ]] && return 44
	local i || return 55
	for i in $@; do
		[ $i -gt -1 ] &>/dev/null || return 66
		[ $i -eq $i ] &>/dev/null || return 77
	done
}

is::int_neg() {
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i || return 11
		for i in $(</dev/stdin); do
			[ $i -lt 0 ] &>/dev/null || return 22
			[ $i -eq $i ] &>/dev/null || return 33
		done
		return 0
	fi
	# regular input
	[[ $# = 0 ]] && return 44
	local i || return 55
	for i in $@; do
		[ $i -lt 0 ] &>/dev/null || return 66
		[ $i -eq $i ] &>/dev/null || return 77
	done
}
