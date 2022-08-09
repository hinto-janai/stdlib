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

#git <stdlib.sh/681ca4f>
#nix <1660008306>
#hbc <7f27eed>
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
#src <math.sh>
#src <panic.sh>
#src <readonly.sh>
#src <safety.sh>
#src <trace.sh>
#src <type.sh>

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
color::black()   { builtin printf "\e[0;30m"; }
color::red()     { builtin printf "\e[0;31m"; }
color::green()   { builtin printf "\e[0;32m"; }
color::yellow()  { builtin printf "\e[0;33m"; }
color::blue()    { builtin printf "\e[0;34m"; }
color::purple()  { builtin printf "\e[0;35m"; }
color::cyan()    { builtin printf "\e[0;36m"; }
color::white()   { builtin printf "\e[0;37m"; }
color::bblack()  { builtin printf "\e[1;90m"; }
color::bred()    { builtin printf "\e[1;91m"; }
color::bgreen()  { builtin printf "\e[1;92m"; }
color::byellow() { builtin printf "\e[1;93m"; }
color::bblue()   { builtin printf "\e[1;94m"; }
color::bpurple() { builtin printf "\e[1;95m"; }
color::bcyan()   { builtin printf "\e[1;96m"; }
color::bwhite()  { builtin printf "\e[1;97m"; }
color::iblack()  { builtin printf "\e[0;90m"; }
color::ired()    { builtin printf "\e[0;91m"; }
color::igreen()  { builtin printf "\e[0;92m"; }
color::iyellow() { builtin printf "\e[0;93m"; }
color::iblue()   { builtin printf "\e[0;94m"; }
color::ipurple() { builtin printf "\e[0;95m"; }
color::icyan()   { builtin printf "\e[0;96m"; }
color::iwhite()  { builtin printf "\e[0;97m"; }
color::bold()    { builtin printf "\e[1m"; }
color::italic()  { builtin printf "\e[3m"; }
color::off()     { builtin printf "\e[0m"; }
const::char() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p "$i" &>/dev/null || { STD_TRACE_RETURN="char not found: $i"; return 33; }
		declare -r -g "$i" || return 44
	done
	return 0
}
const::array() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p "$i" &>/dev/null || { STD_TRACE_RETURN="array not found: $i"; return 33; }
		declare -r -g -a "$i" || return 44
	done
	return 0
}
const::map() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p "$i" &>/dev/null || { STD_TRACE_RETURN="map not found: $i"; return 33; }
		declare -r -g -A "$i" || return 44
	done
	return 0
}
const::int() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		case "$i" in
			''|*[!0-9]*) { STD_TRACE_RETURN="not integer: $i"; return 33; } ;;
		esac
		declare -p "$i" &>/dev/null || { STD_TRACE_RETURN="integer not found: $i"; return 44; }
		declare -r -g -i "$i" || return 55
	done
	return 0
}
const::bool() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p "$i" &>/dev/null || { STD_TRACE_RETURN="bool not found: $i"; return 33; }
		declare -r -g "$i" || return 44
	done
}
const::ref() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p "$i" &>/dev/null || { STD_TRACE_RETURN="ref not found: $i"; return 33; }
		declare -r -g -n "$i" || return 44
	done
	return 0
}
crypto::bytes() {
	[[ $# = 0 ]] && return 1
	head -c $1 /dev/random
}
crypto::base64() {
	[[ $# = 0 ]] && return 1
	head -c $1 /dev/random | base64
}
crypto::base32() {
	[[ $# = 0 ]] && return 1
	head -c $1 /dev/random | base64
}
crypto::md5() {
	[[ $# = 0 ]] && return 1
	local STD_CRYPTO_HASH || return 2
	STD_CRYPTO_HASH=$(head -c $1 /dev/random | md5sum) || return 3
	printf "%s\n" "${STD_CRYPTO_HASH// */}"
}
crypto::sha1() {
	[[ $# = 0 ]] && return 1
	local STD_CRYPTO_HASH || return 2
	STD_CRYPTO_HASH=$(head -c $1 /dev/random | sha1sum) || return 3
	printf "%s\n" "${STD_CRYPTO_HASH// */}"
}
crypto::sha256() {
	[[ $# = 0 ]] && return 1
	local STD_CRYPTO_HASH || return 2
	STD_CRYPTO_HASH=$(head -c $1 /dev/random | sha256sum) || return 3
	printf "%s\n" "${STD_CRYPTO_HASH// */}"
}
crypto::sha512() {
	[[ $# = 0 ]] && return 1
	local STD_CRYPTO_HASH || return 2
	STD_CRYPTO_HASH=$(head -c $1 /dev/random | sha512sum) || return 3
	printf "%s\n" "${STD_CRYPTO_HASH// */}"
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
	mapfile STD_CRYPTO_UUID < /proc/sys/kernel/random/uuid || return 2
	printf "%s" "$STD_CRYPTO_UUID"
}
crypto::encrypt() {
	[[ $# != 2 ]] && return 1
	printf "%s\n" "$1" | gpg --batch --symmetric --armor --quiet --cipher-algo AES256 --passphrase "$2"
}
crypto::decrypt() {
	[[ $# != 2 ]] && return 1
	printf "%s\n" "$1" | gpg --batch --decrypt --quiet --passphrase "$2"
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
		STD_TRACE_RETURN="bad guard() hash, real: ${STD_GUARD_HASH// */}"
		return 33
	fi
}
hash::md5() {
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 11
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | md5sum) || return 22
			printf "%s\n" "${STD_HASH// *}" || return 33
		done
		return
	elif [[ $# = 0 ]]; then
		return 44
	fi
	until [[ $# = 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | md5sum) || return 55
		printf "%s\n" "${STD_HASH// *}"
		shift
	done
}
hash::sha1() {
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 11
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | sha1sum) || return 22
			printf "%s\n" "${STD_HASH// *}" || return 33
		done
		return
	elif [[ $# = 0 ]]; then
		return 44
	fi
	until [[ $# = 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | sha1sum) || return 55
		printf "%s\n" "${STD_HASH// *}"
		shift
	done
}
hash::sha256() {
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 11
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | sha256sum) || return 22
			printf "%s\n" "${STD_HASH// *}" || return 33
		done
		return
	elif [[ $# = 0 ]]; then
		return 44
	fi
	until [[ $# = 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | sha256sum) || return 55
		printf "%s\n" "${STD_HASH// *}"
		shift
	done
}
hash::sha512() {
	if [[ -p /dev/stdin ]]; then
		local i STD_HASH || return 11
		for i in $(</dev/stdin); do
			STD_HASH=$(printf "%s" "$i" | sha512sum) || return 22
			printf "%s\n" "${STD_HASH// *}" || return 33
		done
		return
	elif [[ $# = 0 ]]; then
		return 44
	fi
	until [[ $# = 0 ]]; do
		STD_HASH=$(printf "%s" "$i" | sha512sum) || return 55
		printf "%s\n" "${STD_HASH// *}"
		shift
	done
}
is::int() {
	if [[ -p /dev/stdin ]]; then
		local i || return 11
		for i in $(</dev/stdin); do
			[ $i -eq $i ] &>/dev/null || { STD_TRACE_RETURN="not integer: $i"; return 22; }
		done
		return 0
	fi
	[[ $# = 0 ]] && return 33
	local i || return 44
	for i in "$@"; do
		[ $i -eq $i ] &>/dev/null || { STD_TRACE_RETURN="not integer: $i"; return 55; }
	done
}
is::int_pos() {
	if [[ -p /dev/stdin ]]; then
		local i || return 11
		for i in $(</dev/stdin); do
			[ $i -gt -1 ] &>/dev/null || { STD_TRACE_RETURN="not pos int: $i"; return 22; }
			[ $i -eq $i ] &>/dev/null || { STD_TRACE_RETURN="not pos int: $i"; return 33; }
		done
		return 0
	fi
	[[ $# = 0 ]] && return 44
	local i || return 55
	for i in "$@"; do
		[ $i -gt -1 ] &>/dev/null || { STD_TRACE_RETURN="not pos int: $i"; return 66; }
		[ $i -eq $i ] &>/dev/null || { STD_TRACE_RETURN="not pos int: $i"; return 77; }
	done
}
is::int_neg() {
	if [[ -p /dev/stdin ]]; then
		local i || return 11
		for i in $(</dev/stdin); do
			[ $i -lt 0 ] &>/dev/null || { STD_TRACE_RETURN="not neg int: $i"; return 22; }
			[ $i -eq $i ] &>/dev/null || { STD_TRACE_RETURN="not neg int: $i"; return 33; }
		done
		return 0
	fi
	[[ $# = 0 ]] && return 44
	local i || return 55
	for i in "$@"; do
		[ $i -lt 0 ] &>/dev/null || { STD_TRACE_RETURN="not neg int: $i"; return 66; }
		[ $i -eq $i ] &>/dev/null || { STD_TRACE_RETURN="not neg int: $i"; return 77; }
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
	for i in "$@"; do
		for f in /tmp/std_lock_"$i"_*; do
			[[ -e "$f" ]] && { STD_TRACE_RETURN="lock file found: $f"; return 15; }
		done
	done
	local STD_LOCK_UUID || return 22
	until [[ $# = 0 ]]; do
		mapfile STD_LOCK_UUID < /proc/sys/kernel/random/uuid || return 23
		STD_LOCK_UUID[0]=${STD_LOCK_UUID[0]//$'\n'/}
		STD_LOCK_UUID[0]=${STD_LOCK_UUID//-/}
		STD_LOCK_FILE[$1]="/tmp/std_lock_${1}_${STD_LOCK_UUID[0]}" || return 33
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
	\unset -f true unset return rm command || return 8
	\unalias -a || return 9
	unset -v POSIXLY_CORRECT || return 10
	[[ $# = 0 ]] && return 11
	until [[ $# = 0 ]]; do
		if [[ $1 = '@' ]]; then
			command rm "${STD_LOCK_FILE[@]}" || true
			unset -v STD_LOCK_FILE || true
			return 0
		else
			command rm "${STD_LOCK_FILE[$1]}" || { STD_TRACE_RETURN="lock rm fail: ${STD_LOCK_FILE[$1]}"; return 22; }
			unset -v "STD_LOCK_FILE[$1]" || return 23
		fi
		shift
	done
}
log::ok() { printf "\r\e[2K\e[1;32m[  OK  ]\e[0m %s\n" "$@"; }
log::info() { printf "\r\e[2K\e[1;37m[ INFO ]\e[0m %s\n" "$@"; }
log::warn() { printf "\r\e[2K\e[1;33m[ WARN ]\e[0m %s\n" "$@"; }
log::fail() { printf "\r\e[2K\e[1;31m[ FAIL ]\e[0m %s\n" "$@"; }
log::danger() { printf "\r\e[2K\e[1;31m[DANGER]\e[0m %s\n" "$@"; }
log::tab() { printf "\r\e[2K\e[0m         %s\n" "$@"; }
log::prog() { printf "\r\e[2K\e[1;37m[ \e[0m....\e[1;37m ]\e[0m %s " "$@"; }
log::debug() {
	[[ $STD_LOG_DEBUG != true ]] && return 0
	if [[ $STD_LOG_DEBUG_LAST_FUNC != "${FUNCNAME[1]}" ]]; then
		declare -g STD_LOG_DEBUG_LAST_FUNC="${FUNCNAME[1]}"
		case "$STD_LOG_DEBUG_FUNC_COLOR" in
			"\e[1;91m") STD_LOG_DEBUG_FUNC_COLOR="\e[1;92m";;
			"\e[1;92m") STD_LOG_DEBUG_FUNC_COLOR="\e[1;93m";;
			"\e[1;93m") STD_LOG_DEBUG_FUNC_COLOR="\e[1;94m";;
			"\e[1;94m") STD_LOG_DEBUG_FUNC_COLOR="\e[1;95m";;
			"\e[1;95m") STD_LOG_DEBUG_FUNC_COLOR="\e[1;96m";;
			"\e[1;96m") STD_LOG_DEBUG_FUNC_COLOR="\e[1;97m";;
			*) STD_LOG_DEBUG_FUNC_COLOR="\e[1;91m";;
		esac
	fi
	if [[ -z $STD_LOG_DEBUG_INIT ]]; then
		declare -g STD_LOG_DEBUG_INIT
		STD_LOG_DEBUG_INIT=${EPOCHREALTIME//[!0-9]/}
		printf "\r\e[2K\e[1;90m%s${STD_LOG_DEBUG_FUNC_COLOR}%s\e[0m%s" "[log::debug 0.000000] " "${FUNCNAME[1]}() " "$* "
		if [[ $STD_LOG_DEBUG_VERBOSE = true ]]; then
			printf "\e[1;93m%s" "-> "
			local f i
			i=1
			for f in ${BASH_LINENO[@]}; do
				[[ $f = 0 ]] && break
				printf "\e[1;91m%s\e[1;92m%s" "${f}: " "${FUNCNAME[${i}]}() "
				((i++))
			done
		fi
		printf "\e[0m\n"
		return
	fi
	local STD_LOG_DEBUG_ADJUSTED STD_LOG_DEBUG_DOT
	STD_LOG_DEBUG_ADJUSTED=$((${EPOCHREALTIME//[!0-9]/}-STD_LOG_DEBUG_INIT))
	case ${#STD_LOG_DEBUG_ADJUSTED} in
		1) STD_LOG_DEBUG_ADJUSTED=00000${STD_LOG_DEBUG_ADJUSTED};;
		2) STD_LOG_DEBUG_ADJUSTED=0000${STD_LOG_DEBUG_ADJUSTED};;
		3) STD_LOG_DEBUG_ADJUSTED=000${STD_LOG_DEBUG_ADJUSTED};;
		4) STD_LOG_DEBUG_ADJUSTED=00${STD_LOG_DEBUG_ADJUSTED};;
		5) STD_LOG_DEBUG_ADJUSTED=0${STD_LOG_DEBUG_ADJUSTED};;
	esac
	STD_LOG_DEBUG_DOT=$((${#STD_LOG_DEBUG_ADJUSTED}-6))
	if [[ $STD_LOG_DEBUG_DOT -eq 0 ]]; then
		printf "\r\e[2K\e[1;90m%s${STD_LOG_DEBUG_FUNC_COLOR}%s\e[0m%s" "[log::debug 0.${STD_LOG_DEBUG_ADJUSTED}] " "${FUNCNAME[1]}() " "$* "
	else
		printf "\r\e[2K\e[1;90m%s${STD_LOG_DEBUG_FUNC_COLOR}%s\e[0m%s" \
			"[log::debug ${STD_LOG_DEBUG_ADJUSTED:0:${STD_LOG_DEBUG_DOT}}.${STD_LOG_DEBUG_ADJUSTED:${STD_LOG_DEBUG_DOT}}] " "${FUNCNAME[1]}() " "$* "
	fi
	if [[ $STD_LOG_DEBUG_VERBOSE = true ]]; then
		printf "\e[1;93m%s" "-> "
		local f i
		i=1
		for f in ${BASH_LINENO[@]}; do
			[[ $f = 0 ]] && break
			printf "\e[1;91m%s\e[1;92m%s" "${f}: " "${FUNCNAME[${i}]}() "
			((i++))
		done
	fi
	printf "\e[0m\n"
}
short::sum() {
	if [[ -p /dev/stdin ]]; then
		awk -M -v PREC=200 '{SUM+=$1}END{printf "%.3f\n", SUM }'
	else
		builtin echo "$1" | awk -M -v PREC=200 '{SUM+=$1}END{printf "%.3f\n", SUM }'
	fi
}
float::sum() {
	if [[ -p /dev/stdin ]]; then
		awk -M -v PREC=200 '{SUM+=$1}END{printf "%.7f\n", SUM }'
	else
		builtin echo "$1" | awk -M -v PREC=200 '{SUM+=$1}END{printf "%.7f\n", SUM }'
	fi
}
double::sum() {
	if [[ -p /dev/stdin ]]; then
		awk -M -v PREC=200 '{SUM+=$1}END{printf "%.15f\n", SUM }'
	else
		builtin echo "$1" | awk -M -v PREC=200 '{SUM+=$1}END{printf "%.15f\n", SUM }'
	fi
}
short::add() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.3f\n", $1 + $2 }'; }
float::add() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.7f\n", $1 + $2 }'; }
double::add() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.15f\n", $1 + $2 }'; }
short::sub() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.3f\n", $1 - $2 }'; }
float::sub() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.7f\n", $1 - $2 }'; }
double::sub() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.15f\n", $1 - $2 }'; }
short::mul() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.3f\n", $1 * $2 }'; }
float::mul() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.7f\n", $1 * $2 }'; }
double::mul() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.15f\n", $1 * $2 }'; }
short::div() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.3f\n", $1 / $2 }'; }
float::div() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.7f\n", $1 / $2 }'; }
double::div() { builtin echo "$1" "$2" | awk -M -v PREC=200 '{printf "%.15f\n", $1 / $2 }'; }
panic() {
	local STD_PANIC_CODE="$?" STD_TRACE_FUNC=("${BASH_LINENO[@]}") STD_TRACE_CMD_NUM=${BASH_LINENO[0]}|| exit 98
	POSIXLY_CORRECT= || exit 11
	\unset -f trap set return exit printf echo local unalias unset builtin kill || exit 22
	\unalias -a || exit 33
	unset POSIXLY_CORRECT || exit 44
	unset : || exit 55
	printf "\e[7m\e[0;m%s\e[0m\n" "@@@@@@@@  panic  @@@@@@@@"
	local STD_PANIC_CMD
	mapfile -s $((STD_TRACE_CMD_NUM-1)) -n 1 STD_PANIC_CMD < $0
	printf "\e[1;95m%s\e[0m%s\n" "[bash] " "$BASH_VERSION"
	printf "\e[1;96m%s\e[0m%s\n" "[unix] " "$EPOCHSECONDS"
	printf "\e[1;97m%s\e[0m%s\n" "[file] " "${BASH_SOURCE[-1]}"
	printf "\e[1;91m%s\e[0m%s\n" "[code] " "$STD_PANIC_CODE"
	printf "\e[1;94m%s\e[0m%s\n" "[ wd ] " "$PWD"
	printf "\e[1;93m%s\e[0m%s" "[ \$_ ] " "$STD_TRACE_CMD_NUM: ${STD_PANIC_CMD//$'\t'/}"
	local f
	local i=1
	STD_TRACE_FUNC=("${STD_TRACE_FUNC[@]:1}")
	for f in ${STD_TRACE_FUNC[@]}; do
		[[ $f = 0 ]] && break
		printf "\e[1;92m%s\e[0m%s\n" "[func] " "${f}: ${FUNCNAME[${i}]}()"
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
				1) printf "\e[1;97m%s" "     $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				2) printf "\e[1;97m%s" "    $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				3) printf "\e[1;97m%s" "   $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				4) printf "\e[1;97m%s" "  $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				5) printf "\e[1;97m%s" " $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				*) printf "\e[1;97m%s" "$STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
			esac
		else
			case ${#STD_TRACE_CMD_NUM} in
				1) printf "\e[1;90m%s" "     $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				2) printf "\e[1;90m%s" "    $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				3) printf "\e[1;90m%s" "   $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				4) printf "\e[1;90m%s" "  $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				5) printf "\e[1;90m%s" " $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
				*) printf "\e[1;90m%s" "$STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]}" ;;
			esac
		fi
		((STD_TRACE_CMD_NUM++))
	done
	printf "\e[0;m%s\n" "@@@@@@@@  panic  @@@@@@@@"
	while :; do read -s -r; done
	printf "\e[0;m%s\n" "@ loop fail, killing \$$ @"
	builtin kill -s KILL 0
	[[ $1 =~ ^[0-9]+$ ]] && exit $1 || exit 99
}
readonly BLACK="\e[0;30m"
readonly RED="\e[0;31m"
readonly GREEN="\e[0;32m"
readonly YELLOW="\e[0;33m"
readonly BLUE="\e[0;34m"
readonly PURPLE="\e[0;35m"
readonly CYAN="\e[0;36m"
readonly WHITE="\e[0;37m"
readonly BBLACK="\e[1;90m"
readonly BRED="\e[1;91m"
readonly BGREEN="\e[1;92m"
readonly BYELLOW="\e[1;93m"
readonly BBLUE="\e[1;94m"
readonly BPURPLE="\e[1;95m"
readonly BCYAN="\e[1;96m"
readonly BWHITE="\e[1;97m"
readonly UBLACK="\e[4;30m"
readonly URED="\e[4;31m"
readonly UGREEN="\e[4;32m"
readonly UYELLOW="\e[4;33m"
readonly UBLUE="\e[4;34m"
readonly UPURPLE="\e[4;35m"
readonly UCYAN="\e[4;36m"
readonly UWHITE="\e[4;37m"
readonly IBLACK="\e[0;90m"
readonly IRED="\e[0;91m"
readonly IGREEN="\e[0;92m"
readonly IYELLOW="\e[0;93m"
readonly IBLUE="\e[0;94m"
readonly IPURPLE="\e[0;95m"
readonly ICYAN="\e[0;96m"
readonly IWHITE="\e[0;97m"
readonly BOLD="\e[1m"
readonly ITALIC="\e[3m"
readonly OFF="\e[0m"
safety::builtin() {
	POSIXLY_CORRECT= || exit 11
	\unset -f "$@" || exit 22
	\unalias -a || exit 33
	unset POSIXLY_CORRECT || exit 44
}
safety::bash() {
	[[ ${BASH_VERSINFO[0]} -ge 5 ]] || { STD_TRACE_RETURN="bash not v5+: ${BASH_VERSINFO[0]}"; return 11; }
}
safety::gnu_linux() {
	[[ $OSTYPE = linux-gnu* ]] || { STD_TRACE_RETURN="os not gnu/linux: $OSTYPE"; return 11; }
}
___BEGIN___ERROR___TRACE___() {
	POSIXLY_CORRECT= || exit 8
	\unset -f true false trap set return exit printf unset local return read unalias mapfile kill builtin wait || exit 9
	\unalias -a || exit 10
	unset -v POSIXLY_CORRECT || exit 11
	unset -f : || exit 1
	trap 'STD_TRACE_CMD="$BASH_COMMAND" STD_TRACE_FUNC=(${BASH_LINENO[@]}) STD_TRACE_CMD_NUM="$LINENO" STD_TRACE_PIPE=(${PIPESTATUS[@]}); ___ENDOF___ERROR___TRACE___ > /dev/tty || exit 100' ERR || exit 12
	unset -v STD_TRACE_CMD STD_TRACE_FUNC_NUM STD_TRACE_CMD_NUM STD_TRACE_PIPE || exit 13
	set -E -e -o pipefail || exit 14
	return 0
}
___ENDOF___ERROR___TRACE___() {
	POSIXLY_CORRECT= || exit 15
	\unset -f true false trap set return exit printf unset local return read unalias mapfile kill builtin wait || exit 16
	\unalias -a || exit 17
	unset -v POSIXLY_CORRECT || exit 18
	unset -f : || exit 1
	if [[ -z $STD_TRACE_PIPE ]]; then
		unset -v STD_TRACE_CMD STD_TRACE_FUNC_NUM STD_TRACE_CMD_NUM STD_TRACE_PIPE || exit 23
		set +E +eo pipefail || exit 24
		trap - ERR || exit 25
		return 0
	fi
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
	local f
	local i=1
	for f in "${STD_TRACE_FUNC[@]}"; do
		[[ $f = 0 ]] && break
		printf "\e[1;92m%s\e[0m%s\n" "[func] " "${f}: ${FUNCNAME[${i}]}()"
		((i++))
	done
	local STD_TRACE_LINE_ARRAY
	local STD_ORIGINAL_LINE="$STD_TRACE_CMD_NUM"
	if [[ $STD_TRACE_CMD_NUM -lt 5 ]]; then
		local STD_TRACE_CMD_NUM=1
		mapfile -n 9 STD_TRACE_LINE_ARRAY < "$0"
	else
		local STD_TRACE_CMD_NUM=$((STD_TRACE_CMD_NUM-4))
		mapfile -s $((STD_TRACE_CMD_NUM-1)) -n 9 STD_TRACE_LINE_ARRAY < "$0"
	fi
	for i in {0..8}; do
		[[ ${STD_TRACE_LINE_ARRAY[$i]} ]] || break
	  local STD_TRACE_SPACING="    "
		if [[ $STD_TRACE_CMD_NUM = "$STD_ORIGINAL_LINE" ]]; then
			case ${#STD_TRACE_CMD_NUM} in
				1) printf "\e[1;97m%s" "     $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				2) printf "\e[1;97m%s" "    $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				3) printf "\e[1;97m%s" "   $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				4) printf "\e[1;97m%s" "  $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				5) printf "\e[1;97m%s" " $STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
				*) printf "\e[1;97m%s" "$STD_TRACE_CMD_NUM ${STD_TRACE_LINE_ARRAY[${i}]//$'\t'/${STD_TRACE_SPACING}}" ;;
			esac
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
	[[ $STD_TRACE_RETURN ]] && printf "\e[38;5;196m%s\e[0;1m%s\e[0m\n" "[STD_TRACE_RETURN]" " $STD_TRACE_RETURN"
	printf "\e[1;91m%s\e[0m\n" "========  ENDOF ERROR TRACE  ========"
	unset -v STD_TRACE_CMD STD_TRACE_FUNC_NUM STD_TRACE_CMD_NUM STD_TRACE_PIPE || exit 26
	set +E +eo pipefail || exit 27
	trap - ERR || exit 28
	if [[ $BASH_SUBSHELL != 0 ]]; then
		printf "\e[1;93m%s\e[0m\n" "======  SUB-SHELLS TERMINATED  ======"
	fi
	builtin kill -s TERM 0
	exit 99
	printf "\e[1;97m%s\e[0m\n" "=KILL/EXIT FAIL, BEGIN INFINITE LOOP="
	while :; do read -s -r; done
	while true; do read -s -r; done
	while true; do false; done
	while :; do :; done
}
char() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p ${i%=*} &>/dev/null && { STD_TRACE_RETURN="char already found: $i"; return 33; }
		declare -g "$i" || return 44
	done
	return 0
}
array() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		{ declare -p ${i%=*} &>/dev/null || [[ -v ${i%=*} ]]; } && { STD_TRACE_RETURN="array already found: $i"; return 33; }
		declare -g -a "$i" || return 44
	done
	return 0
}
map() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		{ declare -p ${i%=*} &>/dev/null || [[ -v ${i%=*} ]]; } && { STD_TRACE_RETURN="map already found: $i"; return 33; }
		declare -g -A "$i" || return 44
	done
	return 0
}
int() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		if [[ $i = *=* ]]; then
			case ${i/*=} in
				''|*[!0-9]*) { STD_TRACE_RETURN="not integer: $i"; return 33; } ;;
			esac
		fi
		declare -p ${i%=*} &>/dev/null && { STD_TRACE_RETURN="integer already found: $i"; return 44; }
		declare -g -i "$i" || return 55
	done
	return 0
}
bool() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p ${i%=*} &>/dev/null && { STD_TRACE_RETURN="bool already found: $i"; return 33; }
		case $i in
			*=true) declare -g ${i%=*}=true || return 44 ;;
			*=false) declare -g ${i%=*}=false || return 55 ;;
			*) return 66 ;;
		esac
	done
}
ref() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p ${i%=*} &>/dev/null && { STD_TRACE_RETURN="ref already found: $i"; return 33; }
		declare -g -n "$i" || return 44
	done
	return 0
}
free() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		{ declare -p ${i%=*} &>/dev/null || [[ -v ${i%=*} ]]; } || { STD_TRACE_RETURN="no var found: $i"; return 33; }
		unset -v "$i" || { STD_TRACE_RETURN="could not free: $i"; return 44; }
	done
	return 0
}
free::func() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -F "$i" &>/dev/null || { STD_TRACE_RETURN="no func found: $i"; return 33; }
		unset -f "$i" || { STD_TRACE_RETURN="could not free: $i"; return 44; }
	done
	return 0
}

#-------------------------------------------------------------------------------- BEGIN MAIN
# there's nothing in here, this is a library.
#-------------------------------------------------------------------------------- ENDOF MAIN
