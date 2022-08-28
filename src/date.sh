# This file is part of stdlib.sh - a standard library for Bash
#
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

#git <stdlib/date.sh/4c8490f>

# date()
# ------
# format the date in useful ways.
# date::unix() will give unix time,
# and date::unix_translate() will
# print the input unix time as a
# human readable date.

date::unix_translate() {
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i || return 11
		for i in $(</dev/stdin); do
			printf "%(%F %T)T\n" "$i" || return 22
		done
		return 0
	fi
	# normal input
	[[ $# = 0 ]] && return 33
	while [[ $# != 0 ]]; do
		printf "%(%F %T)T\n" "$1" || return 44
		shift
	done
	return 0
}

date::log()    { printf "%(%F %T)T %s\n" "$EPOCHSECONDS" "$EPOCHREALTIME" ;} # 2022-08-26 17:06:06 1661547966.103297
date::unix()   { echo "$EPOCHSECONDS" ;} # 1661547672
date::stamp()  { printf "%(%F %T)T\n" ;} # 2022-12-25 15:13:01
date::ymd()    { printf "%(%F)T\n" ;}    # 2022-12-25
date::time()   { printf '%(%T)T\n' ;}    # 15:13:01
date::year()   { printf "%(%Y)T\n" ;}    # 2022
date::month()  { printf "%(%m)T\n" ;}    # 12
date::day()    { printf "%(%d)T\n" ;}    # 25
date::hour()   { printf "%(H)T" ;}       # 15
date::minute() { printf "%(M)T" ;}       # 13
date::second() { printf "%(S)T" ;}       # 01
