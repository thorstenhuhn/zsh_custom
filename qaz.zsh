qaz-validate() {
	qaz generate $1 > /tmp/qaz.yml && cfn-lint /tmp/qaz.yml
}

qaz-preview() {
	stack=$1
	answer=
	qaz change create update -s $stack && qaz change desc update -s $stack && vared -p "Apply changes? " answer
	case "$answer" in
		[Yy])
			qaz change execute update -s $stack
			;;
		*)
			echo "Aborting."
			qaz change rm update -s $stack
			;;
	esac
}

