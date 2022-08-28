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

#git <stdlib/log.sh/4c8490f>

# log()
# -----
# print formatted
# messages to the terminal.
# the line is first cleared then
# the message is printed. this is to
# avoid previous messages (from log::prog)
# from leaving traces. can take
# multiple inputs, each input will
# be formatted and print a newline.

log::ok() { printf "\r\e[2K\e[1;32m[  OK  ]\e[0m %s\n" "$@"; }
log::info() { printf "\r\e[2K\e[1;37m[ INFO ]\e[0m %s\n" "$@"; }
log::warn() { printf "\r\e[2K\e[1;33m[ WARN ]\e[0m %s\n" "$@"; }
log::fail() { printf "\r\e[2K\e[1;31m[ FAIL ]\e[0m %s\n" "$@"; }
log::danger() { printf "\r\e[2K\e[1;31m[DANGER]\e[0m %s\n" "$@"; }

# format with 8 spaces instead of []
log::tab() { printf "\r\e[2K\e[0m         %s\n" "$@"; }

# do not print a newline, leave cursor at the end.
# printing a different log:: will overwrite this one.
log::prog() { printf "\r\e[2K\e[1;37m[ \e[0m....\e[1;37m ]\e[0m %s " "$@"; }

# log::debug()
# ------------
# this uses the $EPOCHREALTIME variable to
# calculate the seconds that have passed.
# the first call of log::debug() initiates
# the $STD_LOG_DEBUG_INIT and starts
# counting from there.
#
# ENVIRONMENT VARIABLE
# ---------------------
# $STD_LOG_DEBUG - [true] will enable debug messages to print
##
# EXAMPLE OUTPUT
# --------------
# [2025-12-25 08:08:08 0.000000] init debug message        <-- formatting: [yyyy-mm-dd hh-ss seconds_passed] [func()] [message]
# [2025-12-25 08:08:08 1.000000] this is 1 second after
# [2025-12-25 08:08:08 1.000546] 5.46 milliseconds after
#
# 100% bash builtins, no external programs.

log::debug() {
	# to enable debug to show up, make sure
	# STD_LOG_DEBUG gets set "true" somewhere
	[[ $STD_LOG_DEBUG = true ]] || return 0

	# swap the color for every NEW function called
	if [[ $STD_LOG_DEBUG_LAST_FUNC != "${FUNCNAME[1]}" ]]; then
		declare -g STD_LOG_DEBUG_LAST_FUNC="${FUNCNAME[1]}"
		case "$STD_LOG_DEBUG_FUNC_COLOR" in
			"\e[1;91m") STD_LOG_DEBUG_FUNC_COLOR="\e[1;92m";;
			"\e[1;92m") STD_LOG_DEBUG_FUNC_COLOR="\e[1;93m";;
			"\e[1;93m") STD_LOG_DEBUG_FUNC_COLOR="\e[1;94m";;
			"\e[1;94m") STD_LOG_DEBUG_FUNC_COLOR="\e[1;95m";;
			"\e[1;95m") STD_LOG_DEBUG_FUNC_COLOR="\e[1;96m";;
			"\e[1;96m") STD_LOG_DEBUG_FUNC_COLOR="\e[1;97m";;
			*) STD_LOG_DEBUG_FUNC_COLOR="\e[1;91m";;
		esac
	fi

	# get date [YEAR-MONTH-DAY HOUR:MINUTE:SECOND]
	local STD_LOG_DEBUG_DATE=$(printf "%(%F %T)T" "-1")

	# if first time running, initiate debug time and return
	if [[ -z $STD_LOG_DEBUG_INIT ]]; then
		declare -gr STD_LOG_DEBUG_INIT=${EPOCHREALTIME//[!0-9]/}
		printf "\r\e[2K\e[1;90m[${STD_LOG_DEBUG_DATE} 0.000000] ${STD_LOG_DEBUG_FUNC_COLOR}${FUNCNAME[1]}()\e[0m %s\n" "$@"
		return
	fi
	# current unix time - init unix time = current time in seconds
	# 1656979999.949650 - 1656979988.549640 = 11.400010
	# remove the '.' so the math works.
	# Ubuntu adds a ',' so remove anything that isn't a number.
	local STD_LOG_DEBUG_ADJUSTED=$((${EPOCHREALTIME//[!0-9]/}-STD_LOG_DEBUG_INIT))
	# during init cases, the difference
	# can be as low as 0.000002 which
	# renders as just 2. this is a problem
	# because we need the digit to be
	# greater than 6 digits long. this
	# case statement adds leading 0's
	# so that 2 becomes 000002
	case ${#STD_LOG_DEBUG_ADJUSTED} in
		1) STD_LOG_DEBUG_ADJUSTED=00000${STD_LOG_DEBUG_ADJUSTED};;
		2) STD_LOG_DEBUG_ADJUSTED=0000${STD_LOG_DEBUG_ADJUSTED};;
		3) STD_LOG_DEBUG_ADJUSTED=000${STD_LOG_DEBUG_ADJUSTED};;
		4) STD_LOG_DEBUG_ADJUSTED=00${STD_LOG_DEBUG_ADJUSTED};;
		5) STD_LOG_DEBUG_ADJUSTED=0${STD_LOG_DEBUG_ADJUSTED};;
	esac
	# this is to add back the '.', currently the number
	# is something like 000002 or 1000543
	local STD_LOG_DEBUG_DOT=$((${#STD_LOG_DEBUG_ADJUSTED}-6))
	# if 6 digits long, that means one second
	# hasn't even passed, so just print 0.$the_number
	if [[ $STD_LOG_DEBUG_DOT = 0 ]]; then
		printf "\r\e[2K\e[1;90m[${STD_LOG_DEBUG_DATE} 0.${STD_LOG_DEBUG_ADJUSTED}] ${STD_LOG_DEBUG_FUNC_COLOR}${FUNCNAME[1]}()\e[0m %s\n" "$@"
	else
	# else print the integer, '.', then decimals
		printf "\r\e[2K\e[1;90m[${STD_LOG_DEBUG_DATE} ${STD_LOG_DEBUG_ADJUSTED:0:${STD_LOG_DEBUG_DOT}}.${STD_LOG_DEBUG_ADJUSTED:${STD_LOG_DEBUG_DOT}}] ${STD_LOG_DEBUG_FUNC_COLOR}${FUNCNAME[1]}()\e[0m %s\n" "$@"
	fi
}
