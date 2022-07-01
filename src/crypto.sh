#git <stdlib/crypto.sh/76f0927>
crypto::bytes() {
	[[ $# = 0 || $# -gt 1 ]] && return 1
	head -c $1 /dev/random
}

crypto::num() {
	[[ $# = 0 || $# -gt 1 ]] && return 1
	shuf -i 0-$1 -n 1
}
