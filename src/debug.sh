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

#git <stdlib/debug.sh/524ddb2>

# debug()
# -------
# a better set -x.
# traces and prints every single command
# similar to "set -x" but in the style of
# the stdlib.sh log::debug() & trace().

# USAGE
# -----
# call debug() and from there on the
# commands in that functions scope will
# be printed to stdout.
#
# debug() has a toggle environment variable
# similar to log::debug(): [ $STD_DEBUG=<true/false> ]
#
# my_func() {
#     debug                 <------ this means debug will only
#     some_commands                 get called if the variable
#     more_commands                 is set, essentially making
# }                                 it a toggle switch.

# log::debug() vs debug()
# -----------------------
# log::debug() is to manually write debug comments,
# debug() is an automatic trace that's more akin to
# putting "set -x" at the top of your script, but
# debug() can be togglable with [ export STD_DEBUG=<true/false> ]

# EXAMPLE OUTPUT
# --------------
# [debug 0.000070] [ $_ ] 327: log::prog "waiting..." -> 334: main()
# [debug 0.000150] [ $_ ] 328: read -t 1 -> 334: main()
# [debug 1.000594] [ $_ ] 328: true -> 334: main()
# [debug 1.000704] [ $_ ] 329: log::ok "done" -> 334: main()
# [  OK  ] done
# [debug 1.000802] [ $_ ] 331: header -> 334: main()
# [debug 1.000896] [ $_ ] 319: malloc var gar tar -> 331: header() 334: main()
# [debug 1.001132] [ $_ ] 332: ___ENDOF___ERROR___TRACE___ -> 334: main()


debug() {
	[[ $STD_DEBUG != true ]] && return 0
	trap 'STD_DEBUG_CMD="$BASH_COMMAND" STD_DEBUG_FUNC=(${BASH_LINENO[@]}) STD_DEBUG_CMD_NUM="$LINENO" STD_DEBUG_PIPE=(${PIPESTATUS[@]});debug::trap' DEBUG
}
#     ^
#     |
# this just sets a DEBUG trap that
# executes the below function: debug::trap()
# which is the function that does the tracing.
# debug::trap() is mostly spliced code between
# log::debug() and trace() with renamed variables.

debug::trap() {
	printf "\r\e[2K"
	if [[ -z $STD_DEBUG_INIT ]]; then
		declare -g STD_DEBUG_INIT
		STD_DEBUG_INIT=${EPOCHREALTIME//./}
		printf "\r\033[1;90m%s\033[0m" "[debug 0.000000] "
		return
	fi
	local STD_DEBUG_ADJUSTED STD_DEBUG_DOT
	STD_DEBUG_ADJUSTED=$((${EPOCHREALTIME//./}-STD_DEBUG_INIT))
	case ${#STD_DEBUG_ADJUSTED} in
		1) STD_DEBUG_ADJUSTED=00000${STD_DEBUG_ADJUSTED//$'\n'};;
		2) STD_DEBUG_ADJUSTED=0000${STD_DEBUG_ADJUSTED//$'\n'};;
		3) STD_DEBUG_ADJUSTED=000${STD_DEBUG_ADJUSTED//$'\n'};;
		4) STD_DEBUG_ADJUSTED=00${STD_DEBUG_ADJUSTED//$'\n'};;
		5) STD_DEBUG_ADJUSTED=0${STD_DEBUG_ADJUSTED//$'\n'};;
	esac
	STD_DEBUG_DOT=$((${#STD_DEBUG_ADJUSTED}-6))
	if [[ $STD_DEBUG_DOT -eq 0 ]]; then
		printf "\r\033[1;90m%s\033[1;93m%s\033[0m%s\033[1;93m%s" \
			"[debug 0.${STD_DEBUG_ADJUSTED}] " "[ \$_ ] " "${STD_DEBUG_CMD_NUM}: $STD_DEBUG_CMD " "-> "
			local f
			local i=1
			for f in ${STD_DEBUG_FUNC[@]-1}; do
				[[ $f = 0 ]] && break
				printf "\033[1;91m%s\033[1;92m%s" "${f}: " "${FUNCNAME[${i}]}() "
				((i++))
			done
			printf "\033[0m\n"
	else
		printf "\r\033[1;90m%s\033[1;93m%s\033[0m%s\033[1;93m%s" \
			"[debug ${STD_DEBUG_ADJUSTED:0:${STD_DEBUG_DOT}}.${STD_DEBUG_ADJUSTED:${STD_DEBUG_DOT}}] " \
			"[ \$_ ] " "${STD_DEBUG_CMD_NUM}: $STD_DEBUG_CMD " "-> "
			local f
			local i=1
			for f in ${STD_DEBUG_FUNC[@]-1}; do
				[[ $f = 0 ]] && break
				printf "\033[1;91m%s\033[1;92m%s" "${f}: " "${FUNCNAME[${i}]}() "
				((i++))
			done
			printf "\033[0m\n"
	fi
}
