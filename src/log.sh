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

#git <stdlib/log.sh/33f74e2>

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

log::ok() {
	printf "\r\e[2K"
	printf "\r\033[1;32m[  OK  ]\033[0m %s\n" "$@"
}
log::info() {
	printf "\r\e[2K"
	printf "\r\033[1;37m[ INFO ]\033[0m %s\n" "$@"
}
log::warn() {
	printf "\r\e[2K"
	printf "\r\033[1;33m[ WARN ]\033[0m %s\n" "$@"
}
log::fail() {
	printf "\r\e[2K"
	printf "\r\033[1;31m[ FAIL ]\033[0m %s\n" "$@"
}
log::danger() {
	printf "\r\e[2K"
	printf "\r\033[1;31m[DANGER]\033[0m %s\n" "$@"
}

# format with 8 spaces instead of []
log::tab() {
	printf "\r\e[2K"
	printf "\r\033[0m         %s\n" "$@"
}

# do not print a newline, leave cursor at the end.
# printing a different log:: will overwrite this one.
log::prog() {
	printf "\r\e[2K"
	printf "\r\033[1;37m[ \033[0m....\033[1;37m ]\033[0m %s " "$@"
}

# log::debug()
# ------------
# this uses the $EPOCHREALTIME variable to
# calculate the seconds that have passed.
# the first call of log::debug() initiates
# the $STD_LOG_DEBUG_INIT and starts
# counting from there.
#
# ENVIRONMENT VARIABLES
# ---------------------
# $STD_LOG_DEBUG - "true" will enable debug messages to print
# $STD_LOG_DEBUG_VERBOSE - "true" will show line + function stack
#
# EXAMPLE OUTPUT
# --------------
# [log::debug 0.000000] 12: init debug message                <-- formatting: [debug time] {debug line} {message} -> {function calls, if verbose}
# [log::debug 1.000000] 27: this is 1 second after
# [log::debug 1.000546] 45: 5.46 milliseconds after
# [log::debug 1.043411] 139: this one's verbose -> 138: func() 155: main()
#
# 100% bash builtins, no external programs.

log::debug() {
	# to enable debug to show up, make sure
	# STD_LOG_DEBUG gets set "true" somewhere
	[[ $STD_LOG_DEBUG != true ]] && return 0
	# if first time running, initiate debug time and return
	if [[ -z $STD_LOG_DEBUG_INIT ]]; then
		declare -g STD_LOG_DEBUG_INIT
		STD_LOG_DEBUG_INIT=${EPOCHREALTIME//./}
		printf "\r\e[2K\033[1;90m%s\033[0m%s" "[log::debug 0.000000] " "${BASH_LINENO}: $@ "
		# print line + function stack
		if [[ $STD_LOG_DEBUG_VERBOSE = true ]]; then
			printf "\033[1;93m%s" "-> "
			local f i
			i=1
			for f in ${BASH_LINENO[@]}; do
				[[ $f = 0 ]] && break
				printf "\033[1;91m%s\033[1;92m%s" "${f}: " "${FUNCNAME[${i}]}() "
				((i++))
			done
		fi
		printf "\033[0m\n"
		return
	fi
	# local variable init
	local STD_LOG_DEBUG_ADJUSTED STD_LOG_DEBUG_DOT
	# current unix time - init unix time = current time in seconds
	# 1656979999.949650 - 1656979988.549640 = 11.400010
	# remove the '.' so the math works
	STD_LOG_DEBUG_ADJUSTED=$((${EPOCHREALTIME//./}-STD_LOG_DEBUG_INIT))
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
	STD_LOG_DEBUG_DOT=$((${#STD_LOG_DEBUG_ADJUSTED}-6))
	# if 6 digits long, that means one second
	# hasn't even passed, so just print 0.$the_number
	if [[ $STD_LOG_DEBUG_DOT -eq 0 ]]; then
		printf "\r\e[2K\033[1;90m%s\033[0m%s" "[log::debug 0.${STD_LOG_DEBUG_ADJUSTED}] " "${BASH_LINENO}: $@ "
	else
	# else print the integer, '.', then decimals
		printf "\r\e[2K\033[1;90m%s\033[0m%s" \
			"[log::debug ${STD_LOG_DEBUG_ADJUSTED:0:${STD_LOG_DEBUG_DOT}}.${STD_LOG_DEBUG_ADJUSTED:${STD_LOG_DEBUG_DOT}}] " "${BASH_LINENO}: $@ "
	fi
	# print line + function stack
	if [[ $STD_LOG_DEBUG_VERBOSE = true ]]; then
		printf "\033[1;93m%s" "-> "
		local f i
		i=1
		for f in ${BASH_LINENO[@]}; do
			[[ $f = 0 ]] && break
			printf "\033[1;91m%s\033[1;92m%s" "${f}: " "${FUNCNAME[${i}]}() "
			((i++))
		done
	fi
	printf "\033[0m\n"
}
