#git <stdlib/safety.sh/cc3d85c>
safety::bash() { [[ ${BASH_VERSINFO[0]} -ge 5 ]] ;}
safety::gnu_linux() { [[ $OSTYPE = linux-gnu* ]] ;}
