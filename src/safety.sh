#git <stdlib/safety.sh/83ca8ba>
# safety
# ------
# bash's biggest double-edged sword is that,
# by default, it allows you to do _anything_
# this is amazingly freeing as it doesn't
# hold your hand but at the same time, it can
# lead to insanely dangerous situations.
# important builtins and unix commands
# can be tampered by a malicious user,
# or more likely, by someone who unknowingly
# set off a ticking time-bomb by making a
# custom function that overrides one of
# these crucial keywords, for example:
# ******************************************
# trap() {
#	echo "haha now trap will never work"
# }
#
# set() {
#	echo "set -e doesn't work now"
# }
#
# exit() {
#	echo "trying to exit from disaster?"
#	echo "well you can't anymore"
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

safety::builtin() {
	POSIXLY_CORRECT= || exit 11
	\unset -f $@ || exit 22
	\unalias -a || exit 33
	unset POSIXLY_CORRECT || exit 44
}
safety::bash() { [[ ${BASH_VERSINFO[0]} -ge 5 ]] ;}
safety::gnu_linux() { [[ $OSTYPE = linux-gnu* ]] ;}
