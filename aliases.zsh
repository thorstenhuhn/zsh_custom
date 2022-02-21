#cd() { builtin cd "$@"; ls -l; }           # always list directory contents upon 'cd'
mcd () { mkdir -p "$1" && cd "$1"; }        # make new directory and jump inside
#ql () { qlmanage -p "$*" >& /dev/null; }    # quicklook preview
aws-decode-message() { aws sts decode-authorization-message --encoded-message "$@" --output text; }

alias cd..='cd ../'                         # common typo
alias lb='open -a Launchbar $@'             # launchbar instand send
alias less='less -FSRXc'                    # preferred 'less' implementation
alias ll='ls -l'                            # list long
alias mkdir='mkdir -pv'                     # preferred 'mkdir' implementation
alias mpshow='security cms -D -i'           # show content of provisioning profile
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias vi='/usr/local/bin/vim'
alias sed='/usr/local/bin/gsed'

alias cai='cloudaccess p -a dbv3-iat'
alias cap='cloudaccess p -a dbv3-prod'

alias buchung='cd ~/Dropbox/Entwicklung/AWS/dbv-lift-shift/dbv3/bahndirekt/cloudformation/buchung/'
alias himpps='cd ~/Dropbox/Entwicklung/AWS/dbv-lift-shift/dbv3/himpps/cloudformation'
alias infra='cd ~/Dropbox/Entwicklung/AWS/dbv-lift-shift/dbv3/infra/'

alias cat='bat --paging=never'
alias catp='bat --paging=never --style=plain'

alias ci='checkin'
alias co='checkout'

alias kgn='kubectl get nodes --output=custom-columns="NAME":".metadata.name","STATUS":".status.conditions[?(@.status==\"True\")].type","ROLE":".metadata.labels.node\.kubernetes\.io/role"'
alias images='kubectl get pods --output=custom-columns="NAME":".metadata.name","IMAGES":".spec.containers[*].image"'
alias cm='f() { k get cm $1 -o jsonpath={".data"} | jq };f'
alias pods='k get pods --output jsonpath="{range .items[*]}{@.metadata.name} {end}"'
alias cusers='for pod in `k get pods --output jsonpath="{range .items[*]}{@.metadata.name} {end}"`; do echo -n "$pod " && k exec -it $pod -- id; done | column -t -s " "'

# warning: this overwrites alias from git plugin
alias gr='/usr/local/lib/node_modules//git-run/bin/gr'

switch-ansible() {
	ANSIBLE_VERSION=$1
	# remove existing ansible versions from PATH
	PATH=$(echo ${PATH} | awk -v RS=: -v ORS=: '/ansib/ {next} {print}' | sed 's/:*$//')
	export PATH=$PATH:~/.ansible/versions/${ANSIBLE_VERSION}/bin
}

# enable ansible default version
test -d ~/.ansible/versions/2.9 && switch-ansible 2.9
