#git <stdlib/ask.sh/cc3d85c>
ask::yes() {
	local ASK_FUNC_RESPONSE || return 44
	read -r ASK_FUNC_RESPONSE
	case $ASK_FUNC_RESPONSE in
		""|y|Y|yes|Yes|YES) return 0 ;;
		*) return 2 ;;
	esac
}

ask::no() {
	local ASK_FUNC_RESPONSE || return 44
	read -r ASK_FUNC_RESPONSE
	case $ASK_FUNC_RESPONSE in
		y|Y|yes|Yes|YES) return 2 ;;
		*) return 0 ;;
	esac
}

ask::sudo() {
	sudo -v
}
