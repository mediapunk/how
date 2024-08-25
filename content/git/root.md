# Git Submodule Status

I have Git project that uses a submodule. I wanted a convenient way to check the status of both. I decided I could make a bash alias to do this. Something like:

    alias gitstat="git status; git -C <path/to/submodule> status"

First problem is that it's hard to read where the main repo status ends and the submodule status starts. So how about a new status command that prints a header, and can indent the status. To indent we'll pipe to sed, which means we need to make sure the git status command will still output color as well.

Let's get rid of the alias and define a function to print status with indentation, git_stat_ind:

    unalias gitstat
    git_stat_ind() { echo "[ $2 ]"; git -c color.status=always -C "$2" status | sed -e "s_^_$1_"; echo ""; }

Now we can get the status of both, and specify the indentation, like this:

    git_stat_ind; git_stat_ind "    " <relative/path/submodule>


But if I'm not in the root directory of the parent repo, that command fails to print the submodule status.

## Find the Root Directory of a Git Repository

I need to get the root directory of the Git repo. I was planning to make a bash alias to solve this. Something like

    alias gitroot="git rev-parse --show-toplevel"

From this Stack Overflow discussion on
[finding the root directory of a git repository](https://stackoverflow.com/questions/957928/is-there-a-way-to-get-the-git-root-directory-in-one-command),
I discovered that you can define an command alias for git itself.

    git config [--global] alias.root 'rev-parse --show-toplevel'

Now I can get the status of both with:

    git_stat_ind; (cd $(git root); git_stat_ind "    " <relative/path/submodule>)

## Bottom Line

I defined these:

    git config --global alias.root 'rev-parse --show-toplevel'
    git config --global color.status always

    git_stat_ind() { echo "--[ $2 ]"; git -C "$2" status | sed -e "s_^_$1_"; echo ""; }
    
    GITSTATI_SUBMODULE=<relative/path/submodule>

And finally the function that gives two, um—stati? statuses? Well, there is an indent feature so: stati.

-     gitstati() { git_stat_ind; (cd $(git root); git_stat_ind "    " "$GITSTATI_SUBMODULE"); }






