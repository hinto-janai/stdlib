#!/usr/bin/env bash
#git <stdlib.sh/e3af68e>
#nix <1656472051>
#hbc <91d2b52>
#src <ask.sh>
#src <color.sh>
#src <crypto.sh>
#src <date.sh>
#src <hash.sh>
#src <log.sh>
#src <panic.sh>
#src <trace.sh>
#src <var.sh>

#-------------------------------------------------------------------------------- BEGIN SRC CODE
ask::yes(){
	local ASK_FUNC_RESPONSE || return 44
	read -r ASK_FUNC_RESPONSE
	case $ASK_FUNC_RESPONSE in
		""|y|Y|yes|Yes|YES) return 0 ;;
		*) return 2 ;;
	esac
}
ask::no(){
	local ASK_FUNC_RESPONSE || return 44
	read -r ASK_FUNC_RESPONSE
	case $ASK_FUNC_RESPONSE in
		y|Y|yes|Yes|YES) return 2 ;;
		*) return 0 ;;
	esac
}
ask::sudo(){
	sudo -v
	return
}
color::black(){ printf "\033[0;30m" ;}
color::red(){ printf "\033[0;31m" ;}
color::green(){ printf "\033[0;32m" ;}
color::yellow(){ printf "\033[0;33m" ;}
color::blue(){ printf "\033[0;34m" ;}
color::purple(){ printf "\033[0;35m" ;}
color::cyan(){ printf "\033[0;36m" ;}
color::white(){ printf "\033[0;37m" ;}
color::bblack(){ printf "\033[1;30m" ;}
color::bred(){ printf "\033[1;31m" ;}
color::bgreen(){ printf "\033[1;32m" ;}
color::byellow(){ printf "\033[1;33m" ;}
color::bblue(){ printf "\033[1;34m" ;}
color::bpurple(){ printf "\033[1;35m" ;}
color::bcyan(){ printf "\033[1;36m" ;}
color::bwhite(){ printf "\033[1;37m" ;}
color::iblack(){ printf "\033[0;90m" ;}
color::ired(){ printf "\033[0;91m" ;}
color::igreen(){ printf "\033[0;92m" ;}
color::iyellow(){ printf "\033[0;93m" ;}
color::iblue(){ printf "\033[0;94m" ;}
color::ipurple(){ printf "\033[0;95m" ;}
color::icyan(){ printf "\033[0;96m" ;}
color::iwhite(){ printf "\033[0;97m" ;}
color::off(){ printf "\033[0m" ;}
crypto::bytes(){
	[[ $# = 0 || $# -gt 1 ]] && return 1
	head -c $1 /dev/random
}
crypto::num(){
	[[ $# = 0 || $# -gt 1 ]] && return 1
	shuf -i 0-$1 -n 1
}
date::unix::translate(){
	if [[ -p /dev/stdin ]]; then
		local i || return 44
		for i in $(</dev/stdin); do
			date -d @"$i" || return 2
		done
		return 0
	elif [[ $# = 0 ]]; then
		return 1
	fi
	while [[ $# != 0 ]]; do
		date -d @"$1" || return 2
		shift
	done
	return 0
}
date::unix(){ printf "%s\n" "$EPOCHSECONDS" ;}
date::time(){ date +"%T" ;}
date::calendar(){ date +"%Y-%m-%d" ;}
date::now(){ date +"%Y-%m-%d %T" ;}
date::year(){ date +"%Y" ;}
date::month(){ date +"%m" ;}
date::day(){ date +"%d" ;}
date::hour(){ date +"%H" ;}
date::minute(){ date +"%M" ;}
date::second(){ date +"%S" ;}
hash::md5(){
	set -o pipefail || return 44
	if [[ -p /dev/stdin ]]; then
		local i || return 44
		for i in $(</dev/stdin); do
			printf "%s" "$i" | md5sum | tr -d ' -' || return 2
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 44
		return 1
	fi
	while [[ $# != 0 ]]; do
		printf "%s" "$1" | md5sum | tr -d ' -' || return 2
		shift
	done
	set +o pipefail && return 0 || return 44
}
hash::sha1(){
	set -o pipefail || return 44
	if [[ -p /dev/stdin ]]; then
		local i || return 44
		for i in $(</dev/stdin); do
			printf "%s" "$i" | sha1sum | tr -d ' -' || return 2
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 44
		return 1
	fi
	while [[ $# != 0 ]]; do
		printf "%s" "$1" | sha1sum | tr -d ' -' || return 2
		shift
	done
	set +o pipefail && return 0 || return 44
}
hash::sha256(){
	set -o pipefail || return 44
	if [[ -p /dev/stdin ]]; then
		local i || return 44
		for i in $(</dev/stdin); do
			printf "%s" "$i" | sha256sum | tr -d ' -' || return 2
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 44
		return 1
	fi
	while [[ $# != 0 ]]; do
		printf "%s" "$1" | sha256sum | tr -d ' -' || return 2
		shift
	done
	set +o pipefail && return 0 || return 44
}
hash::sha512(){
	set -o pipefail || return 44
	if [[ -p /dev/stdin ]]; then
		local i || return 44
		for i in $(</dev/stdin); do
			printf "%s" "$i" | sha512sum | tr -d ' -' || return 2
		done
		set +o pipefail && return 0 || return 44
	elif [[ $# = 0 ]]; then
		set +o pipefail || return 44
		return 1
	fi
	while [[ $# != 0 ]]; do
		printf "%s" "$1" | sha512sum | tr -d ' -' || return 2
		shift
	done
	set +o pipefail && return 0 || return 44
}
log::dot(){ printf "\033[1;37m[ \033[0m....\033[1;37m ]\033[0m %s\r" "$@" ;}
log::prog(){ printf "\033[1;37m[ \033[0m....\033[1;37m ]\033[0m %s\n" "$@" ;}
log::tab(){ printf "\033[0m         %s\n" "$@" ;}
log::ok(){ printf "\033[1;32m[  OK  ]\033[0m %s\n" "$@" ;}
log::info(){ printf "\033[1;37m[ INFO ]\033[0m %s\n" "$@" ;}
log::warn(){ printf "\033[1;33m[ WARN ]\033[0m %s\n" "$@" ;}
log::fail(){ printf "\033[1;31m[ FAIL ]\033[0m %s\n" "$@" ;}
log::danger(){ printf "\033[1;31m[DANGER]\033[0m %s\n" "$@" ;}
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
___BEGIN___ERROR___TRACE___(){
	trap 'TRACE_CMD="$BASH_COMMAND" TRACE_FUNC="$BASH_LINENO" TRACE_CMD_NUM="$LINENO" TRACE_CODE="$?" TRACE_PIPE="${PIPESTATUS[@]}"; ___ENDOF___ERROR___TRACE___ || exit 100' ERR || exit 11
	unset TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_CODE TRACE_PIPE || exit 22
	set -e -o pipefail || exit 33
	return 0
}
___ENDOF___ERROR___TRACE___(){
	if [[ -z $TRACE_CODE ]]; then
		set +e +o pipefail || exit 44
		trap - ERR || exit 55
		return 0
	fi
	printf "\033[1;91m%s\n" "========  BEGIN ERROR TRACE  ========"
	printf "\033[1;34m%s\033[0m%s\n" "[  \$_  ] " "${TRACE_CMD_NUM}: $TRACE_CMD"
	printf "\033[1;32m%s\033[0m%s\n" "[ func ] " "${TRACE_FUNC}: ${FUNCNAME[1]}()"
	printf "\033[1;37m%s\033[0m%s\n" "[ file ] " "${BASH_SOURCE[-1]}"
	printf "\033[1;31m%s\033[0m%s\n" "[ code ] " "$TRACE_CODE"
	printf "\033[1;35m%s\033[0m%s\n" "[ pipe ] " "${TRACE_PIPE[@]}"
	printf "\033[1;92m%s\033[0m%s\n" "[ bash ] " "$BASH_VERSION"
	printf "\033[1;96m%s\033[0m%s\n" "[ unix ] " "$EPOCHSECONDS"
	printf "\033[1;93m%s\033[0m%s\n" "[  wd  ] " "$PWD"
	printf "\033[1;91m%s\n" "========  ENDOF ERROR TRACE  ========"
	unset TRACE_CMD TRACE_FUNC_NUM TRACE_CMD_NUM TRACE_CODE TRACE_PIPE || exit 66
	set +e +o pipefail || exit 77
	trap - EXIT || exit 88
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
readonly BBLACK="\033[1;30m"
readonly BRED="\033[1;31m"
readonly BGREEN="\033[1;32m"
readonly BYELLOW="\033[1;33m"
readonly BBLUE="\033[1;34m"
readonly BPURPLE="\033[1;35m"
readonly BCYAN="\033[1;36m"
readonly BWHITE="\033[1;37m"
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

#-------------------------------------------------------------------------------- BEGIN MAIN SCRIPT
declare -fr ask::yes
declare -fr ask::no
declare -fr ask::sudo
declare -fr color::black
declare -fr color::red
declare -fr color::green
declare -fr color::yellow
declare -fr color::blue
declare -fr color::purple
declare -fr color::cyan
declare -fr color::white
declare -fr color::bblack
declare -fr color::bred
declare -fr color::bgreen
declare -fr color::byellow
declare -fr color::bblue
declare -fr color::bpurple
declare -fr color::bcyan
declare -fr color::bwhite
declare -fr color::iblack
declare -fr color::ired
declare -fr color::igreen
declare -fr color::iyellow
declare -fr color::iblue
declare -fr color::ipurple
declare -fr color::icyan
declare -fr color::iwhite
declare -fr color::off
declare -fr crypto::bytes
declare -fr crypto::num
declare -fr date::unix::translate
declare -fr date::unix
declare -fr date::time
declare -fr date::calendar
declare -fr date::now
declare -fr date::year
declare -fr date::month
declare -fr date::day
declare -fr date::hour
declare -fr date::minute
declare -fr date::second
declare -fr hash::md5
declare -fr hash::sha1
declare -fr hash::sha256
declare -fr hash::sha512
declare -fr log::dot
declare -fr log::prog
declare -fr log::tab
declare -fr log::ok
declare -fr log::info
declare -fr log::warn
declare -fr log::fail
declare -fr log::danger
declare -fr panic
declare -fr ___BEGIN___ERROR___TRACE___
declare -fr ___ENDOF___ERROR___TRACE___
#-------------------------------------------------------------------------------- ENDOF MAIN SCRIPT
