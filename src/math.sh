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

#git <stdlib/math.sh/8038e38>

# math()
# ------
# do floating number calculations with AWK.
# _____::sum() sums a COLUMN of floats
# because of how AWK procceses it. THIS
# REQUIRES YOUR INPUT TO BE IN A COLUMN.
#
# The rest of the functions expect 2
# arguments, no column.
#
# short  = 3  after dot
# float  = 7  after dot
# double = 15 after dot
#
# Since this is AWK and not a builtin,
# these functions are terribly slow in
# loops (because you have to load AWK
# from disk into memory every interation).
# It's advised to use a custom AWK
# implementation for big loops.

# REQUIRES the input to be a COLUMN.
# Uses either arg $1 or standard input.
# $1 usage:    float::sum "$VAR_OF_NUMBERS_IN_A_COLUMN"
# stdin usage: cat file | float::sum
short::sum() {
	if [[ -p /dev/stdin ]]; then
		awk -M -v PREC=200 '{SUM+=$1}END{printf "%.3f\n", SUM }'
	else
		builtin echo "$1" | awk -M -v PREC=200 '{SUM+=$1}END{printf "%.3f\n", SUM }'
	fi
}
float::sum() {
	if [[ -p /dev/stdin ]]; then
		awk -M -v PREC=200 '{SUM+=$1}END{printf "%.7f\n", SUM }'
	else
		builtin echo "$1" | awk -M -v PREC=200 '{SUM+=$1}END{printf "%.7f\n", SUM }'
	fi
}
double::sum() {
	if [[ -p /dev/stdin ]]; then
		awk -M -v PREC=200 '{SUM+=$1}END{printf "%.15f\n", SUM }'
	else
		builtin echo "$1" | awk -M -v PREC=200 '{SUM+=$1}END{printf "%.15f\n", SUM }'
	fi
}

# The rest of these functions require 2 ARGUMENTS
# usage: _____::add/div/sub "$1" "$2"

# ADD
short::add() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.3f\n", $1 + $2 }'; }
float::add() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.7f\n", $1 + $2 }'; }
double::add() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.15f\n", $1 + $2 }'; }

# SUBTRACT
short::sub() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.3f\n", $1 - $2 }'; }
float::sub() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.7f\n", $1 - $2 }'; }
double::sub() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.15f\n", $1 - $2 }'; }

# MULTIPLY
short::mul() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.3f\n", $1 * $2 }'; }
float::mul() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.7f\n", $1 * $2 }'; }
double::mul() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.15f\n", $1 * $2 }'; }

# DIVIDE
short::div() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.3f\n", $1 / $2 }'; }
float::div() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.7f\n", $1 / $2 }'; }
double::div() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.15f\n", $1 / $2 }'; }
