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

#git <stdlib/lock.sh/524ddb2>

# lock()
# ------
# create a lock file. prevents
# multiple instances of a
# script/function taking place
# because a lock will be found
# by lock::alloc and return error.
#
# 99% bash builtin.
# how is rm not a builtin yet?

lock::alloc() {
	# remove lock on exit
	trap 'lock::free' EXIT || return 11
	# make lock file var global
	declare -g STD_LOCK_FILE || return 22
	# $1 = the locks name
	if [[ $1 ]]; then
		STD_LOCK_FILE="$1" || return 33
	else
		STD_LOCK_FILE="$0" || return 44
	fi
	# attach UUID to lock name
	local STD_LOCK_UUID || return 55
	mapfile -n 1 STD_LOCK_UUID < /proc/sys/kernel/random/uuid || return 66
	STD_LOCK_UUID=${STD_LOCK_UUID[0]//$'\n'/}
	STD_LOCK_UUID=${STD_LOCK_UUID//-/}
	STD_LOCK_FILE="${STD_LOCK_FILE}_${STD_LOCK_UUID}"
	# create file in /tmp with 600 perms
	local STD_DEFAULT_UMASK
	STD_DEFAULT_UMASK=$(umask)
	umask 177
	echo "" > /tmp/"$STD_LOCK_FILE" || return 77
	umask $STD_DEFAULT_UMASK
	return 0
}

lock::free() { command rm /tmp/"$STD_LOCK_FILE"; }
