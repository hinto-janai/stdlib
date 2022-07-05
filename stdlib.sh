#!/usr/bin/env bash
#git <stdlib.sh/bcc7072>
#nix <1657062428>
#hbc <20cccca>
#src <ask.sh>
#src <color.sh>
#src <crypto.sh>
#src <date.sh>
#src <guard.sh>
#src <hash.sh>
#src <is.sh>
#src <lock.sh>
#src <log.sh>
#src <malloc.sh>
#src <panic.sh>
#src <safety.sh>
#src <trace.sh>
#src <var.sh>

#-------------------------------------------------------------------------------- BEGIN SRC CODE
ask::yes() {
	local ASK_FUNC_RESPONSE || return 44
	read -r ASK_FUNC_RESPONSE
	case $ASK_FUNC_RESPONSE in
		""|y|Y|yes|Yes|YES) return 0 ;;
		*) return 2 ;;
	esac
}
ask::no() {
	local ASK_FUNC_RESPONSE || return 44
	read -r ASK_FUNC_RESPONSE
	case $ASK_FUNC_RESPONSE in
		y|Y|yes|Yes|YES) return 2 ;;
		*) return 0 ;;
	esac
}
ask::sudo() {
	sudo -v
}
color::black() { printf "\033[0;30m" ;}
color::red() { printf "\033[0;31m" ;}
color::green() { printf "\033[0;32m" ;}
color::yellow() { printf "\033[0;33m" ;}
color::blue() { printf "\033[0;34m" ;}
color::purple() { printf "\033[0;35m" ;}
color::cyan() { printf "\033[0;36m" ;}
color::white() { printf "\033[0;37m" ;}
color::bblack() { printf "\033[1;90m" ;}
color::bred() { printf "\033[1;91m" ;}
color::bgreen() { printf "\033[1;92m" ;}
color::byellow() { printf "\033[1;93m" ;}
color::bblue() { printf "\033[1;94m" ;}
color::bpurple() { printf "\033[1;95m" ;}
color::bcyan() { printf "\033[1;96m" ;}
color::bwhite() { printf "\033[1;97m" ;}
color::iblack() { printf "\033[0;90m" ;}
color::ired() { printf "\033[0;91m" ;}
color::igreen() { printf "\033[0;92m" ;}
color::iyellow() { printf "\033[0;93m" ;}
color::iblue() { printf "\033[0;94m" ;}
color::ipurple() { printf "\033[0;95m" ;}
color::icyan() { printf "\033[0;96m" ;}
color::iwhite() { printf "\033[0;97m" ;}
color::off() { printf "\033[0m" ;}
crypto::bytes() {
	[[ $# = 0 ]] && return 1
	head -c $1 /dev/random
}
crypto::num() {
	[[ $# = 0 ]] && return 1
	shuf -i 0-$1 -n 1
}
date::unix_translate() {
	if [[ -p /dev/stdin ]]; then
		local i || return 11
		for i in $(</dev/stdin); do
			date -d @"$i" || return 22
		done
		return 0
	fi
	[[ $# = 0 ]] && return 33
	while [[ $# != 0 ]]; do
		date -d @"$1" || return 44
		shift
	done
	return 0
}
date::unix() { printf "%s\n" "$EPOCHSECONDS" ;}
date::time() { date +"%T" ;}
date::calendar() { date +"%Y-%m-%d" ;}
date::now() { date +"%Y-%m-%d %T" ;}
date::year() { date +"%Y" ;}
date::month() { date +"%m" ;}
date::day() { date +"%d" ;}
date::hour() { date +"%H" ;}
date::minute() { date +"%M" ;}
date::second() { date +"%S" ;}
guard() {
	[[ $1 ]] || return 11
	local GUARD_HASH TMP_GUARD_HASH || return 22
	GUARD_HASH=$(\
		mapfile -n $((BASH_LINENO-1)) TMP_GUARD_HASH < "$0";
		mapfile -O $((BASH_LINENO-1)) -s $BASH_LINENO TMP_GUARD_HASH < "$0";
		printf "%s" "${TMP_GUARD_HASH[@]}" | sha1sum) || return 33
	if [[ ${GUARD_HASH// */} != "$1" ]]; then
		printf "%s\n" "${GUARD_HASH// */}"
		return 44
	fi
}
hash::md5() {
	set -o pipefail || return 11
	if [[ -p /dev/stdin ]]; then
		local i || return 22
		for i in $(</dev/stdin); do
			printf "%s" "$i" | md5sum | tr -d ' -' || return 33
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 55
		return 1
	fi
	while [[ $# != 0 ]]; do
		printf "%s" "$1" | md5sum | tr -d ' -' || return 66
		shift
	done
	set +o pipefail && return 0 || return 77
}
hash::sha1() {
	set -o pipefail || return 11
	if [[ -p /dev/stdin ]]; then
		local i || return 22
		for i in $(</dev/stdin); do
			printf "%s" "$i" | sha256sum | tr -d ' -' || return 33
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 55
		return 1
	fi
	while [[ $# != 0 ]]; do
		printf "%s" "$1" | sha256sum | tr -d ' -' || return 66
		shift
	done
	set +o pipefail && return 0 || return 77
}
hash::sha256() {
	set -o pipefail || return 11
	if [[ -p /dev/stdin ]]; then
		local i || return 22
		for i in $(</dev/stdin); do
			printf "%s" "$i" | sha256sum | tr -d ' -' || return 33
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 55
		return 1
	fi
	while [[ $# != 0 ]]; do
		printf "%s" "$1" | sha256sum | tr -d ' -' || return 66
		shift
	done
	set +o pipefail && return 0 || return 77
}
hash::sha512() {
	set -o pipefail || return 11
	if [[ -p /dev/stdin ]]; then
		local i || return 22
		for i in $(</dev/stdin); do
			printf "%s" "$i" | sha512sum | tr -d ' -' || return 33
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 55
		return 1
	fi
	while [[ $# != 0 ]]; do
		printf "%s" "$1" | sha512sum | tr -d ' -' || return 66
		shift
	done
	set +o pipefail && return 0 || return 77
}
is::int() {
	if [[ -p /dev/stdin ]]; then
		local i || return 11
		for i in $(</dev/stdin); do
			[ $i -eq $i ] &>/dev/null || return 22
		done
		return 0
	fi
	[[ $# = 0 ]] && return 33
	local i || return 44
	for i in $@; do
		[ $i -eq $i ] &>/dev/null || return 55
	done
}
is::int_pos() {
	if [[ -p /dev/stdin ]]; then
		local i || return 11
		for i in $(</dev/stdin); do
			[ $i -gt -1 ] &>/dev/null || return 22
			[ $i -eq $i ] &>/dev/null || return 33
		done
		return 0
	fi
	[[ $# = 0 ]] && return 44
	local i || return 55
	for i in $@; do
		[ $i -gt -1 ] &>/dev/null || return 66
		[ $i -eq $i ] &>/dev/null || return 77
	done
}
is::int_neg() {
	if [[ -p /dev/stdin ]]; then
		local i || return 11
		for i in $(</dev/stdin); do
			[ $i -lt 0 ] &>/dev/null || return 22
			[ $i -eq $i ] &>/dev/null || return 33
		done
		return 0
	fi
	[[ $# = 0 ]] && return 44
	local i || return 55
	for i in $@; do
		[ $i -lt 0 ] &>/dev/null || return 66
		[ $i -eq $i ] &>/dev/null || return 77
	done
}
lock::alloc() {
	trap 'lock::free' INT QUIT TERM || return 11
	flock -n $0 || return 22
	return 0
}
lock::free() {
	exec 200<&- || return 11
}
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
log::tab() {
	printf "\r%${COLUMNS}s" " "
	printf "\r\033[0m         %s\n" "$@"
}
log::prog() {
	printf "\r%${COLUMNS}s" " "
	printf "\r\033[1;37m[ \033[0m....\033[1;37m ]\033[0m %s " "$@"
}
log::debug() {
	printf "\r%${COLUMNS}s" " "
	if [[ -z $LOG_DEBUG_INIT_TIME ]]; then
		declare -g LOG_DEBUG_INIT_TIME
		LOG_DEBUG_INIT_TIME=${EPOCHREALTIME//./}
		printf "\r\033[0;0m[debug 0.000000] %s\n" "$1"
		return
	fi
	local LOG_DEBUG_ADJUSTED_TIME LOG_DEBUG_DOT_INSERTION
	LOG_DEBUG_ADJUSTED_TIME=$((${EPOCHREALTIME//./}-LOG_DEBUG_INIT_TIME))
	case ${#LOG_DEBUG_ADJUSTED_TIME} in
		1) LOG_DEBUG_ADJUSTED_TIME=00000${LOG_DEBUG_ADJUSTED_TIME};;
		2) LOG_DEBUG_ADJUSTED_TIME=0000${LOG_DEBUG_ADJUSTED_TIME};;
		3) LOG_DEBUG_ADJUSTED_TIME=000${LOG_DEBUG_ADJUSTED_TIME};;
		4) LOG_DEBUG_ADJUSTED_TIME=00${LOG_DEBUG_ADJUSTED_TIME};;
		5) LOG_DEBUG_ADJUSTED_TIME=0${LOG_DEBUG_ADJUSTED_TIME};;
	esac
	LOG_DEBUG_DOT_INSERTION=$((${#LOG_DEBUG_ADJUSTED_TIME}-6))
	if [[ $LOG_DEBUG_DOT_INSERTION -eq 0 ]]; then
		printf "\r\033[0;0m[debug 0.${LOG_DEBUG_ADJUSTED_TIME}] %s\n" "$1"
	else
		printf "\r\033[0;0m[debug ${LOG_DEBUG_ADJUSTED_TIME:0:${LOG_DEBUG_DOT_INSERTION}}.${LOG_DEBUG_ADJUSTED_TIME:${LOG_DEBUG_DOT_INSERTION}}] %s\n" "$1"
	fi
}
malloc::var() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 22
		declare -g $i || return 33
	done
	return 0
}
malloc::arr() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 22
		declare -a $i || return 33
	done
	return 0
}
malloc::ass() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 22
		declare -A $i || return 33
	done
	return 0
}
malloc::int() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 22
		declare -i $i || return 33
	done
	return 0
}
free::var() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null || return 22
		unset -v $i || return 33
	done
	return 0
}
free::func() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -F $i &>/dev/null || return 22
		unset -f $i || return 33
	done
	return 0
}
panic() {
	local PANIC_EXIT_CODE="$?" TRACE_FUNC=("${BASH_LINENO[@]}") TRACE_CMD_NUM=${BASH_LINENO[0]}|| exit 98
	POSIXLY_CORRECT= || exit 11
	\unset -f trap set return exit printf echo local unalias unset builtin kill || exit 22
	\unalias -a || exit 33
	unset POSIXLY_CORRECT || exit 44
	printf "\033[0;m%s\n" "@@@@@@@@  panic  @@@@@@@@"
	local PANIC_CMD
	mapfile -s $((TRACE_CMD_NUM-1)) -n 1 PANIC_CMD < $0
	printf "\033[1;95m%s\033[0m%s\n" "[bash] " "$BASH_VERSION"
	printf "\033[1;96m%s\033[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\033[1;97m%s\033[0m%s\n" "[file] " "${BASH_SOURCE[-1]}"
	printf "\033[1;91m%s\033[0m%s\n" "[code] " "$PANIC_EXIT_CODE"
	printf "\033[1;94m%s\033[0m%s\n" "[ wd ] " "$PWD"
	printf "\033[1;93m%s\033[0m%s" "[ \$_ ] " "$TRACE_CMD_NUM: ${PANIC_CMD//$'\t'/}"
	local f
	local i=1
	TRACE_FUNC=("${TRACE_FUNC[@]:1}")
	for f in ${TRACE_FUNC[@]}; do
		[[ $f = 0 ]] && break
		printf "\033[1;92m%s\033[0m%s\n" "[func] " "${f}: ${FUNCNAME[${i}]}()"
		((i++))
	done
	local TRACE_LINE_ARRAY
	local ORIGINAL_LINE="$TRACE_CMD_NUM"
	if [[ $TRACE_CMD_NUM -lt 5 ]]; then
		local TRACE_CMD_NUM=1
		mapfile -n 9 TRACE_LINE_ARRAY < $0
	else
		local TRACE_CMD_NUM=$((TRACE_CMD_NUM-4))
		mapfile -s $((TRACE_CMD_NUM-1)) -n 9 TRACE_LINE_ARRAY < $0
	fi
	for i in {0..8}; do
		[[ ${TRACE_LINE_ARRAY[$i]} ]] || break
		if [[ $TRACE_CMD_NUM = "$ORIGINAL_LINE" ]]; then
			case ${#TRACE_CMD_NUM} in
				1) printf "\033[1;97m%s" "     $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				2) printf "\033[1;97m%s" "    $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				3) printf "\033[1;97m%s" "   $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				4) printf "\033[1;97m%s" "  $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				5) printf "\033[1;97m%s" " $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				*) printf "\033[1;97m%s" "$TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
			esac
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
	while :; do read -s -r; done
	printf "\033[0;m%s\n" "@ loop fail, killing \$$ @"
	builtin kill $$
	[[ $1 =~ ^[0-9]+$ ]] && exit $1 || exit 99
}
safety::bash() { [[ ${BASH_VERSINFO[0]} -ge 5 ]] ;}
safety::gnu_linux() { [[ $OSTYPE = linux-gnu* ]] ;}
___BEGIN___ERROR___TRACE___() {
	POSIXLY_CORRECT= || exit 8
	\unset -f trap set return exit printf unset local return read unalias mapfile kill builtin || exit 9
	\unalias -a || exit 10
	unset POSIXLY_CORRECT || exit 11
	trap 'TRACE_CMD="$BASH_COMMAND" TRACE_FUNC=(${BASH_LINENO[@]}) TRACE_CMD_NUM="$LINENO" TRACE_PIPE=(${PIPESTATUS[@]}); ___ENDOF___ERROR___TRACE___ || exit 100' ERR || exit 12
	unset -v TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_PIPE || exit 13
	set -E -e -o pipefail || exit 14
	return 0
}
___ENDOF___ERROR___TRACE___() {
	POSIXLY_CORRECT= || exit 15
	\unset -f trap set return exit printf unset local return read unalias mapfile kill builtin || exit 16
	\unalias -a || exit 17
	unset POSIXLY_CORRECT || exit 18
	if [[ -z $TRACE_PIPE ]]; then
		POSIXLY_CORRECT= || exit 19
		\unset -f trap set return exit return || exit 20
		\unalias -a || exit 21
		unset POSIXLY_CORRECT || exit 22
		unset -v TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_PIPE || exit 23
		set +E +eo pipefail || exit 24
		trap - ERR || exit 25
		return 0
	fi
	printf "\033[1;91m%s\n" "========  BEGIN ERROR TRACE  ========"
	printf "\033[1;95m%s\033[0m%s\n" "[bash] " "$BASH_VERSION"
	printf "\033[1;96m%s\033[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\033[1;91m%s\033[0m%s\n" "[code] " "${TRACE_PIPE[@]}"
	printf "\033[1;97m%s\033[0m%s\n" "[file] " "${BASH_SOURCE[-1]}"
	printf "\033[1;94m%s\033[0m%s\n" "[ wd ] " "$PWD"
	printf "\033[1;93m%s\033[0m%s\n" "[ \$_ ] " "${TRACE_CMD_NUM}: $TRACE_CMD"
	local f
	local i=1
	for f in ${TRACE_FUNC[@]}; do
		[[ $f = 0 ]] && break
		printf "\033[1;92m%s\033[0m%s\n" "[func] " "${f}: ${FUNCNAME[${i}]}()"
		((i++))
	done
	local TRACE_LINE_ARRAY
	local ORIGINAL_LINE="$TRACE_CMD_NUM"
	if [[ $TRACE_CMD_NUM -lt 5 ]]; then
		local TRACE_CMD_NUM=1
		mapfile -n 9 TRACE_LINE_ARRAY < $0
	else
		local TRACE_CMD_NUM=$((TRACE_CMD_NUM-4))
		mapfile -s $((TRACE_CMD_NUM-1)) -n 9 TRACE_LINE_ARRAY < $0
	fi
	for i in {0..8}; do
		[[ ${TRACE_LINE_ARRAY[$i]} ]] || break
		if [[ $TRACE_CMD_NUM = "$ORIGINAL_LINE" ]]; then
			case ${#TRACE_CMD_NUM} in
				1) printf "\033[1;97m%s" "     $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				2) printf "\033[1;97m%s" "    $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				3) printf "\033[1;97m%s" "   $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				4) printf "\033[1;97m%s" "  $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				5) printf "\033[1;97m%s" " $TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
				*) printf "\033[1;97m%s" "$TRACE_CMD_NUM ${TRACE_LINE_ARRAY[${i}]}" ;;
			esac
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
	[[ $TRACE_CMD =~ ^\(.*\)$ ]] && printf "\033[1;93m%s\033[0m\n" "========  SUB-SHELLS KILLED  ========"
	unset -v TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_PIPE || exit 26
	set +E +eo pipefail || exit 27
	trap - ERR || exit 28
	builtin kill -s SIGKILL $$
	exit 99
	printf "\033[1;97m%s\033[0m\n" "= KILL FAIL, ENTERING INFINITE LOOP ="
	while :; do read -s -r; done
}
readonly BLACK="\033[0;30m"
readonly RED="\033[0;31m"
readonly GREEN="\033[0;32m"
readonly YELLOW="\033[0;33m"
readonly BLUE="\033[0;34m"
readonly PURPLE="\033[0;35m"
readonly CYAN="\033[0;36m"
readonly WHITE="\033[0;37m"
readonly BBLACK="\033[1;90m"
readonly BRED="\033[1;91m"
readonly BGREEN="\033[1;92m"
readonly BYELLOW="\033[1;93m"
readonly BBLUE="\033[1;94m"
readonly BPURPLE="\033[1;95m"
readonly BCYAN="\033[1;96m"
readonly BWHITE="\033[1;97m"
readonly UBLACK="\033[4;30m"
readonly URED="\033[4;31m"
readonly UGREEN="\033[4;32m"
readonly UYELLOW="\033[4;33m"
readonly UBLUE="\033[4;34m"
readonly UPURPLE="\033[4;35m"
readonly UCYAN="\033[4;36m"
readonly UWHITE="\033[4;37m"
readonly IBLACK="\033[0;90m"
readonly IRED="\033[0;91m"
readonly IGREEN="\033[0;92m"
readonly IYELLOW="\033[0;93m"
readonly IBLUE="\033[0;94m"
readonly IPURPLE="\033[0;95m"
readonly ICYAN="\033[0;96m"
readonly IWHITE="\033[0;97m"
readonly OFF="\033[0m"
