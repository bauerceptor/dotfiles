# grt - cd to git root directory
function grt --description "cd to git root directory"
    cd (git rev-parse --show-toplevel)
end