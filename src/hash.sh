#git <stdlib/hash.sh/7be5004>
hash::md5() {
	set -o pipefail || return 11
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i || return 22
		for i in $(</dev/stdin); do
			printf "%s" "$i" | md5sum | tr -d ' -' || return 33
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 55
		return 1
	fi
	# normal input
	while [[ $# != 0 ]]; do
		printf "%s" "$1" | md5sum | tr -d ' -' || return 66
		shift
	done
	set +o pipefail && return 0 || return 77
}

hash::sha1() {
	set -o pipefail || return 11
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i || return 22
		for i in $(</dev/stdin); do
			printf "%s" "$i" | sha256sum | tr -d ' -' || return 33
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 55
		return 1
	fi
	# normal input
	while [[ $# != 0 ]]; do
		printf "%s" "$1" | sha256sum | tr -d ' -' || return 66
		shift
	done
	set +o pipefail && return 0 || return 77
}

hash::sha256() {
	set -o pipefail || return 11
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i || return 22
		for i in $(</dev/stdin); do
			printf "%s" "$i" | sha256sum | tr -d ' -' || return 33
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 55
		return 1
	fi
	# normal input
	while [[ $# != 0 ]]; do
		printf "%s" "$1" | sha256sum | tr -d ' -' || return 66
		shift
	done
	set +o pipefail && return 0 || return 77
}

hash::sha512() {
	set -o pipefail || return 11
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i || return 22
		for i in $(</dev/stdin); do
			printf "%s" "$i" | sha512sum | tr -d ' -' || return 33
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 55
		return 1
	fi
	# normal input
	while [[ $# != 0 ]]; do
		printf "%s" "$1" | sha512sum | tr -d ' -' || return 66
		shift
	done
	set +o pipefail && return 0 || return 77
}

