#!/usr/bin/env bash
#
# stdlib.sh - a standard library for Bash
#
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

#git <stdlib.sh/df0c198>
#nix <1657314974>
#hbc <7a8caa0>
#src <ask.sh>
#src <color.sh>
#src <const.sh>
#src <crypto.sh>
#src <date.sh>
#src <debug.sh>
#src <guard.sh>
#src <hash.sh>
#src <is.sh>
#src <lock.sh>
#src <log.sh>
#src <malloc.sh>
#src <panic.sh>
#src <safety.sh>
#src <trace.sh>

#-------------------------------------------------------------------------------- BEGIN SRC
ask::yes() {
	local STD_ASK_REPONSE || return 44
	read -r STD_ASK_REPONSE
	case $STD_ASK_REPONSE in
		""|y|Y|yes|Yes|YES) return 0 ;;
		*) return 2 ;;
	esac
}
ask::no() {
	local STD_ASK_RESPONSE || return 44
	read -r STD_ASK_RESPONSE
	case $STD_ASK_RESPONSE in
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
crypto::bytes() {
	[[ $# = 0 ]] && return 1
	head -c $1 /dev/random
}
crypto::num() {
	case $# in
		1) shuf -i 0-$1 -n 1; return;;
		2) shuf -i $1-$2 -n 1; return;;
		*) return 1;;
	esac
}
crypto::uuid() {
	local STD_CRYPTO_UUID || return 1
	mapfile STD_CRYPTO_UUID < /proc/sys/kernel/random/uuid
	printf "%s" ${STD_CRYPTO_UUID//$'\n'}
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
debug() {
	[[ $STD_DEBUG != true ]] && return 0
	trap 'STD_DEBUG_CMD="$BASH_COMMAND" STD_DEBUG_FUNC=(${BASH_LINENO[@]}) STD_DEBUG_CMD_NUM="$LINENO" STD_DEBUG_PIPE=(${PIPESTATUS[@]});debug::trap' DEBUG
}
debug::trap() {
	if [[ -z $STD_DEBUG_INIT ]]; then
		declare -g STD_DEBUG_INIT
		STD_DEBUG_INIT=${EPOCHREALTIME//./}
		printf "\r\e[2K\033[1;90m%s\033[1;93m%s\033[0m%s\033[1;93m%s" \
			"[debug 0.000000] " "[ \$_ ] " "${STD_DEBUG_CMD_NUM}: $STD_DEBUG_CMD " "-> "
		local f
		local i=1
		for f in ${STD_DEBUG_FUNC[@]-1}; do
			[[ $f = 0 ]] && break
			printf "\033[1;91m%s\033[1;92m%s" "${f}: " "${FUNCNAME[${i}]}() "
			((i++))
		done
		printf "\033[0m\n"
		return
	fi
	local STD_DEBUG_ADJUSTED STD_DEBUG_DOT
	STD_DEBUG_ADJUSTED=$((${EPOCHREALTIME//./}-STD_DEBUG_INIT))
	case ${#STD_DEBUG_ADJUSTED} in
		1) STD_DEBUG_ADJUSTED=00000${STD_DEBUG_ADJUSTED//$'\n'};;
		2) STD_DEBUG_ADJUSTED=0000${STD_DEBUG_ADJUSTED//$'\n'};;
		3) STD_DEBUG_ADJUSTED=000${STD_DEBUG_ADJUSTED//$'\n'};;
		4) STD_DEBUG_ADJUSTED=00${STD_DEBUG_ADJUSTED//$'\n'};;
		5) STD_DEBUG_ADJUSTED=0${STD_DEBUG_ADJUSTED//$'\n'};;
	esac
	STD_DEBUG_DOT=$((${#STD_DEBUG_ADJUSTED}-6))
	if [[ $STD_DEBUG_DOT -eq 0 ]]; then
		printf "\r\e[2K\033[1;90m%s\033[1;93m%s\033[0m%s\033[1;93m%s" \
			"[debug 0.${STD_DEBUG_ADJUSTED}] " "[ \$_ ] " "${STD_DEBUG_CMD_NUM}: $STD_DEBUG_CMD " "-> "
	else
		printf "\r\e[2K\033[1;90m%s\033[1;93m%s\033[0m%s\033[1;93m%s" \
			"[debug ${STD_DEBUG_ADJUSTED:0:${STD_DEBUG_DOT}}.${STD_DEBUG_ADJUSTED:${STD_DEBUG_DOT}}] " \
			"[ \$_ ] " "${STD_DEBUG_CMD_NUM}: $STD_DEBUG_CMD " "-> "
	fi
	local f
	local i=1
	for f in ${STD_DEBUG_FUNC[@]-1}; do
		[[ $f = 0 ]] && break
		printf "\033[1;91m%s\033[1;92m%s" "${f}: " "${FUNCNAME[${i}]}() "
		((i++))
	done
	printf "\033[0m\n"
}
guard() {
	local STD_GUARD_HASH STD_TMP_GUARD_HASH || return 11
	STD_GUARD_HASH=$(\
		mapfile -n $((BASH_LINENO-1)) STD_TMP_GUARD_HASH < "$0";
		mapfile -O $((BASH_LINENO-1)) -s $BASH_LINENO STD_TMP_GUARD_HASH < "$0";
		printf "%s" "${STD_TMP_GUARD_HASH[@]}" | sha1sum) || return 22
	if [[ ${STD_GUARD_HASH// */} != "$1" ]]; then
		printf "%s\n" "${STD_GUARD_HASH// */}"
		return 33
	fi
}
hash::md5() {
	set -o pipefail || return 11
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 22
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | md5sum) || return 33
			printf "%s\n" "${STD_HASH// *-*/}" || return 44
		done
		set +o pipefail && return 0 || return 55
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 66
		return 1
	fi
	while [[ $# != 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | md5sum) || return 77
		printf "%s\n" "${STD_HASH// *-*/}"
		shift
	done
	set +o pipefail && return 0 || return 88
}
hash::sha1() {
	set -o pipefail || return 11
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 22
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | sha1sum) || return 33
			printf "%s\n" "${STD_HASH// *-*/}" || return 44
		done
		set +o pipefail && return 0 || return 55
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 66
		return 1
	fi
	while [[ $# != 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | sha1sum) || return 77
		printf "%s\n" "${STD_HASH// *-*/}"
		shift
	done
	set +o pipefail && return 0 || return 88
}
hash::sha256() {
	set -o pipefail || return 11
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 22
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | sha256sum) || return 33
			printf "%s\n" "${STD_HASH// *-*/}" || return 44
		done
		set +o pipefail && return 0 || return 55
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 66
		return 1
	fi
	while [[ $# != 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | sha256sum) || return 77
		printf "%s\n" "${STD_HASH// *-*/}"
		shift
	done
	set +o pipefail && return 0 || return 88
}
hash::sha512() {
	set -o pipefail || return 11
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 22
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | sha512sum) || return 33
			printf "%s\n" "${STD_HASH// *-*/}" || return 44
		done
		set +o pipefail && return 0 || return 55
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 66
		return 1
	fi
	while [[ $# != 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | sha512sum) || return 77
		printf "%s\n" "${STD_HASH// *-*/}"
		shift
	done
	set +o pipefail && return 0 || return 88
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
	POSIXLY_CORRECT= || return 7
	\unset -f umask trap set return echo unset local return unalias mapfile command || return 8
	\unalias -a || return 9
	unset -v POSIXLY_CORRECT || return 10
	[[ $# = 0 ]] && return 11
	declare -g -A STD_LOCK_FILE || return 12
	set +f || return 13
	local i f || return 14
	for i in $@; do
		for f in /tmp/std_lock_${i}_*; do
			[[ -e "$f" ]] && return 15
		done
	done
	local STD_LOCK_UUID || return 22
	until [[ $# = 0 ]]; do
		debug
		mapfile STD_LOCK_UUID < /proc/sys/kernel/random/uuid || return 23
		STD_LOCK_UUID=${STD_LOCK_UUID[0]//$'\n'/}
		STD_LOCK_UUID=${STD_LOCK_UUID//-/}
		STD_LOCK_FILE[$1]="/tmp/std_lock_${1}_${STD_LOCK_UUID}" || return 33
		local STD_DEFAULT_UMASK
		STD_DEFAULT_UMASK=$(umask)
		umask 177
		echo > "${STD_LOCK_FILE[$1]}" || return 44
		umask $STD_DEFAULT_UMASK
		shift || return 45
	done
}
lock::free() {
	POSIXLY_CORRECT= || return 7
	\unset -f : unset return rm command || return 8
	\unalias -a || return 9
	unset -v POSIXLY_CORRECT || return 10
	[[ $# = 0 ]] && return 11
	until [[ $# = 0 ]]; do
		if [[ $1 = '@' ]]; then
			command rm "${STD_LOCK_FILE[@]}" || :
			unset -v STD_LOCK_FILE || :
			return 0
		else
			command rm "${STD_LOCK_FILE[${i}]}" || return 22
			unset -v STD_LOCK_FILE[$i] || return 23
		fi
		shift
	done
}
log::ok() {
	printf "\r\e[2K"
	printf "\r\033[1;32m[  OK  ]\033[0m %s\n" "$@"
}
log::info() {
	printf "\r\e[2K"
	printf "\r\033[1;37m[ INFO ]\033[0m %s\n" "$@"
}
log::warn() {
	printf "\r\e[2K"
	printf "\r\033[1;33m[ WARN ]\033[0m %s\n" "$@"
}
log::fail() {
	printf "\r\e[2K"
	printf "\r\033[1;31m[ FAIL ]\033[0m %s\n" "$@"
}
log::danger() {
	printf "\r\e[2K"
	printf "\r\033[1;31m[DANGER]\033[0m %s\n" "$@"
}
log::tab() {
	printf "\r\e[2K"
	printf "\r\033[0m         %s\n" "$@"
}
log::prog() {
	printf "\r\e[2K"
	printf "\r\033[1;37m[ \033[0m....\033[1;37m ]\033[0m %s " "$@"
}
log::debug() {
	[[ $STD_LOG_DEBUG != true ]] && return 0
	if [[ -z $STD_LOG_DEBUG_INIT ]]; then
		declare -g STD_LOG_DEBUG_INIT
		STD_LOG_DEBUG_INIT=${EPOCHREALTIME//./}
		printf "\r\e[2K\033[1;90m%s\033[0m%s" "[log::debug 0.000000] " "${BASH_LINENO}: $@ "
		if [[ $STD_LOG_DEBUG_VERBOSE = true ]]; then
			printf "\033[1;93m%s" "-> "
			local f i
			i=1
			for f in ${BASH_LINENO[@]}; do
				[[ $f = 0 ]] && break
				printf "\033[1;91m%s\033[1;92m%s" "${f}: " "${FUNCNAME[${i}]}() "
				((i++))
			done
		fi
		printf "\033[0m\n"
		return
	fi
	local STD_LOG_DEBUG_ADJUSTED STD_LOG_DEBUG_DOT
	STD_LOG_DEBUG_ADJUSTED=$((${EPOCHREALTIME//./}-STD_LOG_DEBUG_INIT))
	case ${#STD_LOG_DEBUG_ADJUSTED} in
		1) STD_LOG_DEBUG_ADJUSTED=00000${STD_LOG_DEBUG_ADJUSTED};;
		2) STD_LOG_DEBUG_ADJUSTED=0000${STD_LOG_DEBUG_ADJUSTED};;
		3) STD_LOG_DEBUG_ADJUSTED=000${STD_LOG_DEBUG_ADJUSTED};;
		4) STD_LOG_DEBUG_ADJUSTED=00${STD_LOG_DEBUG_ADJUSTED};;
		5) STD_LOG_DEBUG_ADJUSTED=0${STD_LOG_DEBUG_ADJUSTED};;
	esac
	STD_LOG_DEBUG_DOT=$((${#STD_LOG_DEBUG_ADJUSTED}-6))
	if [[ $STD_LOG_DEBUG_DOT -eq 0 ]]; then
		printf "\r\e[2K\033[1;90m%s\033[0m%s" "[log::debug 0.${STD_LOG_DEBUG_ADJUSTED}] " "${BASH_LINENO}: $@ "
	else
		printf "\r\e[2K\033[1;90m%s\033[0m%s" \
			"[log::debug ${STD_LOG_DEBUG_ADJUSTED:0:${STD_LOG_DEBUG_DOT}}.${STD_LOG_DEBUG_ADJUSTED:${STD_LOG_DEBUG_DOT}}] " "${BASH_LINENO}: $@ "
	fi
	if [[ $STD_LOG_DEBUG_VERBOSE = true ]]; then
		printf "\033[1;93m%s" "-> "
		local f i
		i=1
		for f in ${BASH_LINENO[@]}; do
			[[ $f = 0 ]] && break
			printf "\033[1;91m%s\033[1;92m%s" "${f}: " "${FUNCNAME[${i}]}() "
			((i++))
		done
	fi
	printf "\033[0m\n"
}
malloc() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 33
		declare -g $i || return 44
	done
	return 0
}
malloc::arr() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 33
		declare -a $i || return 44
	done
	return 0
}
malloc::ass() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 33
		declare -A $i || return 44
	done
	return 0
}
malloc::int() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 33
		declare -i $i || return 44
	done
	return 0
}
free() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null || return 33
		unset -v $i || return 44
	done
	return 0
}
free::func() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in $@; do
		declare -F $i &>/dev/null || return 33
		unset -f $i || return 44
	done
	return 0
}
panic() {
	local STD_PANIC_CODE="$?" STD_TRACE_FUNC=("${BASH_LINENO[@]}") STD_TRACE_CMD_NUM=${BASH_LINENO[0]}|| exit 98
	POSIXLY_CORRECT= || exit 11
	\unset -f trap set return exit printf echo local unalias unset builtin kill || exit 22
	\unalias -a || exit 33
	unset POSIXLY_CORRECT || exit 44
	printf "\033[0;m%s\n" "@@@@@@@@  panic  @@@@@@@@"
	local STD_PANIC_CMD
	mapfile -s $((STD_TRACE_CMD_NUM-1)) -n 1 STD_PANIC_CMD < $0
	printf "\033[1;95m%s\033[0m%s\n" "[bash] " "$BASH_VERSION"
	printf "\033[1;96m%s\033[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\033[1;97m%s\033[0m%s\n" "[file] " "${BASH_SOURCE[-1]}"
	printf "\033[1;91m%s\033[0m%s\n" "[code] " "$STD_PANIC_CODE"
	printf "\033[1;94m%s\033[0m%s\n" "[ wd ] " "$PWD"
	printf "\033[1;93m%s\033[0m%s" "[ \$_ ] " "$STD_TRACE_CMD_NUM: ${STD_PANIC_CMD//$'\t'/}"
	local f
	local i=1
	STD_TRACE_FUNC=("${STD_TRACE_FUNC[@]:1}")
	for f in ${STD_TRACE_FUNC[@]}; do
		[[ $f = 0 ]] && break
		printf "\033[1;92m%s\033[0m%s\n" "[func] " "${f}: ${FUNCNAME[${i}]}()"
		((i++))
	done
	local STD_TRACE_LINE_ARRAY
	local STD_ORIGINAL_LINE="$STD_TRACE_CMD_NUM"
	if [[ $STD_TRACE_CMD_NUM -lt 5 ]]; then
		local STD_TRACE_CMD_NUM=1
		mapfile -n 9 STD_TRACE_LINE_ARRAY < $0
	else
		local STD_TRACE_CMD_NUM=$((STD_TRACE_CMD_NUM-4))
		mapfile -s $((STD_TRACE_CMD_NUM-1)) -n 9 STD_TRACE_LINE_ARRAY < $0
	fi
	for i in {0..8}; do
		[[ ${STD_TRACE_LINE_ARRAY[$i]} ]] || break
		if [[ $STD_TRACE_CMD_NUM = "$STD_ORIGINAL_LINE" ]]; then
			case ${#STD_TRACE_CMD_NUM} in
				1) printf "\033[1;97m%s" "     $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				2) printf "\033[1;97m%s" "    $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				3) printf "\033[1;97m%s" "   $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				4) printf "\033[1;97m%s" "  $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				5) printf "\033[1;97m%s" " $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				*) printf "\033[1;97m%s" "$STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
			esac
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
	while :; do read -s -r; done
	printf "\033[0;m%s\n" "@ loop fail, killing \$$ @"
	builtin kill $$
	[[ $1 =~ ^[0-9]+$ ]] && exit $1 || exit 99
}
safety::builtin() {
	POSIXLY_CORRECT= || exit 11
	\unset -f $@ || exit 22
	\unalias -a || exit 33
	unset POSIXLY_CORRECT || exit 44
}
safety::bash() { [[ ${BASH_VERSINFO[0]} -ge 5 ]] ;}
safety::gnu_linux() { [[ $OSTYPE = linux-gnu* ]] ;}
___BEGIN___ERROR___TRACE___() {
	POSIXLY_CORRECT= || exit 8
	\unset -f : true false trap set return exit printf unset local return read unalias mapfile kill builtin wait || exit 9
	\unalias -a || exit 10
	unset -v POSIXLY_CORRECT || exit 11
	trap 'STD_TRACE_CMD="$BASH_COMMAND" STD_TRACE_FUNC=(${BASH_LINENO[@]}) STD_TRACE_CMD_NUM="$LINENO" STD_TRACE_PIPE=(${PIPESTATUS[@]}); ___ENDOF___ERROR___TRACE___ > /dev/tty || exit 100' ERR || exit 12
	unset -v STD_TRACE_CMD STD_TRACE_FUNC_NUM STD_TRACE_CMD_NUM STD_TRACE_PIPE || exit 13
	set -E -e -o pipefail || exit 14
	return 0
}
___ENDOF___ERROR___TRACE___() {
	POSIXLY_CORRECT= || exit 15
	\unset -f : true false trap set return exit printf unset local return read unalias mapfile kill builtin wait || exit 16
	\unalias -a || exit 17
	unset -v POSIXLY_CORRECT || exit 18
	if [[ -z $STD_TRACE_PIPE ]]; then
		POSIXLY_CORRECT= || exit 19
		\unset -f trap set return exit return || exit 20
		\unalias -a || exit 21
		unset POSIXLY_CORRECT || exit 22
		unset -v STD_TRACE_CMD STD_TRACE_FUNC_NUM STD_TRACE_CMD_NUM STD_TRACE_PIPE || exit 23
		set +E +eo pipefail || exit 24
		trap - ERR || exit 25
		return 0
	fi
	printf "\033[1;91m%s\n" "========  BEGIN ERROR TRACE  ========"
	printf "\033[1;95m%s\033[0m%s\n" "[bash] " "$BASH_VERSION"
	printf "\033[1;96m%s\033[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\033[1;91m%s" "[code] "
	for i in ${STD_TRACE_PIPE[@]}; do
		printf "\033[0m%s" "$i"
	done
	printf "\n\033[1;97m%s\033[0m%s\n" "[file] " "${BASH_SOURCE[-1]}"
	printf "\033[1;94m%s\033[0m%s\n" "[ wd ] " "$PWD"
	printf "\033[1;93m%s\033[0m%s\n" "[ \$_ ] " "${STD_TRACE_CMD_NUM}: $STD_TRACE_CMD"
	local f
	local i=1
	for f in ${STD_TRACE_FUNC[@]}; do
		[[ $f = 0 ]] && break
		printf "\033[1;92m%s\033[0m%s\n" "[func] " "${f}: ${FUNCNAME[${i}]}()"
		((i++))
	done
	local STD_TRACE_LINE_ARRAY
	local STD_ORIGINAL_LINE="$STD_TRACE_CMD_NUM"
	if [[ $STD_TRACE_CMD_NUM -lt 5 ]]; then
		local STD_TRACE_CMD_NUM=1
		mapfile -n 9 STD_TRACE_LINE_ARRAY < $0
	else
		local STD_TRACE_CMD_NUM=$((STD_TRACE_CMD_NUM-4))
		mapfile -s $((STD_TRACE_CMD_NUM-1)) -n 9 STD_TRACE_LINE_ARRAY < $0
	fi
	for i in {0..8}; do
		[[ ${STD_TRACE_LINE_ARRAY[$i]} ]] || break
	  local STD_TRACE_SPACING="    "
		if [[ $STD_TRACE_CMD_NUM = "$STD_ORIGINAL_LINE" ]]; then
			case ${#STD_TRACE_CMD_NUM} in
				1) printf "\033[1;97m%s" "     $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				2) printf "\033[1;97m%s" "    $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				3) printf "\033[1;97m%s" "   $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				4) printf "\033[1;97m%s" "  $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				5) printf "\033[1;97m%s" " $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				*) printf "\033[1;97m%s" "$STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
			esac
		else
			case ${#STD_TRACE_CMD_NUM} in
				1) printf "\033[1;90m%s" "     $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				2) printf "\033[1;90m%s" "    $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				3) printf "\033[1;90m%s" "   $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				4) printf "\033[1;90m%s" "  $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				5) printf "\033[1;90m%s" " $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				*) printf "\033[1;90m%s" "$STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
			esac
		fi
		((STD_TRACE_CMD_NUM++))
	done
	printf "\033[1;91m%s\033[0m\n" "========  ENDOF ERROR TRACE  ========"
	unset -v STD_TRACE_CMD STD_TRACE_FUNC_NUM STD_TRACE_CMD_NUM STD_TRACE_PIPE || exit 26
	set +E +eo pipefail || exit 27
	trap - ERR || exit 28
	if [[ $BASH_SUBSHELL != 0 ]]; then
		printf "\033[1;93m%s\033[0m\n" "========  SUB-SHELLS KILLED  ========"
		builtin kill -s KILL 0
	fi
	exit 99
	printf "\033[1;97m%s\033[0m\n" "=KILL/EXIT FAIL, BEGIN INFINITE LOOP="
	while :; do read -s -r; done
	while true; do read -s -r; done
	while true; do false; done
	while :; do :; done
}
