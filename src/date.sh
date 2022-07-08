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

#git <stdlib/date.sh/33f74e2>

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
			date -d @"$i" || return 22
		done
		return 0
	fi
	# normal input
	[[ $# = 0 ]] && return 33
	while [[ $# != 0 ]]; do
		date -d @"$1" || return 44
		shift
	done
	return 0
}
date::unix() { printf "%s\n" "$EPOCHSECONDS" ;}
date::time() { date +"%T" ;}
date::calendar() { date +"%Y-%m-%d" ;}
date::now() { date +"%Y-%m-%d %T" ;}
date::year() { date +"%Y" ;}
date::month() { date +"%m" ;}
date::day() { date +"%d" ;}
date::hour() { date +"%H" ;}
date::minute() { date +"%M" ;}
date::second() { date +"%S" ;}
