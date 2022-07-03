#!/usr/bin/env bash
#git <stdlib.sh/06d98f9>
#nix <1656816051>
#hbc <6dfe9a3>
#src <alloc.sh>
#src <ask.sh>
#src <color.sh>
#src <crypto.sh>
#src <date.sh>
#src <hash.sh>
#src <is.sh>
#src <lock.sh>
#src <log.sh>
#src <panic.sh>
#src <safety.sh>
#src <trace.sh>
#src <var.sh>

#-------------------------------------------------------------------------------- BEGIN SRC CODE
malloc() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 22
		declare -g $i || return 33
	done
	return 0
}
free() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null || return 22
		unset -v $i || return 33
	done
	return 0
}
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
color::bblack() { printf "\033[1;30m" ;}
color::bred() { printf "\033[1;31m" ;}
color::bgreen() { printf "\033[1;32m" ;}
color::byellow() { printf "\033[1;33m" ;}
color::bblue() { printf "\033[1;34m" ;}
color::bpurple() { printf "\033[1;35m" ;}
color::bcyan() { printf "\033[1;36m" ;}
color::bwhite() { printf "\033[1;37m" ;}
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
	[[ $# = 0 || $# -gt 1 ]] && return 1
	head -c $1 /dev/random
}
crypto::num() {
	[[ $# = 0 || $# -gt 1 ]] && return 1
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
	exec 200<"$0" || return 2
	flock -n 200 || return 66
	return 0
}
lock::free() {
	exec 200<&-
}
log::dot() { printf "\033[1;37m[ \033[0m....\033[1;37m ]\033[0m %s\n" "$@" ;}
log::prog() { printf "\033[1;37m[ \033[0m....\033[1;37m ]\033[0m %s\r" "$@" ;}
log::tab() { printf "\033[0m         %s\n" "$@" ;}
log::ok() { printf "\033[1;32m[  OK  ]\033[0m %s\n" "$@" ;}
log::info() { printf "\033[1;37m[ INFO ]\033[0m %s\n" "$@" ;}
log::warn() { printf "\033[1;33m[ WARN ]\033[0m %s\n" "$@" ;}
log::fail() { printf "\033[1;31m[ FAIL ]\033[0m %s\n" "$@" ;}
log::danger() { printf "\033[1;31m[DANGER]\033[0m %s\n" "$@" ;}
panic() {
	local PANIC_EXIT_CODE="$?" TRACE_FUNC=("${BASH_LINENO[@]}") || exit 98
	POSIXLY_CORRECT= || exit 11
	\unset -f trap set return exit printf echo local unalias unset || exit 22
	\unalias -a || exit 33
	unset POSIXLY_CORRECT || exit 44
	printf "\033[0;m%s\n" "@@@@@@     panic    @@@@@@"
	local TRACE_CMD_NUM
	TRACE_CMD_NUM="${BASH_LINENO[0]}"
	local PANIC_CMD
	PANIC_CMD="$(sed -n "$TRACE_CMD_NUM p" $0)"
	printf "\033[1;95m%s\033[0m%s\n" "[bash] " "$BASH_VERSION"
	printf "\033[1;96m%s\033[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\033[1;97m%s\033[0m%s\n" "[file] " "${BASH_SOURCE[-1]}"
	printf "\033[1;91m%s\033[0m%s\n" "[code] " "$PANIC_EXIT_CODE"
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
		if [[ $TRACE_CMD_NUM = $ORIGINAL_LINE ]]; then
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
	while :; do read -s -r; done
	[[ $1 =~ ^[0-9]+$ ]] && exit $1 || exit 99
}
safety::bash() { [[ ${BASH_VERSINFO[0]} -ge 5 ]] ;}
safety::gnu_linux() { [[ $OSTYPE = linux-gnu* ]] ;}
___BEGIN___ERROR___TRACE___() {
	POSIXLY_CORRECT= || exit 8
	\unset -f trap set return exit printf echo unset local return read unalias mapfile || exit 9
	\unalias -a || exit 10
	unset POSIXLY_CORRECT || exit 11
	trap 'TRACE_CMD="$BASH_COMMAND" TRACE_FUNC="${BASH_LINENO[@]}" TRACE_CMD_NUM="$LINENO" TRACE_PIPE="${PIPESTATUS[@]}"; ___ENDOF___ERROR___TRACE___ || exit 100' ERR || exit 12
	unset -v TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_PIPE || exit 13
	set -E -e -o pipefail || exit 14
	return 0
}
___ENDOF___ERROR___TRACE___() {
	if [[ -z $TRACE_PIPE ]]; then
		POSIXLY_CORRECT= || exit 15
		\unset -f trap set return exit return || exit 16
		\unalias -a || exit 17
		unset POSIXLY_CORRECT || exit 18
		unset -v TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_PIPE || exit 19
		set +E +eo pipefail || exit 20
		trap - ERR || exit 21
		return 0
	fi
	printf "\033[1;91m%s\n" "========  BEGIN ERROR TRACE  ========"
	printf "\033[1;95m%s\033[0m%s\n" "[bash] " "$BASH_VERSION"
	printf "\033[1;96m%s\033[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\033[1;91m%s\033[0m%s\n" "[code] " "${TRACE_PIPE[@]}"
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
		if [[ $TRACE_CMD_NUM = $ORIGINAL_LINE ]]; then
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
	unset -v TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_PIPE || exit 22
	set +E +eo pipefail || exit 23
	trap - ERR || exit 24
	exit 99
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
