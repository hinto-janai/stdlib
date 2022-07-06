#git <stdlib/guard.sh/cc3d85c>
# guard
# -----
# read $0 excluding the line where guard()
# was called and send it through sha1sum.
# return if $1 does not match the hash calculated.
#
# this is akin to doing "cat FILE | sha1sum"
# except guard() allows you to store the hash
# of the file you're calculating in the very
# file that it's in.
#
# to initially calculate a hash:
# sed '/^[[:blank:]]guard.*$/d' FILE
# then you can insert that hash like:
# guard c22b5f9178342609428d6f51b2c5af4c0bde6a42
#
# any modification above or below that guard()
# will trigger guard to return error.
guard() {
	local GUARD_HASH TMP_GUARD_HASH || return 11
	GUARD_HASH=$(\
		mapfile -n $((BASH_LINENO-1)) TMP_GUARD_HASH < "$0";
		mapfile -O $((BASH_LINENO-1)) -s $BASH_LINENO TMP_GUARD_HASH < "$0";
		printf "%s" "${TMP_GUARD_HASH[@]}" | sha1sum) || return 22
	if [[ ${GUARD_HASH// */} != "$1" ]]; then
		printf "%s\n" "${GUARD_HASH// */}"
		return 33
	fi
}
