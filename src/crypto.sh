# This file is part of stdlib.sh - a standard library for Bash
# Copyright (c) 2022 hinto.janaiyo <https://github.com/hinto-janaiyo>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#git <stdlib/crypto.sh/8038e38>

# crypto()
# --------
# generate crypto.

# get $1 bytes of /dev/random
crypto::bytes() {
	[[ $# = 0 ]] && return 1
	head -c $1 /dev/random
}

# get random number from 0-$1 or $1-$2
crypto::num() {
	case $# in
		1) shuf -i 0-$1 -n 1; return;;
		2) shuf -i $1-$2 -n 1; return;;
		*) return 1;;
	esac
}

# get UUID from kernel (newline removed)
crypto::uuid() {
	local STD_CRYPTO_UUID || return 1
	mapfile STD_CRYPTO_UUID < /proc/sys/kernel/random/uuid
	printf "%s" ${STD_CRYPTO_UUID//$'\n'}
}

# use gpg to encrypt input with a passphrase
# and return a pgp message
# USAGE: crypto::encrypt "input_to_encrypt" "passphrase"
crypto::encrypt() {
	[[ $# != 2 ]] && return 1
	printf "%s\n" "$1" | gpg --batch --symmetric --armor --quiet --cipher-algo AES256 --passphrase "$2"
}

# decrypts the above function
# USAGE: crypto::decrypt "input_to_decrypt" "passphrase"
crypto::decrypt() {
	printf "%s\n" "$1" | gpg --batch --decrypt --quiet --passphrase "$2"
}

