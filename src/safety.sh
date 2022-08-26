# This file is part of stdlib.sh - a standard library for Bash
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

#git <stdlib/safety.sh/93731ac>

# safety()
# --------
# bash's biggest double-edged sword is that,
# by default, it allows you to do _anything_
# this is very freeing, but at the same time,
# it can lead to insanely dangerous situations.
# important builtins and unix commands
# can be tampered by a malicious user,
# or more likely, by someone who unknowingly
# set off a ticking time-bomb by making a
# custom function that overrides one of
# these crucial keywords, for example:
# ******************************************
# trap() {
#     echo "haha now trap will never work"
# }
#
# set() {
#     echo "set -e doesn't work now"
# }
#
# exit() {
#     echo "trying to exit from disaster?"
#     echo "well you can't anymore"
# }
# ******************************************
# the fact crucial bash builtins aren't
# read-only by default makes it very scary
# when you're writing scripts to be run in
# other people's environment. hbc makes sure
# the declarations of functions/variables that
# you include are 100% for sure defined and readonly,
# however you're still able to overwrite crucial
# things in the main().

# this function safely disarms any overwritten
# bash builtins, or exits on error.
safety::builtin() {
	POSIXLY_CORRECT= || exit 11
	\unset -f "$@" || exit 22
	\unalias -a || exit 33
	unset POSIXLY_CORRECT || exit 44
}

# check for bash v5+ (2018+)
safety::bash() {
	[[ ${BASH_VERSINFO[0]} -ge 5 ]] || { STD_TRACE_RETURN="bash not v5+: ${BASH_VERSINFO[0]}"; return 11; }
}

# check for GNU/Linux
safety::gnu_linux() {
	[[ $OSTYPE = linux-gnu* ]] || { STD_TRACE_RETURN="os not gnu/linux: $OSTYPE"; return 11; }
}
