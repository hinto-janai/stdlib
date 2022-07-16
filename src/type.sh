# This file is part of stdlib.sh - a standard library for Bash
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

#git <stdlib/type.sh/1eaba1f>

# ============================================== #
# type.sh & free()                               #
# ============================================== #
# these functions are for safely INITIALIZING    #
# GLOBAL declarations. they will return ERROR if #
# the declaration already exists, even if null.  #
# ---------------------------------------------- #
# EXAMPLE CODE                                   #
# ---------------------------------------------- #
# local VAR                                      #
# char VAR         <-- this will error           #
#                                                #
# local VAR                                      #
# bool VAR=true    <-- this will error           #
#                                                #
# int VAR=not_int  <-- this will error, not      #
#                      because it was already    #
#                      found, but because it's   #
#                      not an integer.           #
#                                                #
# FUNC() { echo hi; }                            #
#                                                #
# free VAR         <-- these will work,          #
# free::func FUNC      unsetting $VAR and FUNC() #
# ---------------------------------------------- #

# -----------------------------------------------#
# ASSIGNING a value to variables at the same     #
# time of declaration is possible, like so:      #
# ---------------------------------------------- #
# char VAR=value                                 #
# int VAR=44 NUM=45                              #
# array VAR[0]=hello VAR[1]=farewell             #
# map VAR[hi]=hello                              #
# ---------------------------------------------- #

# ---------------------------------------------- #
# free() will unset any variable, regardless     #
# of how it was declared in the first place.     #
# individual array elements can be freed like:   #
# ---------------------------------------------- #
# free VAR[0]  <-- this only unsets index #0     #
# free VAR     <-- this unsets all of ${VAR[@]}  #
#                                                #
# free::func FUNC  <-- this unsets a function    #
# ---------------------------------------------- #

# regular variable
char() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p ${i%=*} &>/dev/null && { STD_TRACE_RETURN="char already found: $i"; return 33; }
		declare -g "$i" || return 44
	done
	return 0
}

# indexed array
array() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		{ declare -p ${i%=*} &>/dev/null || [[ -v ${i%=*} ]]; } && { STD_TRACE_RETURN="array already found: $i"; return 33; }
		declare -g -a "$i" || return 44
	done
	return 0
}

# associative array (key-value pairs)
map() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		{ declare -p ${i%=*} &>/dev/null || [[ -v ${i%=*} ]]; } && { STD_TRACE_RETURN="map already found: $i"; return 33; }
		declare -g -A "$i" || return 44
	done
	return 0
}

# integer variable (positive)
int() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		# if assigning value, make
		# sure it's an integer
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

# turns input into true/false
# e.g. bool a=true b=asdf
# non-"?=true" input will always
# be assigned "false"
# no different from a regular string
# variable, mostly useful for readability.
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

# this is creates a reference
# variable, akin to a C pointer.
ref() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -p ${i%=*} &>/dev/null && { STD_TRACE_RETURN="ref already found: $i"; return 33; }
		declare -g -n "$i" || return 44
	done
	return 0
}

# frees all types of variables
# errors if input was not found
# as a variable. the [[ ]] is to
# catch arrays, as in: free a[0]
free() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		{ declare -p ${i%=*} &>/dev/null || [[ -v ${i%=*} ]]; } || { STD_TRACE_RETURN="no var found: $i"; return 33; }
		unset -v "$i" || { STD_TRACE_RETURN="could not free: $i"; return 44; }
	done
	return 0
}

# free FUNCTIONS.
# errors if input was not found
# as a function.
free::func() {
	[[ $# = 0 ]] && return 11
	local i || return 22
	for i in "$@"; do
		declare -F "$i" &>/dev/null || { STD_TRACE_RETURN="no func found: $i"; return 33; }
		unset -f "$i" || { STD_TRACE_RETURN="could not free: $i"; return 44; }
	done
	return 0
}
