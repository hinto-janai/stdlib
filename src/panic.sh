#git <stdlib/panic.sh/cc3d85c>
# panic
# -----
# print error information and
# enter endless loop to prevent
# futher code execution. must
# be called manually, does not
# catch errors like trace.

panic() {
	# get error info
	local PANIC_EXIT_CODE="$?" TRACE_FUNC=("${BASH_LINENO[@]}") TRACE_CMD_NUM=${BASH_LINENO[0]}|| exit 98
	# ultra paranoid safety measures (unset bash builtins)
	POSIXLY_CORRECT= || exit 11
	\unset -f trap set return exit printf echo local unalias unset builtin kill || exit 22
	\unalias -a || exit 33
	unset POSIXLY_CORRECT || exit 44
	printf "\033[0;m%s\n" "@@@@@@@@  panic  @@@@@@@@"
	# get command based off line number from $TRACE_CMD_NUM
	local PANIC_CMD
	mapfile -s $((TRACE_CMD_NUM-1)) -n 1 PANIC_CMD < $0
	# print info
	printf "\033[1;95m%s\033[0m%s\n" "[bash] " "$BASH_VERSION"
	printf "\033[1;96m%s\033[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\033[1;97m%s\033[0m%s\n" "[file] " "${BASH_SOURCE[-1]}"
	printf "\033[1;91m%s\033[0m%s\n" "[code] " "$PANIC_EXIT_CODE"
	printf "\033[1;94m%s\033[0m%s\n" "[ wd ] " "$PWD"
	printf "\033[1;93m%s\033[0m%s" "[ \$_ ] " "$TRACE_CMD_NUM: ${PANIC_CMD//$'\t'/}"
	# print function stack
	local f
	local i=1
	TRACE_FUNC=("${TRACE_FUNC[@]:1}")
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
	printf "\033[0;m%s\n" "@@@@@@@@  panic  @@@@@@@@"
	# endless loop
	while :; do read -s -r; done
	# just in case, kill and exit
	printf "\033[0;m%s\n" "@ loop fail, killing \$$ @"
	builtin kill $$
	[[ $1 =~ ^[0-9]+$ ]] && exit $1 || exit 99
}
