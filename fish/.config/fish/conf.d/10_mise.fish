if type -q mise
    if status is-interactive
        mise activate fish | source
    else
        mise activate fish --shims | source
    end

    abbr mnode 'mise x -- node'
    abbr mnpm 'mise x -- npm'
    abbr mnvim 'mise x -- nvim'
    abbr myarn 'mise x -- yarn'
    abbr mpnpm 'mise x -- pnpm'
    abbr mbun 'mise x -- bun'
    abbr mruby 'mise x -- ruby'
end
