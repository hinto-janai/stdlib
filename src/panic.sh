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

#git <stdlib/panic.sh/28d9c9b>

# panic()
# ------
# print error information and
# enter endless loop to prevent
# futher code execution. must
# be called manually, does not
# catch errors like trace().

panic() {
	# get error info
	local STD_PANIC_CODE="$?" STD_TRACE_FUNC=("${BASH_LINENO[@]}") STD_TRACE_CMD_NUM=${BASH_LINENO[0]}|| exit 98
	# ultra paranoid safety measures (unset bash builtins)
	POSIXLY_CORRECT= || exit 11
	\unset -f trap set return exit printf echo local unalias unset builtin kill || exit 22
	\unalias -a || exit 33
	unset POSIXLY_CORRECT || exit 44
	printf "\033[0;m%s\n" "@@@@@@@@  panic  @@@@@@@@"
	# get command based off line number from $STD_TRACE_CMD_NUM
	local STD_PANIC_CMD
	mapfile -s $((STD_TRACE_CMD_NUM-1)) -n 1 STD_PANIC_CMD < $0
	# print info
	printf "\033[1;95m%s\033[0m%s\n" "[bash] " "$BASH_VERSION"
	printf "\033[1;96m%s\033[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\033[1;97m%s\033[0m%s\n" "[file] " "${BASH_SOURCE[-1]}"
	printf "\033[1;91m%s\033[0m%s\n" "[code] " "$STD_PANIC_CODE"
	printf "\033[1;94m%s\033[0m%s\n" "[ wd ] " "$PWD"
	printf "\033[1;93m%s\033[0m%s" "[ \$_ ] " "$STD_TRACE_CMD_NUM: ${STD_PANIC_CMD//$'\t'/}"
	# print function stack
	local f
	local i=1
	STD_TRACE_FUNC=("${STD_TRACE_FUNC[@]:1}")
	for f in ${STD_TRACE_FUNC[@]}; do
		[[ $f = 0 ]] && break
		printf "\033[1;92m%s\033[0m%s\n" "[func] " "${f}: ${FUNCNAME[${i}]}()"
		((i++))
	done
	# put trace lines into array, error line in middle, 9 lines total
	local STD_TRACE_LINE_ARRAY
	local STD_ORIGINAL_LINE="$STD_TRACE_CMD_NUM"
	# prevent negative starting line
	if [[ $STD_TRACE_CMD_NUM -lt 5 ]]; then
		local STD_TRACE_CMD_NUM=1
		mapfile -n 9 STD_TRACE_LINE_ARRAY < $0
	else
		local STD_TRACE_CMD_NUM=$((STD_TRACE_CMD_NUM-4))
		mapfile -s $((STD_TRACE_CMD_NUM-1)) -n 9 STD_TRACE_LINE_ARRAY < $0
	fi
	# print lines with numbers (with manual spacing)
	# the array elements already have newlines,
	# so none are added with printf.
	for i in {0..8}; do
		# if no lines left, break
		[[ ${STD_TRACE_LINE_ARRAY[$i]} ]] || break
		# if error line, print bold white
		if [[ $STD_TRACE_CMD_NUM = "$STD_ORIGINAL_LINE" ]]; then
			case ${#STD_TRACE_CMD_NUM} in
				1) printf "\033[1;97m%s" "     $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				2) printf "\033[1;97m%s" "    $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				3) printf "\033[1;97m%s" "   $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				4) printf "\033[1;97m%s" "  $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				5) printf "\033[1;97m%s" " $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				*) printf "\033[1;97m%s" "$STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
			esac
		# else print grey
		else
			case ${#STD_TRACE_CMD_NUM} in
				1) printf "\033[1;90m%s" "     $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				2) printf "\033[1;90m%s" "    $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				3) printf "\033[1;90m%s" "   $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				4) printf "\033[1;90m%s" "  $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				5) printf "\033[1;90m%s" " $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				*) printf "\033[1;90m%s" "$STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
			esac
		fi
		((STD_TRACE_CMD_NUM++))
	done
	printf "\033[0;m%s\n" "@@@@@@@@  panic  @@@@@@@@"
	# endless loop
	while :; do read -s -r; done
	# just in case, kill and exit
	printf "\033[0;m%s\n" "@ loop fail, killing \$$ @"
	builtin kill $$
	[[ $1 =~ ^[0-9]+$ ]] && exit $1 || exit 99
}
