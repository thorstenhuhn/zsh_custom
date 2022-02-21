# AVIT ZSH Theme

# local time, color coded by last return code
time="%(?.%{$bg[blue]%}.%{$bg[red]%})%{$fg[white]%} %D{%H:%M} %{$reset_color%} "

PROMPT='
${time}$(_aws_profile) $(_kubectl_context) $(_user_host)${_current_dir}$(_git_prompt_info)
%{$fg[$CARETCOLOR]%}▶%{$resetcolor%} '

PROMPT2='%{$fg[$CARETCOLOR]%}◀%{$reset_color%} '

RPROMPT='$(_vi_status)%{$(echotc UP 1)%}$(_git_time_since_commit) $(git_prompt_status)%{$reset_color%} %{$(echotc DO 1)%}'

local _current_dir="%{$fg_bold[blue]%}%~%{$reset_color%}"
local _hist_no="%{$fg[grey]%}%h%{$reset_color%}"

function _aws_profile() {
  if [[ "$AWS_PROFILE" == *"prod" ]]; then
		echo -n "%{$bg[red]%}"
	else
		echo -n "%{$bg[cyan]%}"
	fi
  echo "%{$fg[white]%} $AWS_PROFILE %{$reset_color%}"
}

function _kubectl_context() {
	context=$(kubectl config current-context)
	namespace=$(k config view --minify --output 'jsonpath={..namespace}')
  echo "%{$bg[yellow]%}%{$fg[black]%} $context:$namespace %{$reset_color%}"
}

function _current_dir() {
  local _max_pwd_length="65"
  if [[ $(echo -n $PWD | wc -c) -gt ${_max_pwd_length} ]]; then
    echo "%{$fg_bold[blue]%}%-2~ ... %3~%{$reset_color%}"
  else
    echo "%{$fg_bold[blue]%}%~%{$reset_color%}"
  fi
}

function _user_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$fg[cyan]%}$me%{$reset_color%}:"
  fi
}

function _vi_status() {
  if {echo $fpath | grep -q "plugins/vi-mode"}; then
    echo "$(vi_mode_prompt_info)"
  fi
}

function _ruby_version() {
  if {echo $fpath | grep -q "plugins/rvm"}; then
    echo "%{$fg[grey]%}$(rvm_prompt_info)%{$reset_color%}"
  elif {echo $fpath | grep -q "plugins/rbenv"}; then
    echo "%{$fg[grey]%}$(rbenv_prompt_info)%{$reset_color%}"
  fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function _git_time_since_commit() {
# Only proceed if there is actually a commit.
  if last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null); then
    now=$(date +%s)
    seconds_since_last_commit=$((now-last_commit))

    # Totals
    minutes=$((seconds_since_last_commit / 60))
    hours=$((seconds_since_last_commit/3600))

    # Sub-hours and sub-minutes
    days=$((seconds_since_last_commit / 86400))
    sub_hours=$((hours % 24))
    sub_minutes=$((minutes % 60))

    if [ $hours -ge 24 ]; then
      commit_age="${days}d"
    elif [ $minutes -gt 60 ]; then
      commit_age="${sub_hours}h${sub_minutes}m"
    else
      commit_age="${minutes}m"
    fi

    color=$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL
    echo "$color$commit_age%{$reset_color%}"
  fi
}

function _git_prompt_info()
{
  local _desc="$(git symbolic-ref HEAD 2>/dev/null)"
  local _status
  local _alert
  if [ -n "$_desc" ]; then
    # we have a branch
    _desc=${_desc##refs/heads/};

    # check if we defer from remote branch (assumes regular fetches!)
    set -- $(git rev-list --left-right --count @{u}...HEAD 2>/dev/null)
    local _behind="$1"
    local _ahead="$2"
    if [ -z "$_behind" ]; then
      # error, assuming missing upstream
      _status="↑NO"
      _alert=1
    else
      if [ "$_behind" -ne "0" ]; then
        _status="↓${_behind}"
        _alert=1
      fi
      if [ "$_ahead" -ne "0" ]; then
        test -n "${_status}" && _status="${_status} "
        _status="${_status}↑${_ahead}"
        _alert=1
      fi
    fi

  else
    # not a git directory or detached head
    # => try to get tag name
    _desc="$(git describe --tags HEAD 2>/dev/null)"
  fi

  # did we finally get any git information?
  if [ -n "$_desc" ]; then
    # check for modifications (hopefully fastest way)
    if [ "$(git status -suno 2>/dev/null)" ]; then
      # we have changes
      _desc="${_desc}∙"
      _alert=1
    fi

    # add behind/ahead status (reliable only if fetching regularly)
    local _prompt="${_desc}"
    if [ -n "$_status" ]; then
      _prompt="${_prompt} ${_status}"
    fi
    _prompt=" ($_prompt)"

    # use warning color if necessary
    if [ -n "$_alert" ]; then
      _prompt="%{$fg[yellow]%}$_prompt%{$reset_color%}"
    else
      _prompt="%{$fg[green]%}$_prompt%{$reset_color%}"
    fi
    echo -n $_prompt

  fi

}

if [[ $USER == "root" ]]; then
  CARETCOLOR="red"
else
  CARETCOLOR="white"
fi

MODE_INDICATOR="%{$fg_bold[yellow]%}❮%{$reset_color%}%{$fg[yellow]%}❮❮%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚑ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}▴ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}◒ "

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[white]%}"

# LS colors, made with https://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'
