#git <stdlib/hash.sh/e3af68e>
hash::md5(){
	set -o pipefail || return 44
	if [[ -p /dev/stdin ]]; then
		local i || return 44
		for i in $(</dev/stdin); do
			printf "%s" "$i" | md5sum | tr -d ' -' || return 2
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 44
		return 1
	fi

	while [[ $# != 0 ]]; do
		printf "%s" "$1" | md5sum | tr -d ' -' || return 2
		shift
	done
	set +o pipefail && return 0 || return 44
}

hash::sha1(){
	set -o pipefail || return 44
	if [[ -p /dev/stdin ]]; then
		local i || return 44
		for i in $(</dev/stdin); do
			printf "%s" "$i" | sha1sum | tr -d ' -' || return 2
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 44
		return 1
	fi

	while [[ $# != 0 ]]; do
		printf "%s" "$1" | sha1sum | tr -d ' -' || return 2
		shift
	done
	set +o pipefail && return 0 || return 44
}

hash::sha256(){
	set -o pipefail || return 44
	if [[ -p /dev/stdin ]]; then
		local i || return 44
		for i in $(</dev/stdin); do
			printf "%s" "$i" | sha256sum | tr -d ' -' || return 2
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 44
		return 1
	fi

	while [[ $# != 0 ]]; do
		printf "%s" "$1" | sha256sum | tr -d ' -' || return 2
		shift
	done
	set +o pipefail && return 0 || return 44
}

hash::sha512(){
	set -o pipefail || return 44
	if [[ -p /dev/stdin ]]; then
		local i || return 44
		for i in $(</dev/stdin); do
			printf "%s" "$i" | sha512sum | tr -d ' -' || return 2
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 44
		return 1
	fi

	while [[ $# != 0 ]]; do
		printf "%s" "$1" | sha512sum | tr -d ' -' || return 2
		shift
	done
	set +o pipefail && return 0 || return 44
}
