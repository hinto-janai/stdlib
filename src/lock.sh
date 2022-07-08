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

#git <stdlib/lock.sh/47f56ea>

# lock()
# ------
# create a lock file. prevents
# multiple instances of a
# script/function taking place
# because a lock will be found
# by lock::alloc and return error.
#
# 99% bash builtins.
# how is rm not a builtin yet?

# USAGE
# -----
# lock::alloc hello      <-- this makes an associative key-pair in the
#                            $STD_LOCK_FILE array. the key = your input,
#                            and the actual array value (and lock file name)
#                            is your input + a random UUID from the kernel.
#                            ${STD_LOCK_FILE[hello]}'s value will look something like:
#                            hello_5c11f6dda7e84e55a9fe1f6bc6ae612b
#                            which will be stored in /tmp/, as in /tmp/hello_5c1...
#
# exit 0                 <-- lock::alloc sets a trap to remove the lock
#                            automatically on exit, or you can manually
#                            unlock a lock by doing:
#
# lock::free hello       <-- the lock with key "hello" will now be unlocked,
#                            /tmp/hello_5c1... will be deleted, and
#                            ${STD_LOCK_FILE[hello]} will be unset
#
# lock::alloc one two    <-- multiple locks can be made at the same time
#
# echo "doing stuff..."
# echo "we're good."
#
# lock::free one two     <-- and freed at the same time

lock::alloc() {
	# ultra paranoid safety measures (unset bash builtins)
	POSIXLY_CORRECT= || return 7
	\unset -f umask trap set return echo unset local return unalias mapfile command || return 8
	\unalias -a || return 9
	unset -v POSIXLY_CORRECT || return 10

	# no input, return error
	[[ $# = 0 ]] && return 11
	# make lock file var global
	declare -g -A STD_LOCK_FILE || return 12
	# lock already found, return error
	local i || return 13
	for i in $@; do
		[[ ${STD_LOCK_FILE[$i]} ]] && return 14
	done
	# remove lock on exit
	trap 'lock::free $@' EXIT || return 15

	# get lock UUID
	local STD_LOCK_UUID || return 22
	for i in $@; do
		mapfile STD_LOCK_UUID < /proc/sys/kernel/random/uuid || return 23
		STD_LOCK_UUID=${STD_LOCK_UUID[0]//$'\n'/}
		STD_LOCK_UUID=${STD_LOCK_UUID//-/}
		# locks name = i_UUID
		STD_LOCK_FILE[$i]="${i}_${STD_LOCK_UUID}" || return 33
		# create file in /tmp with 600 perms
		local STD_DEFAULT_UMASK
		STD_DEFAULT_UMASK=$(umask)
		umask 177
		echo "" > /tmp/"${STD_LOCK_FILE[$i]}" || return 44
		umask $STD_DEFAULT_UMASK
	done
	return 0
}

lock::free() {
	# ultra paranoid safety measures (unset bash builtins)
	POSIXLY_CORRECT= || return 7
	\unset -f unset return rm command || return 8
	\unalias -a || return 9
	unset -v POSIXLY_CORRECT || return 10
	[[ $# = 0 ]] && return 11

	# free lock
	local i || return 20
	for i in $@; do
		[[ ${STD_LOCK_FILE[$i]} ]] || return 21
		command rm /tmp/"${STD_LOCK_FILE[$i]}" || return 22
		unset -v "${STD_LOCK_FILE[$i]}" || return 23
	done
	return 0
}
