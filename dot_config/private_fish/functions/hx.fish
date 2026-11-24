function hx --wraps=helix --description 'Launch Helix'
    if command -q helix
        command helix $argv
    else
        command hx $argv
    end
end
