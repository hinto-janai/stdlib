#git <stdlib/hash.sh/83ca8ba>
# hash
# ----
# hash stdin or regular input
# md5 - sha1 - sha256 - sha512
#
# implementing a 100% bash builtin
# version of the *sums might actually
# be faster than calling the binary
# for large loops of hashing, but
# that sounds like a pain to write.

hash::md5() {
	set -o pipefail || return 11
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 22
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | md5sum) || return 33
			printf "%s\n" "${STD_HASH// *-*/}" || return 44
		done
		set +o pipefail && return 0 || return 55
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 66
		return 1
	fi
	# normal input
	while [[ $# != 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | md5sum) || return 77
		printf "%s\n" "${STD_HASH// *-*/}"
		shift
	done
	set +o pipefail && return 0 || return 88
}

hash::sha1() {
	set -o pipefail || return 11
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 22
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | sha1sum) || return 33
			printf "%s\n" "${STD_HASH// *-*/}" || return 44
		done
		set +o pipefail && return 0 || return 55
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 66
		return 1
	fi
	# normal input
	while [[ $# != 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | sha1sum) || return 77
		printf "%s\n" "${STD_HASH// *-*/}"
		shift
	done
	set +o pipefail && return 0 || return 88
}

hash::sha256() {
	set -o pipefail || return 11
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 22
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | sha256sum) || return 33
			printf "%s\n" "${STD_HASH// *-*/}" || return 44
		done
		set +o pipefail && return 0 || return 55
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 66
		return 1
	fi
	# normal input
	while [[ $# != 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | sha256sum) || return 77
		printf "%s\n" "${STD_HASH// *-*/}"
		shift
	done
	set +o pipefail && return 0 || return 88
}

hash::sha512() {
	set -o pipefail || return 11
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 22
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | sha512sum) || return 33
			printf "%s\n" "${STD_HASH// *-*/}" || return 44
		done
		set +o pipefail && return 0 || return 55
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 66
		return 1
	fi
	# normal input
	while [[ $# != 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | sha512sum) || return 77
		printf "%s\n" "${STD_HASH// *-*/}"
		shift
	done
	set +o pipefail && return 0 || return 88
}
