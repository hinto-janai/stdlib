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

#git <stdlib/const.sh/3bafba8>

# const()
# -------
# these CONVERT the type() variables into constants,
# keeping the appropriate type (char technically is
# the same as bool, though). the variable MUST be
# initialized already or const() will error.
# ideally, const() would be able to assign value
# as well, but the code got very confusing and
# slow when it came to parsing arrays that defined
# multiple values into multiple different arrays.
#
# for now:
# --------
# array a[0]=hello   <-- this is the way to do it.
# const::array a         initialize, then convert to
#                        appropriate constant type.

const::char() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p "$i" &>/dev/null || { STD_TRACE_RETURN="char not found: $i"; return 33; }
		declare -r -g "$i" || return 44
	done
	return 0
}

const::array() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p "$i" &>/dev/null || { STD_TRACE_RETURN="array not found: $i"; return 33; }
		declare -r -g -a "$i" || return 44
	done
	return 0
}

const::map() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p "$i" &>/dev/null || { STD_TRACE_RETURN="map not found: $i"; return 33; }
		declare -r -g -A "$i" || return 44
	done
	return 0
}

const::int() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		# make sure it's an integer
		case "$i" in
			''|*[!0-9]*) { STD_TRACE_RETURN="not integer: $i"; return 33; } ;;
		esac
		declare -p "$i" &>/dev/null || { STD_TRACE_RETURN="integer not found: $i"; return 44; }
		declare -r -g -i "$i" || return 55
	done
	return 0
}

const::bool() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p "$i" &>/dev/null || { STD_TRACE_RETURN="bool not found: $i"; return 33; }
		declare -r -g "$i" || return 44
	done
}

const::ref() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p "$i" &>/dev/null || { STD_TRACE_RETURN="ref not found: $i"; return 33; }
		declare -r -g -n "$i" || return 44
	done
	return 0
}
