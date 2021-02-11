####################################################################
# Generic Settings:
####################################################################
# Prompt 

local ret_status="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜[%?])%{$reset_color%}"
local prompt_time='[%D{%b %d, %Y %H:%M:%S}]'
local host_info='[%{%F{green}%}%n%{%F{yellow}%}@%{%F{green}%}%m%{%f%}]'


ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}∆%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}‼%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}►%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}≠%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%}?%{$reset_color%}"

ZSH_THEME_SVN_PROMPT_PREFIX="svn:("
ZSH_THEME_SVN_PROMPT_SUFFIX=")"

ZSH_THEME_SVN_PROMPT_CLEAN="%{$fg[green]%}✔%{$reset_color%}" 
ZSH_THEME_SVN_PROMPT_ADDITIONS="%{$fg[blue]%}✚%{$reset_color%}" 
ZSH_THEME_SVN_PROMPT_DELETIONS="%{$fg[red]%}✖%{$reset_color%}" 
ZSH_THEME_SVN_PROMPT_MODIFICATIONS="%{$fg[yellow]%}∆%{$reset_color%}" 
ZSH_THEME_SVN_PROMPT_REPLACEMENTS="%{$fg[blue]%}‼%{$reset_color%}" 
ZSH_THEME_SVN_PROMPT_UNTRACKED="%{$fg[cyan]%}?%{$reset_color%}" 
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%}'!'%{$reset_color%}" 


PROMPT='${ret_status} ${host_info} ${prompt_time} $(git_prompt_info) $(svn_prompt_info) %F{yellow}%~%{%f%}
%F{blue}%}$ %{%f%}'
## %{$(iterm2_prompt_mark)%}%{%F{blue}%}$ %{%f%}'


#RPROMPT='%{%F{green}%} rc: %? [%D{%b %d, %Y %T}]%}' # prompt for right side of screen
#RPROMPT=


# My personal settings:
PAGER='less'
TZ=America/New_York
HOSTNAME="`hostname`"
unsetopt ALL_EXPORT
