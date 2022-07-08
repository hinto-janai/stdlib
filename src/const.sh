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

#git <stdlib/const.sh/28d9c9b>

# $const
# ----
# common variables set as readonly.

# COLORS
# usage: printf "${BLUE}%s\n" "blue text"
# REGULAR
readonly BLACK="\033[0;30m"
readonly RED="\033[0;31m"
readonly GREEN="\033[0;32m"
readonly YELLOW="\033[0;33m"
readonly BLUE="\033[0;34m"
readonly PURPLE="\033[0;35m"
readonly CYAN="\033[0;36m"
readonly WHITE="\033[0;37m"
# BOLD
readonly BBLACK="\033[1;90m"
readonly BRED="\033[1;91m"
readonly BGREEN="\033[1;92m"
readonly BYELLOW="\033[1;93m"
readonly BBLUE="\033[1;94m"
readonly BPURPLE="\033[1;95m"
readonly BCYAN="\033[1;96m"
readonly BWHITE="\033[1;97m"
# UNDERSCORE
readonly UBLACK="\033[4;30m"
readonly URED="\033[4;31m"
readonly UGREEN="\033[4;32m"
readonly UYELLOW="\033[4;33m"
readonly UBLUE="\033[4;34m"
readonly UPURPLE="\033[4;35m"
readonly UCYAN="\033[4;36m"
readonly UWHITE="\033[4;37m"
# HIGH INTENSITY
readonly IBLACK="\033[0;90m"
readonly IRED="\033[0;91m"
readonly IGREEN="\033[0;92m"
readonly IYELLOW="\033[0;93m"
readonly IBLUE="\033[0;94m"
readonly IPURPLE="\033[0;95m"
readonly ICYAN="\033[0;96m"
readonly IWHITE="\033[0;97m"
# OFF
readonly OFF="\033[0m"
