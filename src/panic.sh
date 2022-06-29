#git <stdlib/panic.sh/e3af68e>
panic(){
	local PANIC_EXIT_CODE="$?" PANIC_LAST_ARG="$_" || exit 98
	printf "\033[1;31m%s\n"\
		":::::::::::::::::"\
		":     panic     :"\
		":::::::::::::::::"
	printf "\033[1;34m%s\033[0m%s\n" "[  \$_  ] " "${BASH_LINENO[0]}: $PANIC_LAST_ARG"
	printf "\033[1;32m%s\033[0m%s\n" "[ func ] " "${BASH_LINENO[1]}: ${FUNCNAME[1]}()"
	printf "\033[1;37m%s\033[0m%s\n" "[ file ] " "${BASH_SOURCE[-1]}"
	printf "\033[1;31m%s\033[0m%s\n" "[ code ] " "$PANIC_EXIT_CODE"
	printf "\033[1;96m%s\033[0m%s\n" "[ unix ] " "$EPOCHSECONDS"
	printf "\033[1;93m%s\033[0m%s\n" "[  wd  ] " "$PWD"
	[[ $1 ]] && exit $1 || exit 99
}


