#git <stdlib/crypto.sh/cc3d85c>
crypto::bytes() {
	[[ $# = 0 ]] && return 1
	head -c $1 /dev/random
}

crypto::num() {
	[[ $# = 0 ]] && return 1
	shuf -i 0-$1 -n 1
}
