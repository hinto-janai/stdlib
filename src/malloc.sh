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

#git <stdlib/malloc.sh/1611706>

# a note on how Bash uses memory
# ------------------------------
# there is no "C free()" in Bash, there is only a "C malloc()".
# whenever you use memory in Bash, (like assigning value to a variable)
# the kernel will give that Bash process some memory.
# THERE IS NO WAY IN BASH TO FREE THIS ALLOCATED MEMORY DIRECTLY.
# AS LONG AS THE PROCESS IS ALIVE, THE MEMORY STAYS ALLOCATED!
# if you "unset $bigVar", that variable will exit the Bash
# scripts scope, however the Bash process itself will still
# continue to hog that memory. the only way to "free" memory
# is for the process to exit/die.
#
# sub_shells() ( <--------------- note the () instead of {}
#     are great workarounds to
#     temporarily working on
#     large variables as they,
#     like all programs, return
#     all memory on exit. subshells
#     in particular are great because
#     they inherit the environment
#     from the parent shell, but the
#     system treats it as a different
#     process.
# )
#
# var_in_main=$(this_operation_is_in_a_subshell!)


# malloc() && free()
# ------------------
# INITIALIZE global variables only if
# they are completely unset. ASSIGNING
# a value to variables with alloc() is
# possible, using: alloc VAR=value.
# Null-but-initialized variables count
# as already set variables, and will
# cause alloc() to return error:
# e.g. local VAR; alloc::var VAR
# free() will unset any variable,
# whether set by alloc() or not.

# regular variable
malloc::var() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 22
		declare -g $i || return 33
	done
	return 0
}

# indexed array
malloc::arr() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 22
		declare -a $i || return 33
	done
	return 0
}

# associative array (key-value pairs)
malloc::ass() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 22
		declare -A $i || return 33
	done
	return 0
}

# integer variable
malloc::int() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null && return 22
		declare -i $i || return 33
	done
	return 0
}

# frees all types of variables
free::var() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -p ${i/=*/} &>/dev/null || return 22
		unset -v $i || return 33
	done
	return 0
}

# free FUNCTIONS
free::func() {
	[[ $# = 0 ]] && return 11
	for i in $@; do
		declare -F $i &>/dev/null || return 22
		unset -f $i || return 33
	done
	return 0
}
