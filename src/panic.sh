#git <stdlib/panic.sh/76f0927>
panic() {
	local PANIC_EXIT_CODE="$?" TRACE_FUNC=("${BASH_LINENO[@]}") || exit 98
	printf "\033[1;91m%s\n"\
		":::::::::::::::::"\
		":     panic     :"\
		":::::::::::::::::"
	local TRACE_CMD_NUM
	TRACE_CMD_NUM="${BASH_LINENO[0]}"
	local PANIC_CMD
	PANIC_CMD="$(sed -n "$TRACE_CMD_NUM p" $0)"
	printf "\033[1;97m%s\033[0m%s\n" "[file] " "${BASH_SOURCE[-1]}"
	printf "\033[1;91m%s\033[0m%s\n" "[code] " "$PANIC_EXIT_CODE"
	printf "\033[1;96m%s\033[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\033[1;93m%s\033[0m%s\n" "[ wd ] " "$PWD"
	printf "\033[1;94m%s\033[0m%s%s\n" "[ \$_ ] " "$TRACE_CMD_NUM: " "$(printf "%s" "$PANIC_CMD" | tr -d '\t')"
	local f
	local i=1
	TRACE_FUNC=("${TRACE_FUNC[@]:1}")
	for f in ${TRACE_FUNC[@]}; do
		[[ $f = 0 ]] && break
		printf "\033[1;92m%s\033[0m%s\n" "[func] " "${f}: ${FUNCNAME[${i}]}()"
		((i++))
	done
	#
	# prevent negative integer for sed
	if [[ $TRACE_CMD_NUM -lt 5 ]]; then
		printf "\033[1;90m%s\n\033[1;97m%s\n\033[1;90m%s\033[0;m\n" \
		"$(sed -n "1,$((TRACE_CMD_NUM-1)) p" $0 | nl -s' ' -ba -v 1)" \
		"$(echo "$PANIC_CMD" | nl -s' ' -ba -v $TRACE_CMD_NUM)" \
		"$(sed -n "$((TRACE_CMD_NUM+1)),$((TRACE_CMD_NUM+4)) p" $0 | nl -s' ' -ba -v $((TRACE_CMD_NUM+1)))"
	else
		# print code lines
		printf "\033[1;90m%s\n\033[1;97m%s\n\033[1;90m%s\033[0;m\n" \
		"$(sed -n "$((TRACE_CMD_NUM-4)),$((TRACE_CMD_NUM-1)) p" $0 | nl -s' ' -ba -v $((TRACE_CMD_NUM-4)))" \
		"$(echo "$PANIC_CMD" | nl -s' ' -ba -v $TRACE_CMD_NUM)" \
		"$(sed -n "$((TRACE_CMD_NUM+1)),$((TRACE_CMD_NUM+4)) p" $0 | nl -s' ' -ba -v $((TRACE_CMD_NUM+1)))"
	fi
	[[ $1 =~ ^[0-9]+$ ]] && exit $1 || exit 99
}


