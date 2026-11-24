function gl --wraps='git log --oneline --graph --all' --description 'alias gl git log --oneline --graph --all'
    git log --oneline --graph --all $argv
end
