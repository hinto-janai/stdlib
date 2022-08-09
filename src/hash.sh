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

#git <stdlib/hash.sh/308af73>

# hash()
# ------
# hash stdin or regular input,
# takes multiple inputs.
# md5 - sha1 - sha256 - sha512

hash::md5() {
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 11
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | md5sum) || return 22
			printf "%s\n" "${STD_HASH// *}" || return 33
		done
		return
	elif [[ $# = 0 ]]; then
		return 44
	fi
	# normal input
	until [[ $# = 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | md5sum) || return 55
		printf "%s\n" "${STD_HASH// *}"
		shift
	done
}

hash::sha1() {
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 11
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | sha1sum) || return 22
			printf "%s\n" "${STD_HASH// *}" || return 33
		done
		return
	elif [[ $# = 0 ]]; then
		return 44
	fi
	# normal input
	until [[ $# = 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | sha1sum) || return 55
		printf "%s\n" "${STD_HASH// *}"
		shift
	done
}

hash::sha256() {
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 11
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | sha256sum) || return 22
			printf "%s\n" "${STD_HASH// *}" || return 33
		done
		return
	elif [[ $# = 0 ]]; then
		return 44
	fi
	# normal input
	until [[ $# = 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | sha256sum) || return 55
		printf "%s\n" "${STD_HASH// *}"
		shift
	done
}

hash::sha512() {
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 11
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | sha512sum) || return 22
			printf "%s\n" "${STD_HASH// *}" || return 33
		done
		return
	elif [[ $# = 0 ]]; then
		return 44
	fi
	# normal input
	until [[ $# = 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | sha512sum) || return 55
		printf "%s\n" "${STD_HASH// *}"
		shift
	done
}

