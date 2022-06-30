#git <stdlib/log.sh/d257147>
log::dot(){ printf "\033[1;37m[ \033[0m....\033[1;37m ]\033[0m %s\n" "$@" ;}
log::prog(){ printf "\033[1;37m[ \033[0m....\033[1;37m ]\033[0m %s\r" "$@" ;}
log::tab(){ printf "\033[0m         %s\n" "$@" ;}
log::ok(){ printf "\033[1;32m[  OK  ]\033[0m %s\n" "$@" ;}
log::info(){ printf "\033[1;37m[ INFO ]\033[0m %s\n" "$@" ;}
log::warn(){ printf "\033[1;33m[ WARN ]\033[0m %s\n" "$@" ;}
log::fail(){ printf "\033[1;31m[ FAIL ]\033[0m %s\n" "$@" ;}
log::danger(){ printf "\033[1;31m[DANGER]\033[0m %s\n" "$@" ;}
