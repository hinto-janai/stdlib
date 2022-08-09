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

#git <stdlib/guard.sh/308af73>

# guard()
# -------
# read $0 excluding the line where guard()
# was called and send it through sha1sum.
# return if $1 does not match the hash calculated.
#
# this is akin to doing "cat FILE | sha1sum"
# except guard() allows you to store the hash
# of the file you're calculating in the very
# file that it's in.
#
# to initially calculate a hash:
# sed '/^[[:blank:]]guard.*$/d' FILE
# then you can insert that hash like:
# guard c22b5f9178342609428d6f51b2c5af4c0bde6a42
#
# any modification above or below that guard()
# will trigger guard to return error.

guard() {
	local STD_GUARD_HASH STD_TMP_GUARD_HASH || return 11
	STD_GUARD_HASH=$(\
		mapfile -n $((BASH_LINENO-1)) STD_TMP_GUARD_HASH < "$0";
		mapfile -O $((BASH_LINENO-1)) -s $BASH_LINENO STD_TMP_GUARD_HASH < "$0";
		printf "%s" "${STD_TMP_GUARD_HASH[@]}" | sha1sum) || return 22
	if [[ ${STD_GUARD_HASH// */} != "$1" ]]; then
		STD_TRACE_RETURN="bad guard() hash, real: ${STD_GUARD_HASH// */}"
		return 33
	fi
}
