# Please note that the below function is very greatly inspired by the precmd function from the jonathan oh-my-zsh theme.
function theme_precmd {
    local TERMWIDTH=$(( COLUMNS - ${ZLE_RPROMPT_INDENT:-1} ))

    PR_FILLBAR=""
    PR_PWDLEN=""

    local prompt_size=${#${:-()---()--}}
    local pwd_size=${#${(%):-%~}}

    # Truncating path if it is too long.
    if (( prompt_size + pwd_size > TERMWIDTH )); then
        (( PR_PWDLEN = TERMWIDTH - prompt_size ))
    elif [[ "${langinfo[CODESET]}" = UTF-8 ]]; then
        PR_FILLBAR="\${(l:$(( TERMWIDTH - (prompt_size + pwd_size) ))::${PR_HBAR}:)}"
    else
        PR_FILLBAR="${PR_SHIFT_IN}\${(1:$(( TERMWIDTH - (prompt_size + pwd_size) ))::${altchar[q]:--}:)}${PR_SHIFT_OUT}"
    fi
}

function theme_preexec {
    setopt local_options extended_glob
    if [[ "$TERM" = "screen" ]]; then
        local CMD=${1[(wr)^(*=*|sudo|-*)]}
        echo -n "\ek$CMD\e\\"
    fi
}

autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd
add-zsh-hook preexec theme_preexec


### Setting the prompt ###

# Modyfying the git prompts
ZSH_THEME_GIT_PROMPT_PREFIX="git::%{$FG[088]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="\u276f %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$FG[088]%}🎁 "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[064]%} -- "


# Setting characters
PR_SET_CHARSET=""
PR_HBAR="─"
PR_ULCORNER="┌"
PR_LLCORNER="└"
PR_LRCORNER="┘"
PR_URCORNER="┐"

# Deciding if we want to change the titlebar
case $TERM in
    xterm*)
        PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
    ;;
    screen)
        PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%'
    ;;
    *)
    PR_TITLEBAR=""
    ;;
esac

# Decide whether to set a screen title
if [[ "$TERM" = "screen" ]]; then
    PR_STITLE=$'%{\ekzsh\e\\%'
else
    PR_STITLE=""
fi

HEAVY_RIGHT="❯"
HEAVY_LEFT="❮"


# Setting the prompt
PROMPT='${PR_SET_CHARSET}${PR_STITLE}${(e)PR_TITLEBAR}\
${FG[054]%}${PR_ULCORNER}${PR_HBAR}${FG[247]%}${HEAVY_LEFT}\
${PR_GREEN}%${PR_PWDLEN}<...<%~%<<\
${FG[247]%}${HEAVY_RIGHT}\
${FG[054]%}${PR_HBAR}${PR_HBAR}${(e)PR_FILLBAR}${PR_HBAR}${PR_GREY}\
${FG[064]%} %(?.✔.%{$fg[red]%}✘%f)\

${FG[054]%}${PR_LLCORNER}${PR_BLUE}${PR_HBAR}\
 %{$reset_color%}$(git_prompt_info)$(git_prompt_status)\
%{$reset_color%}\
'


# See https://geoff.greer.fm/lscolors/
export LSCOLORS="CxexhxdxBxDbedabagacad"
export LS_COLORS="di=1;32:ln=34:so=37:pi=33:ex=1;31:bd=1;33;41:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
