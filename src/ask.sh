#git <stdlib/ask.sh/e8cd1fa>
ask::yes() {
	local STD_ASK_REPONSE || return 44
	read -r STD_ASK_REPONSE
	case $STD_ASK_REPONSE in
		""|y|Y|yes|Yes|YES) return 0 ;;
		*) return 2 ;;
	esac
}

ask::no() {
	local STD_ASK_RESPONSE || return 44
	read -r STD_ASK_RESPONSE
	case $STD_ASK_RESPONSE in
		y|Y|yes|Yes|YES) return 2 ;;
		*) return 0 ;;
	esac
}

ask::sudo() {
	sudo -v
}
