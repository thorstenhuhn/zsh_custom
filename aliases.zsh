#cd() { builtin cd "$@"; ls -l; }           # always list directory contents upon 'cd'
mcd () { mkdir -p "$1" && cd "$1"; }        # make new directory and jump inside
#ql () { qlmanage -p "$*" >& /dev/null; }    # quicklook preview
aws-decode-message() { aws --profile saml sts decode-authorization-message --encoded-message "$@" --output text; }

alias cd..='cd ../'                         # common typo
alias lb='open -a Launchbar $@'             # launchbar instand send
alias less='less -FSRXc'                    # preferred 'less' implementation
alias ll='ls -l'                            # list long
alias mkdir='mkdir -pv'                     # preferred 'mkdir' implementation
alias mpshow='security cms -D -i'           # show content of provisioning profile
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias vi='/usr/local/bin/vim'
# this is dangerous when using virtualenv
#alias python='/usr/local/bin/python3'
#alias pip='/usr/local/bin/pip3'
alias sed='/usr/local/bin/gsed'

alias cai='cloudaccess p -a dbv3-iat'
alias cap='cloudaccess p -a dbv3-prod'

alias buchung='cd ~/Dropbox/Entwicklung/AWS/dbv-lift-shift/dbv3/bahndirekt/cloudformation/buchung/'
alias himpps='cd ~/Dropbox/Entwicklung/AWS/dbv-lift-shift/dbv3/himpps/cloudformation'
alias infra='cd ~/Dropbox/Entwicklung/AWS/dbv-lift-shift/dbv3/infra/'

switch-ansible() {
	ANSIBLE_VERSION=$1
	for file in `ls /var/ansible-${ANSIBLE_VERSION}/bin/ansible*`; do
		alias $(basename $file)="$file"
	done
}

switch-ansible 2.4

