#git <stdlib/log.sh/cc3d85c>
# log
# ---
# print formatted
# messages to the terminal.
# lines are cleared with spaces
# the length of $COLUMNS, then
# message is printed. this is to
# avoid previous messages (from log::prog)
# from leaving traces. can take
# multiple inputs, each input will
# be formatted and print a newline.
log::ok() {
	printf "\r%${COLUMNS}s" " "
	printf "\r\033[1;32m[  OK  ]\033[0m %s\n" "$@"
}
log::info() {
	printf "\r%${COLUMNS}s" " "
	printf "\r\033[1;37m[ INFO ]\033[0m %s\n" "$@"
}
log::warn() {
	printf "\r%${COLUMNS}s" " "
	printf "\r\033[1;33m[ WARN ]\033[0m %s\n" "$@"
}
log::fail() {
	printf "\r%${COLUMNS}s" " "
	printf "\r\033[1;31m[ FAIL ]\033[0m %s\n" "$@"
}
log::danger() {
	printf "\r%${COLUMNS}s" " "
	printf "\r\033[1;31m[DANGER]\033[0m %s\n" "$@"
}

# format with 8 spaces instead of []
log::tab() {
	printf "\r%${COLUMNS}s" " "
	printf "\r\033[0m         %s\n" "$@"
}

# do not print a newline, leave cursor at the end.
# printing a different log:: will overwrite this one.
log::prog() {
	printf "\r%${COLUMNS}s" " "
	printf "\r\033[1;37m[ \033[0m....\033[1;37m ]\033[0m %s " "$@"
}

# log::debug
# ----------
# this uses the $EPOCHREALTIME variable to
# calculate the seconds that have passed.
# the first call of log::debug() initiates
# the $LOG_DEBUG_INIT_TIME and starts
# counting from there.
#
# ENVIRONMENT VARIABLES:
# $LOG_DEBUG_INIT_TIME - the unix time used as a baseline reference
# $LOG_DEBUG_ENABLED - "true" will enable debug to printed
# $LOG_DEBUG_VERBOSE - "true" will show line + function stack
#
# EXAMPLE OUTPUT:
# [debug 0.000000] init debug message
# [debug 1.000000] this is 1 second after
# [debug 1.000546] 5.46 milliseconds after
# [debug 1.043411] 138: func() 155: main() | this one's verbose
#
# 100% Bash builtins, no external programs.
log::debug() {
	# to enable debug to show up, make sure
	# LOG_DEBUG_ENABLED gets set "true" somewhere
	[[ $LOG_DEBUG_ENABLED != true ]] && return 0
	# standard log:: line wiping
	printf "\r%${COLUMNS}s" " "
	# if first time running, initiate debug time and return
	if [[ -z $LOG_DEBUG_INIT_TIME ]]; then
		declare -g LOG_DEBUG_INIT_TIME
		LOG_DEBUG_INIT_TIME=${EPOCHREALTIME//./}
		printf "\r\033[1;90m%s\033[0m" "[debug 0.000000] "
		# print line + function stack
		if [[ $LOG_DEBUG_VERBOSE = true ]]; then
			local f i
			i=1
			for f in ${BASH_LINENO[@]}; do
				[[ $f = 0 ]] && break
				printf "\033[0;91m%s\033[1;92m%s\033[0m" "${f}: " "${FUNCNAME[${i}]}() "
				((i++))
			done
		fi
		# print arguments given
		printf "| %s\n" "$@"
		return
	fi
	# local variable init
	local LOG_DEBUG_ADJUSTED_TIME LOG_DEBUG_DOT_INSERTION
	# current unix time - init unix time = current time in seconds
	# 1656979999.949650 - 1656979988.549640 = 11.400010
	# remove the '.' so the math works
	LOG_DEBUG_ADJUSTED_TIME=$((${EPOCHREALTIME//./}-LOG_DEBUG_INIT_TIME))
	# during init cases, the difference
	# can be as low as 0.000002 which
	# renders as just 2. this is a problem
	# because we need the digit to be
	# greater than 6 digits long. this
	# case statement adds leading 0's
	# so that 2 becomes 000002
	case ${#LOG_DEBUG_ADJUSTED_TIME} in
		1) LOG_DEBUG_ADJUSTED_TIME=00000${LOG_DEBUG_ADJUSTED_TIME};;
		2) LOG_DEBUG_ADJUSTED_TIME=0000${LOG_DEBUG_ADJUSTED_TIME};;
		3) LOG_DEBUG_ADJUSTED_TIME=000${LOG_DEBUG_ADJUSTED_TIME};;
		4) LOG_DEBUG_ADJUSTED_TIME=00${LOG_DEBUG_ADJUSTED_TIME};;
		5) LOG_DEBUG_ADJUSTED_TIME=0${LOG_DEBUG_ADJUSTED_TIME};;
	esac
	# this is to add back the '.', currently the number
	# is something like 000002 or 1000543
	LOG_DEBUG_DOT_INSERTION=$((${#LOG_DEBUG_ADJUSTED_TIME}-6))
	# if 6 digits long, that means one second
	# hasn't even passed, so just print 0.$the_number
	if [[ $LOG_DEBUG_DOT_INSERTION -eq 0 ]]; then
		printf "\r\033[1;90m%s\033[0m" "[debug 0.${LOG_DEBUG_ADJUSTED_TIME}] "
		# print line + function stack
		if [[ $LOG_DEBUG_VERBOSE = true ]]; then
			local f i
			i=1
			for f in ${BASH_LINENO[@]}; do
				[[ $f = 0 ]] && break
				printf "\033[0;91m%s\033[1;92m%s\033[0m" "${f}: " "${FUNCNAME[${i}]}() "
				((i++))
			done
		fi
		# print arguments
		printf "| %s\n" "$@"
	else
	# else print the integer, '.', then decimals
		printf "\r\033[1;90m%s\033[0m" "[debug ${LOG_DEBUG_ADJUSTED_TIME:0:${LOG_DEBUG_DOT_INSERTION}}.${LOG_DEBUG_ADJUSTED_TIME:${LOG_DEBUG_DOT_INSERTION}}] "
		# print line + function stack
		if [[ $LOG_DEBUG_VERBOSE = true ]]; then
			local f i
			i=1
			for f in ${BASH_LINENO[@]}; do
				[[ $f = 0 ]] && break
				printf "\033[0;91m%s\033[1;92m%s\033[0m" "${f}: " "${FUNCNAME[${i}]}() "
				((i++))
			done
		fi
		# print arguments
		printf "| %s\n" "$@"
	fi
}
