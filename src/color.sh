#git <stdlib/color.sh/e8cd1fa>
# REGULAR
color::black() { printf "\033[0;30m" ;}
color::red() { printf "\033[0;31m" ;}
color::green() { printf "\033[0;32m" ;}
color::yellow() { printf "\033[0;33m" ;}
color::blue() { printf "\033[0;34m" ;}
color::purple() { printf "\033[0;35m" ;}
color::cyan() { printf "\033[0;36m" ;}
color::white() { printf "\033[0;37m" ;}
# BOLD
color::bblack() { printf "\033[1;90m" ;}
color::bred() { printf "\033[1;91m" ;}
color::bgreen() { printf "\033[1;92m" ;}
color::byellow() { printf "\033[1;93m" ;}
color::bblue() { printf "\033[1;94m" ;}
color::bpurple() { printf "\033[1;95m" ;}
color::bcyan() { printf "\033[1;96m" ;}
color::bwhite() { printf "\033[1;97m" ;}
# INTENSE
color::iblack() { printf "\033[0;90m" ;}
color::ired() { printf "\033[0;91m" ;}
color::igreen() { printf "\033[0;92m" ;}
color::iyellow() { printf "\033[0;93m" ;}
color::iblue() { printf "\033[0;94m" ;}
color::ipurple() { printf "\033[0;95m" ;}
color::icyan() { printf "\033[0;96m" ;}
color::iwhite() { printf "\033[0;97m" ;}
# OFF
color::off() { printf "\033[0m" ;}
