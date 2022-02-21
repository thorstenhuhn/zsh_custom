export GOPATH=~/Entwicklung/go/golib:~/Entwicklung/go/work
gopath_list=(${(@s/:/)GOPATH})
for gopath in $gopath_list; do
	PATH=$PATH:$gopath/bin
done
