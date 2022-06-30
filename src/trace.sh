#git <stdlib/trace.sh/d257147>
___BEGIN___ERROR___TRACE___(){
	trap 'TRACE_CMD="$BASH_COMMAND" TRACE_FUNC="${BASH_LINENO[@]}" TRACE_CMD_NUM="$LINENO" TRACE_CODE="$?" TRACE_PIPE="${PIPESTATUS[@]}"; ___ENDOF___ERROR___TRACE___ || exit 100' ERR || exit 11
	unset TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_CODE TRACE_PIPE || exit 22
	set -E -e -o pipefail || exit 33
	return 0
}

___ENDOF___ERROR___TRACE___(){
	# disarm if no trap
	if [[ -z $TRACE_CODE ]]; then
		set +E +eo pipefail || exit 44
		trap - ERR || exit 55
		return 0
	fi
	# trace
	printf "\033[1;91m%s\n" "========  BEGIN ERROR TRACE  ========"
	printf "\033[1;92m%s\033[0m%s\n" "[bash] " "$BASH_VERSION"
	printf "\033[1;96m%s\033[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\033[1;91m%s\033[0m%s\n" "[code] " "$TRACE_CODE"
	printf "\033[1;95m%s\033[0m%s\n" "[pipe] " "${TRACE_PIPE[@]}"
	printf "\033[1;97m%s\033[0m%s\n" "[file] " "${BASH_SOURCE[-1]}"
	printf "\033[1;93m%s\033[0m%s\n" "[ wd ] " "$PWD"
	printf "\033[1;94m%s\033[0m%s\n" "[ \$_ ] " "${TRACE_CMD_NUM}: $TRACE_CMD"
	local f
	local i=1
	for f in ${TRACE_FUNC[@]}; do
		[[ $f = 0 ]] && break
		printf "\033[1;92m%s\033[0m%s\n" "[func] " "${f}: ${FUNCNAME[${i}]}()"
		((i++))
	done
	# prevent negative integer for sed
	if [[ $TRACE_CMD_NUM -lt 5 ]]; then
		printf "\033[1;90m%s\n\033[1;97m%s\n\033[1;90m%s\033[0;m\n" \
			"$(sed -n "1,$((TRACE_CMD_NUM-1)) p" $0 | nl -s' ' -ba -v 1)" \
			"$(sed -n "$TRACE_CMD_NUM p" $0 | nl -s' ' -ba -v $TRACE_CMD_NUM)" \
			"$(sed -n "$((TRACE_CMD_NUM+1)),$((TRACE_CMD_NUM+4)) p" $0 | nl -s' ' -ba -v $((TRACE_CMD_NUM+1)))"
	else
	# print code lines
		printf "\033[1;90m%s\n\033[1;97m%s\n\033[1;90m%s\033[0;m\n" \
			"$(sed -n "$((TRACE_CMD_NUM-4)),$((TRACE_CMD_NUM-1)) p" $0 | nl -s' ' -ba -v $((TRACE_CMD_NUM-4)))" \
			"$(sed -n "$TRACE_CMD_NUM p" $0 | nl -s' ' -ba -v $TRACE_CMD_NUM)" \
			"$(sed -n "$((TRACE_CMD_NUM+1)),$((TRACE_CMD_NUM+4)) p" $0 | nl -s' ' -ba -v $((TRACE_CMD_NUM+1)))"
	fi
	printf "\033[1;91m%s\n" "========  ENDOF ERROR TRACE  ========"
	# exit
	unset TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_CODE TRACE_PIPE || exit 66
	set +E +eo pipefail || exit 77
	trap - ERR || exit 88
	exit 99
}
