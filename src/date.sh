#git <stdlib/date.sh/e8cd1fa>
date::unix_translate() {
	# stdin
	if [[ -p /dev/stdin ]]; then
		local i || return 11
		for i in $(</dev/stdin); do
			date -d @"$i" || return 22
		done
		return 0
	fi
	# normal input
	[[ $# = 0 ]] && return 33
	while [[ $# != 0 ]]; do
		date -d @"$1" || return 44
		shift
	done
	return 0
}
date::unix() { printf "%s\n" "$EPOCHSECONDS" ;}
date::time() { date +"%T" ;}
date::calendar() { date +"%Y-%m-%d" ;}
date::now() { date +"%Y-%m-%d %T" ;}
date::year() { date +"%Y" ;}
date::month() { date +"%m" ;}
date::day() { date +"%d" ;}
date::hour() { date +"%H" ;}
date::minute() { date +"%M" ;}
date::second() { date +"%S" ;}
