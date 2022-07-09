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

#git <stdlib/is.sh/a091726>

# is()
# ----
# check if stdin/input is an
# integer, positive, or negative.
#
# uses [ shell equality ] because
# [[ bash ]] -eq is weird.

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
