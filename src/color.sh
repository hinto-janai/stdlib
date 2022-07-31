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

#git <stdlib/color.sh/9a1b93f>

# color()
# -------
# set terminal text color.
# 100x-200x~ faster than tput,
# because printf is a builtin.
#
# EXAMPLE
# ---------------------------
# color::bred
# echo "this is bold red text"
# echo "and it will be until i"
# color::off
# echo "this has no color"
# ---------------------------
#
# to manually format color like:
# printf "${BRED}%s\n" "bold red text"
# use <stdlib/var.sh> instead.

# REGULAR
color::black()   { builtin printf "\e[0;30m"; }
color::red()     { builtin printf "\e[0;31m"; }
color::green()   { builtin printf "\e[0;32m"; }
color::yellow()  { builtin printf "\e[0;33m"; }
color::blue()    { builtin printf "\e[0;34m"; }
color::purple()  { builtin printf "\e[0;35m"; }
color::cyan()    { builtin printf "\e[0;36m"; }
color::white()   { builtin printf "\e[0;37m"; }
# BOLD
color::bblack()  { builtin printf "\e[1;90m"; }
color::bred()    { builtin printf "\e[1;91m"; }
color::bgreen()  { builtin printf "\e[1;92m"; }
color::byellow() { builtin printf "\e[1;93m"; }
color::bblue()   { builtin printf "\e[1;94m"; }
color::bpurple() { builtin printf "\e[1;95m"; }
color::bcyan()   { builtin printf "\e[1;96m"; }
color::bwhite()  { builtin printf "\e[1;97m"; }
# INTENSE
color::iblack()  { builtin printf "\e[0;90m"; }
color::ired()    { builtin printf "\e[0;91m"; }
color::igreen()  { builtin printf "\e[0;92m"; }
color::iyellow() { builtin printf "\e[0;93m"; }
color::iblue()   { builtin printf "\e[0;94m"; }
color::ipurple() { builtin printf "\e[0;95m"; }
color::icyan()   { builtin printf "\e[0;96m"; }
color::iwhite()  { builtin printf "\e[0;97m"; }
# STYLE
color::bold()    { builtin printf "\e[1m"; }
color::italic()  { builtin printf "\e[3m"; }
# OFF
color::off()     { builtin printf "\e[0m"; }
