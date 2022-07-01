#git <stdlib/color.sh/76f0927>
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
color::bblack() { printf "\033[1;30m" ;}
color::bred() { printf "\033[1;31m" ;}
color::bgreen() { printf "\033[1;32m" ;}
color::byellow() { printf "\033[1;33m" ;}
color::bblue() { printf "\033[1;34m" ;}
color::bpurple() { printf "\033[1;35m" ;}
color::bcyan() { printf "\033[1;36m" ;}
color::bwhite() { printf "\033[1;37m" ;}
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
