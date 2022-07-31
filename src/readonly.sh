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

#git <stdlib/readonly.sh/9a1b93f>

# $readonly
# ---------
# common global variables set as readonly.

# COLORS
# usage: printf "${BLUE}%s\n" "blue text"
# REGULAR
readonly BLACK="\e[0;30m"
readonly RED="\e[0;31m"
readonly GREEN="\e[0;32m"
readonly YELLOW="\e[0;33m"
readonly BLUE="\e[0;34m"
readonly PURPLE="\e[0;35m"
readonly CYAN="\e[0;36m"
readonly WHITE="\e[0;37m"
# BOLD
readonly BBLACK="\e[1;90m"
readonly BRED="\e[1;91m"
readonly BGREEN="\e[1;92m"
readonly BYELLOW="\e[1;93m"
readonly BBLUE="\e[1;94m"
readonly BPURPLE="\e[1;95m"
readonly BCYAN="\e[1;96m"
readonly BWHITE="\e[1;97m"
# UNDERSCORE
readonly UBLACK="\e[4;30m"
readonly URED="\e[4;31m"
readonly UGREEN="\e[4;32m"
readonly UYELLOW="\e[4;33m"
readonly UBLUE="\e[4;34m"
readonly UPURPLE="\e[4;35m"
readonly UCYAN="\e[4;36m"
readonly UWHITE="\e[4;37m"
# HIGH INTENSITY
readonly IBLACK="\e[0;90m"
readonly IRED="\e[0;91m"
readonly IGREEN="\e[0;92m"
readonly IYELLOW="\e[0;93m"
readonly IBLUE="\e[0;94m"
readonly IPURPLE="\e[0;95m"
readonly ICYAN="\e[0;96m"
readonly IWHITE="\e[0;97m"
# STYLE
readonly BOLD="\e[1m"
readonly ITALIC="\e[3m"
# OFF
readonly OFF="\e[0m"
