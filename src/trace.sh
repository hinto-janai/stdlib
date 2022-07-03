#git <stdlib/trace.sh/6cf3ad6>
# trace
# -----
# this function pair catches errors between them,
# traces them, prints useful info, then exits.
# system/script debug info are printed along
# with an inline view of which command failed
# in the script with color-coded context.
#
# safety measures are taken to prevent
# trace from NOT exiting. as long as both the
# functions are defined properly, they will
# execute properly, or at the very least, exit.
#
# 100% written with bash builtins, 0 external
# programs called, which makes trace quite fast.

___BEGIN___ERROR___TRACE___() {
	# ultra paranoid safety measures (unset bash builtins)
#	POSIXLY_CORRECT= || exit 8
#	\unset -f trap set return exit printf echo unset local return read unalias mapfile || exit 9
#	\unalias -a || exit 10
#	unset POSIXLY_CORRECT || exit 11
	# set trap to catch error data
	trap 'TRACE_CMD="$BASH_COMMAND" TRACE_FUNC="${BASH_LINENO[@]}" TRACE_CMD_NUM="$LINENO" TRACE_PIPE="${PIPESTATUS[@]}"; ___ENDOF___ERROR___TRACE___ || exit 100' ERR || exit 12
	unset -v TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_PIPE || exit 13
	set -E -e -o pipefail || exit 14
	return 0
}

___ENDOF___ERROR___TRACE___() {
	# disarm if no trap
	if [[ -z $TRACE_PIPE ]]; then
		# paranoid safety
		POSIXLY_CORRECT= || exit 15
		\unset -f trap set return exit return || exit 16
		\unalias -a || exit 17
		unset POSIXLY_CORRECT || exit 18
		# disarm
		unset -v TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_PIPE || exit 19
		set +E +eo pipefail || exit 20
		trap - ERR || exit 21
		return 0
	fi
	# print trace info
	printf "\033[1;91m%s\n" "========  BEGIN ERROR TRACE  ========"
	printf "\033[1;95m%s\033[0m%s\n" "[bash] " "$BASH_VERSION"
	printf "\033[1;96m%s\033[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\033[1;91m%s\033[0m%s\n" "[code] " "${TRACE_PIPE[@]}"
	printf "\033[1;97m%s\033[0m%s\n" "[file] " "${BASH_SOURCE[-1]}"
	printf "\033[1;93m%s\033[0m%s\n" "[ wd ] " "$PWD"
	printf "\033[1;94m%s\033[0m%s\n" "[ \$_ ] " "${TRACE_CMD_NUM}: $TRACE_CMD"
	# print function stack
	local f
	local i=1
	for f in ${TRACE_FUNC[@]}; do
		[[ $f = 0 ]] && break
		printf "\033[1;92m%s\033[0m%s\n" "[func] " "${f}: ${FUNCNAME[${i}]}()"
		((i++))
	done
	# put trace lines into array, error line in middle, 9 lines total
	local TRACE_LINE_ARRAY
	local ORIGINAL_LINE="$TRACE_CMD_NUM"
	# prevent negative starting line
	if [[ $TRACE_CMD_NUM -lt 5 ]]; then
		local TRACE_CMD_NUM=1
		mapfile -n 9 TRACE_LINE_ARRAY < $0
	else
		local TRACE_CMD_NUM=$((TRACE_CMD_NUM-4))
		mapfile -s $((TRACE_CMD_NUM-1)) -n 9 TRACE_LINE_ARRAY < $0
	fi
	# print lines with numbers (with manual spacing)
	# i don't know why, but the array elements already
	# have newlines, so none are added with printf.
	for i in {0..8}; do
		# if no lines left, break
		[[ ${TRACE_LINE_ARRAY[$i]} ]] || break
		# if error line, print bold white
		if [[ $TRACE_CMD_NUM = "$ORIGINAL_LINE" ]]; then
			case ${#TRACE_CMD_NUM} in
				1) printf "\033[1;97m%s" "     $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				2) printf "\033[1;97m%s" "    $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				3) printf "\033[1;97m%s" "   $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				4) printf "\033[1;97m%s" "  $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				5) printf "\033[1;97m%s" " $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				*) printf "\033[1;97m%s" "$TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
			esac
		# else print grey
		else
			case ${#TRACE_CMD_NUM} in
				1) printf "\033[1;90m%s" "     $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				2) printf "\033[1;90m%s" "    $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				3) printf "\033[1;90m%s" "   $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				4) printf "\033[1;90m%s" "  $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				5) printf "\033[1;90m%s" " $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				*) printf "\033[1;90m%s" "$TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
			esac
		fi
		((TRACE_CMD_NUM++))
	done
	printf "\033[1;91m%s\033[0m\n" "========  ENDOF ERROR TRACE  ========"
	# disarm and exit
	unset -v TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_PIPE || exit 22
	set +E +eo pipefail || exit 23
	trap - ERR || exit 24
	exit 99
}
