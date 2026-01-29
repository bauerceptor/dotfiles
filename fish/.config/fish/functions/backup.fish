# backup - Create a timestamped backup of a file
function backup --description "Create a timestamped backup of a file"
    cp $argv[1] $argv[1].(date +%Y%m%d_%H%M%S).bak
end