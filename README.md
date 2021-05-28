# worktree
zsh plugins for working with git worktree 

## Usage

###Install the plugin
`zsh
(cd $ZSH_CUSTOM; git clone git@github.com:jspears/worktree.git)
`

### Activate the plugin
Edit .zshrc
find the `plugins` variable
add 'worktree' to the list

```zsh
plugins=(worktree zsh-nvm git npm )

```


### Configuration
There are 2 ENV variables to configure
- `WORKTREE_CODE_DIR ` - what directory to look for projects
- `WORKTERE_CODE_EDITOR` - what to use as an IDE.  If unset it will not prompt to open IDE in new worktree
- `WORKTREE_POST_SWITCH` - A command to run after switchin (maybe npm install?)
- `WORKTREE_POST_CREATE` - A command to run after creating a new worktree.

## Dependencies
A relatively modern version of git and oh-my-zsh

