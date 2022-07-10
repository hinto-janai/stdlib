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

#git <stdlib/lock.sh/db11450>

# lock::alloc() & lock::free()
# ----------------------------
# create a lock file. prevents
# multiple instances of a script
# or function taking place because
# a lock will be found by
# lock::alloc() and return error.
#
# THIS GLOBAL ARRAY HOLDS ALL LOCK PATHS:
#            $STD_LOCK_FILE
#
# 99% bash builtins.
# how is rm not a builtin yet?

# USAGE
# -----
# lock::alloc hello      <-- this makes an associative key-pair in the
#                            $STD_LOCK_FILE array. the key = your input,
#                            and the actual array value (and lock file name)
#                            will be: std_lock_hello_randomUUID
#                            ${STD_LOCK_FILE[hello]}'s value will look something like:
#                            std_lock_hello_5c11f6dda7e84e55a9fe1f6bc6ae612b
#                            which will be stored in /tmp/, as in /tmp/std_lock_hello_5c1...
#
# exit 0                 <-- INCORRECT USAGE
#                            ---------------
#                            in order to not override user programmed traps,
#                            lock::alloc, on purpose, does not include a
#                            auto-delete-on-exit trap by default. however,
#                            you can manually free the lock like so:
#
# lock::free hello       <-- the lock with key "hello" will now be unlocked,
#                            /tmp/std_lock_hello_5c1... will be deleted, and
#                            ${STD_LOCK_FILE[hello]} will be unset
#
# lock::alloc one two    <-- multiple locks can be made at the same time
#
# echo "doing stuff..."
# echo "ok we're good."
#
# lock::free one two     <-- and freed at the same time

# MAKING AUTO-DELETE TRAPS AND "lock::free @"
# -----------------------------------------
# $STD_LOCK_FILE is the global array that holds all
# the full paths to the locks created by lock::alloc().
# you can use "lock::free @" to cleanup ALL locks, and
# include it in a trap to auto-clean on a signal.
#
# EXAMPLES
# -------
# trap 'lock::free @' EXIT                        <-- this will delete ALL lock files on
#                                                     script exit. be aware that setting a
#                                                     trap overrides the previous one if set,
#                                                     which is why this is not on by default.
#
# trap 'lock::free sync' EXIT                     <-- this will only free the lock with the
#                                                     keyname "sync", on exit.
#
# trap 'other_thing; lock::free @' EXIT           <-- you can always chainlink commands/functions

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

	# the set below makes sure globbing is ENABLED for below
	set +f || return 13
	local i f || return 14
	for i in "$@"; do
		# the * below will NOT expand and become a literal '*'
		# instead of globbing ONLY IF there are no files found.
		# if files were found, the -e will confirm they already
		# exist, so we return error.
		for f in /tmp/std_lock_"$i"_*; do
			[[ -e "$f" ]] && { STD_TRACE_RETURN="lock file found: $f"; return 15; }
		done
	done

	# create lock
	local STD_LOCK_UUID || return 22
	until [[ $# = 0 ]]; do
		# create UUID
		mapfile STD_LOCK_UUID < /proc/sys/kernel/random/uuid || return 23
		STD_LOCK_UUID[0]=${STD_LOCK_UUID[0]//$'\n'/}
		STD_LOCK_UUID[0]=${STD_LOCK_UUID//-/}
		# create lock name and keypair
		STD_LOCK_FILE[$1]="/tmp/std_lock_${1}_${STD_LOCK_UUID[0]}" || return 33
		# create file in /tmp with 600 perms
		local STD_DEFAULT_UMASK
		STD_DEFAULT_UMASK=$(umask)
		umask 177
		echo > "${STD_LOCK_FILE[$1]}" || return 44
		umask $STD_DEFAULT_UMASK
		shift || return 45
	done
	# READ USAGE ABOVE IF YOU WANT TO USE THIS
	#trap 'lock::free @' EXIT || return 46
}

lock::free() {
	# ultra paranoid safety measures (unset bash builtins)
	POSIXLY_CORRECT= || return 7
	\unset -f : unset return rm command || return 8
	\unalias -a || return 9
	unset -v POSIXLY_CORRECT || return 10
	[[ $# = 0 ]] && return 11

	until [[ $# = 0 ]]; do
		# if input is '@', remove ALL AND UNSET
		# ALL LOCKS, regardless if they exist or not.
		# this will always return true.
		if [[ $1 = '@' ]]; then
			command rm "${STD_LOCK_FILE[@]}" || :
			unset -v STD_LOCK_FILE || :
			return 0
		else
			# free locks normally
			command rm "${STD_LOCK_FILE[$1]}" || { STD_TRACE_RETURN="lock rm fail: ${STD_LOCK_FILE[$1]}"; return 22; }
			unset -v "STD_LOCK_FILE[$1]" || return 23
		fi
		shift
	done
}
