#git <stdlib/safety.sh/76f0927>
safety::bash() { [[ ${BASH_VERSINFO[0]} -ge 5 ]] ;}
safety::gnu_linux() { [[ $OSTYPE = linux-gnu* ]] ;}
