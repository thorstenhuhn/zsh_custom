#cd() { builtin cd "$@"; ls -l; }           # always list directory contents upon 'cd'
mcd () { mkdir -p "$1" && cd "$1"; }        # make new directory and jump inside
ql () { qlmanage -p "$*" >& /dev/null; }    # quicklook preview
aws-decode-message() { aws --profile saml sts decode-authorization-message --encoded-message "$@" --output text; }

qaz-validate() {
	qaz generate $1 > /tmp/qaz.yml && cfn-lint /tmp/qaz.yml
}

qaz-preview() {
	stack=$1
	answer=n
	qaz change create update -s $stack && qaz change desc update -s $stack && read -p "Apply changes? " answer
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

alias cd..='cd ../'                         # common typo
alias ..='cd ../'                           # go back 1 directory level
alias ...='cd ../../'                       # go back 2 directory levels
alias .3='cd ../../../'                     # go back 3 directory levels
alias .4='cd ../../../../'                  # go back 4 directory levels

alias gs='git status'                       # git status (I don't use ghostview)
alias lb='open -a Launchbar $@'             # launchbar instand send
alias less='less -FSRXc'                    # preferred 'less' implementation
alias ll='ls -l'                            # list long
alias mkdir='mkdir -pv'                     # preferred 'mkdir' implementation
alias mpshow='security cms -D -i'           # show content of provisioning profile
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias vi='/usr/local/bin/vim'

