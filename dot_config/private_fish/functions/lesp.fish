function lesp --wraps=lesspipe.sh --description 'Run lesspipe'
    if command -q lesspipe.sh
        command lesspipe.sh $argv
    else
        command lesspipe $argv
    end
end
