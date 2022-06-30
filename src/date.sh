#git <stdlib/date.sh/413896f>
date::unix::translate(){
	if [[ -p /dev/stdin ]]; then
		local i || return 44
		for i in $(</dev/stdin); do
			date -d @"$i" || return 2
		done
		return 0
	elif [[ $# = 0 ]]; then
		return 1
	fi

	while [[ $# != 0 ]]; do
		date -d @"$1" || return 2
		shift
	done
	return 0
}
date::unix(){ printf "%s\n" "$EPOCHSECONDS" ;}
date::time(){ date +"%T" ;}
date::calendar(){ date +"%Y-%m-%d" ;}
date::now(){ date +"%Y-%m-%d %T" ;}
date::year(){ date +"%Y" ;}
date::month(){ date +"%m" ;}
date::day(){ date +"%d" ;}
date::hour(){ date +"%H" ;}
date::minute(){ date +"%M" ;}
date::second(){ date +"%S" ;}
