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

#git <stdlib/trace.sh/8038e38>

# trace()
# -------
# this function pair catches errors between them,
# traces them, prints useful info, then exits.
# system/script debug info is printed along
# with an inline view of which command failed
# in the script with color-coded context.
#
# safety measures are taken to prevent
# trace from NOT exiting. as long as both the
# functions are defined properly, they will
# execute properly, or at the very least, exit.
#
#     --- 100% WRITTEN WITH BASH BUILTINS ---
#
# 0 external binaries are used, which makes trace fast
# and quite portable, as long as the shell is bash 4.4+
# for context, current old_old_debian (debian 9 stretch)
# has bash v4.4-5, released in 2016.

################################################################
# PIPE ERRORS                                                  #
# ------------------------------------------------------------ #
# any error inside a pipeline will trigger trace.              #
#                                                              #
# true | true | false | true                                   #
#                 ^                                            #
#                 |_ this will trigger trace()                 #
################################################################
# CONDITIONAL ERRORS                                           #
# ------------------------------------------------------------ #
# error'ed commands are immune to trace() if they              #
# are handled by these conditional tests:                      #
# - if then                                                    #
# - && ||                                                      #
#                                                              #
# if ! bad_command; then   <-- even though bad_command failed, #
#     echo "its okay"          it's part of a test, so trace() #
# fi                           will not consider it an error.  #
#                                                              #
# [[ -n $NULL_VAR ]] || echo "this is immune too"              #
#                                                              #
# [[ -n $NULL_VAR ]]       <-- this WILL trigger trace()       #
#                              as it returns a raw error       #
################################################################
# MANUAL EXITS                                                 #
# ------------------------------------------------------------ #
# trace() will not trigger if you manually exit, even if the   #
# exit code is non-zero, however, non-zero function returns    #
# WILL count as errors and triggers trace().                   #
#                                                              #
# my_func() {                                                  #
#     if ! pls_work; then                                      #
#         exit 1           <-- this WON'T count as an error    #
#     fi                       and trace() WILL NOT trigger    #
#                                                              #
#     if ! pls_work; then                                      #
#         return 1         <-- this WILL count as an error     #
#     fi                       and trace() WILL trigger        #
#                                                              #
#     exit 1               <-- conditionals not required,      #
#                              a raw exit will behave the      #
#                              same and NOT trigger trace()    #
# }                                                            #
###################################################################################
# EXAMPLE CODE                                                                    #
# ------------------------------------------------------------------------------- #
# ___BEGIN___ERROR___TRACE___  <-- this function initiates trace()                #
#                                                                                 #
# echo "good command"          <-- these commands will run fine                   #
# echo "this is fine"                                                             #
#                                                                                 #
# VAR=$(null_command)          <-- this null_command will FAIL and trigger        #
#                                  trace + debug + exit. without trace(), $VAR    #
#                                  would now be NULL or "", making the next       #
#                                  command catastrophic.                          #
#                                                                                 #
# rm -rf $VAR/*                <-- this dangerous rm won't execute because        #
#                                  trace() exit on the last command. without it,  #
#                                  this would remove your /* root directory.      #
#                                                                                 #
# ___ENDOF___ERROR___TRACE___  <-- this closes, and disables trace()              #
###################################################################################
# $STD_TRACE_RETURN ENVIRONMENTAL VARIABLE #
# ---------------------------------------- #
# trace() has a special environmental      #
# variable called: $STD_TRACE_RETURN. this #
# variable is scattered throughout certain #
# stdlib error-prone functions. it gives   #
# trace() an extra line of information on  #
# how the stdlib function failed,          #
# example output:                          #
#                                          #
# [STD_TRACE_RETURN] array found: a[0]=hi  #
#                    ^                     #
#                    |                     #
#             this means array()           #
#             found an array that          #
#             you tried to declare.        #
#                                          #
# it's possible to set this variable in    #
# regular code, but it may prove useful    #
# to not do so and keep regular errors     #
# and stdlib function errors distinct.     #
############################################

___BEGIN___ERROR___TRACE___() {
	# ultra paranoid safety measures (unset bash builtins)
	POSIXLY_CORRECT= || exit 8
	\unset -f true false trap set return exit printf unset local return read unalias mapfile kill builtin wait || exit 9
	\unalias -a || exit 10
	unset -v POSIXLY_CORRECT || exit 11
	unset -f : || exit 1
	# set trap to catch error data
	trap 'STD_TRACE_CMD="$BASH_COMMAND" STD_TRACE_FUNC=(${BASH_LINENO[@]}) STD_TRACE_CMD_NUM="$LINENO" STD_TRACE_PIPE=(${PIPESTATUS[@]}); ___ENDOF___ERROR___TRACE___ > /dev/tty || exit 100' ERR || exit 12
	# ^
	# |_ this is sent to /dev/tty because command=$(substitutions)
	#    will eat the trace output, sending to /dev/tty overrides this.
	unset -v STD_TRACE_CMD STD_TRACE_FUNC_NUM STD_TRACE_CMD_NUM STD_TRACE_PIPE || exit 13
	set -E -e -o pipefail || exit 14
	return 0
}

___ENDOF___ERROR___TRACE___() {
	# ultra paranoid safety measures (unset bash builtins)
	POSIXLY_CORRECT= || exit 15
	\unset -f true false trap set return exit printf unset local return read unalias mapfile kill builtin wait || exit 16
	\unalias -a || exit 17
	unset -v POSIXLY_CORRECT || exit 18
	unset -f : || exit 1
	# disarm if no trap
	if [[ -z $STD_TRACE_PIPE ]]; then
		# disarm
		unset -v STD_TRACE_CMD STD_TRACE_FUNC_NUM STD_TRACE_CMD_NUM STD_TRACE_PIPE || exit 23
		set +E +eo pipefail || exit 24
		trap - ERR || exit 25
		return 0
	fi
	# print trace info
	printf "\e[1;91m%s\n" "========  BEGIN ERROR TRACE  ========"
	printf "\e[1;95m%s\e[0m%s\n" "[bash] " "$BASH_VERSION"
	printf "\e[1;96m%s\e[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\e[1;91m%s" "[code] "
	for i in "${STD_TRACE_PIPE[@]}"; do
		printf "\e[0m%s" "$i"
	done
	printf "\n\e[1;97m%s\e[0m%s\n" "[file] " "${BASH_SOURCE[-1]}"
	printf "\e[1;94m%s\e[0m%s\n" "[ wd ] " "$PWD"
	printf "\e[1;93m%s\e[0m%s\n" "[ \$_ ] " "${STD_TRACE_CMD_NUM}: $STD_TRACE_CMD"
	# print function stack
	local f
	local i=1
	for f in "${STD_TRACE_FUNC[@]}"; do
		[[ $f = 0 ]] && break
		printf "\e[1;92m%s\e[0m%s\n" "[func] " "${f}: ${FUNCNAME[${i}]}()"
		((i++))
	done
	# put trace lines into array, error line in middle, 9 lines total
	local STD_TRACE_LINE_ARRAY
	local STD_ORIGINAL_LINE="$STD_TRACE_CMD_NUM"
	# prevent negative starting line
	if [[ $STD_TRACE_CMD_NUM -lt 5 ]]; then
		local STD_TRACE_CMD_NUM=1
		mapfile -n 9 STD_TRACE_LINE_ARRAY < "$0"
	else
		local STD_TRACE_CMD_NUM=$((STD_TRACE_CMD_NUM-4))
		mapfile -s $((STD_TRACE_CMD_NUM-1)) -n 9 STD_TRACE_LINE_ARRAY < "$0"
	fi
	# print lines with numbers (with manual spacing)
	# the array elements already have newlines,
	# so none are added with printf.
	for i in {0..8}; do
		# if no lines left, break
		[[ ${STD_TRACE_LINE_ARRAY[$i]} ]] || break

	# TAB SPACING
	# -----------
	# TRACE() DEFAULT IS: TAB = 4 SPACES
	# TO CHANGE, EDIT THIS VARIABLE:
	  local STD_TRACE_SPACING="    "

		# if error line, print bold white
		if [[ $STD_TRACE_CMD_NUM = "$STD_ORIGINAL_LINE" ]]; then
			case ${#STD_TRACE_CMD_NUM} in
				1) printf "\e[1;97m%s" "     $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				2) printf "\e[1;97m%s" "    $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				3) printf "\e[1;97m%s" "   $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				4) printf "\e[1;97m%s" "  $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				5) printf "\e[1;97m%s" " $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				*) printf "\e[1;97m%s" "$STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
			esac
		# else print grey
		else
			case ${#STD_TRACE_CMD_NUM} in
				1) printf "\e[1;90m%s" "     $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				2) printf "\e[1;90m%s" "    $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				3) printf "\e[1;90m%s" "   $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				4) printf "\e[1;90m%s" "  $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				5) printf "\e[1;90m%s" " $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				*) printf "\e[1;90m%s" "$STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
			esac
		fi
		((STD_TRACE_CMD_NUM++))
	done
	# STD_TRACE_RETURN
	[[ $STD_TRACE_RETURN ]] && printf "\e[38;5;196m%s\e[0;1m%s\e[0m\n" "[STD_TRACE_RETURN]" " $STD_TRACE_RETURN"
	printf "\e[1;91m%s\e[0m\n" "========  ENDOF ERROR TRACE  ========"
	# disarm and exit
	unset -v STD_TRACE_CMD STD_TRACE_FUNC_NUM STD_TRACE_CMD_NUM STD_TRACE_PIPE || exit 26
	set +E +eo pipefail || exit 27
	trap - ERR || exit 28
	# if we're in a subshell, terminate the original shell. killing instead of terminating would be a bit safer
	# as no process can reject it, but this also means traps are killed. terminating allows any remaining traps
	# to properly execute. just in case though, there's an infinite loop after the terminate.
	if [[ $BASH_SUBSHELL != 0 ]]; then
		printf "\e[1;93m%s\e[0m\n" "======  SUB-SHELLS TERMINATED  ======"
	fi
	builtin kill -s TERM 0
	exit 99
	# just in case...
	printf "\e[1;97m%s\e[0m\n" "=KILL/EXIT FAIL, BEGIN INFINITE LOOP="
	while :; do read -s -r; done
	while true; do read -s -r; done
	while true; do false; done
	while :; do :; done
}
