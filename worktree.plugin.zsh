#!/usr/bin/env zsh
# This script makes working with workree's a bit nicer.

WORKTREE_CODE_DIR=${WORKTREE_CODE_DIR:-../*}
WORKTREE_POST_SWITCH=${WORKTREE_POST_SWITCH:-echo switched}
WORKTREE_POST_CREATE=${WORKTREE_POST_CREATE:-echo created}

export function worktree-remove(){
    git worktree remove $1
}

export function origin_branch(){
    git branch -r -l "origin/${1:-*}"  --sort=committerdate | sed 's,origin/,,g;s, ,,g' | tail -2
}

export function worktree(){
    BRANCH=$1
    DIRNAME="../$(basename $PWD)-$BRANCH"

    if [[ $(origin_branch $BRANCH) = $BRANCH ]]; then 
        echo "branch '$BRANCH' exists checking out into '$DIRNAME'"
        git worktree add $DIRNAME $BRANCH
        pushd 
        $WORKTREE_POST_CREATE
        popd
    elif git worktree list | grep -q "\[${BRANCH}\]"; then
        DIRNAME=$(git worktree list | grep "\[$BRANCH\]" | cut -f1 -d' ')
        echo "$BRANCH already exists in $DIRNAME"

    else
        echo "'$1' is a new branch checking out into '$DIRNAME'"
        git worktree add $DIRNAME -b $BRANCH
        pushd 
        $WORKTREE_POST_CREATE
        popd
    fi
    pushd $DIRNAME
    $WORKTREE_POST_SWITCH
    popd
    if [[ -n $WORKTREE_CODE_EDITOR ]];then
        confirm "Open vs code in $DIRNAME" && \
        $WORKTREE_CODE_EDITOR $DIRNAME
    fi
}

function _worktree(){
    compadd $(git worktree list | sed 's,.*\[\(.*\)\]$,\1,g') $(origin_branch)
}

function _worktree_remove(){
    compadd $(git worktree list | cut -d' ' -f1)
}

function _code(){
   compadd $~=WORKTREE_CODE_DIR
}

function confirm(){
    read REPLY\?"$1 [Yn]"
    case $REPLY in
        [nN]|[Nn][Oo]) return 1;;
    esac
    return 0;
}

compdef _code $WORKTREE_CODE_EDITOR
compdef _worktree worktree
compdef _worktree_remove worktree-remove

