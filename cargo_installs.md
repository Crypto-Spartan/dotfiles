# Cargo install commands

list cargo installed packages:
```bash
cargo install --list | rg '(?-u)^([a-z0-9_-]+) v[^:[:space:]]+:$' -r '$1'
```

update cargo packages automatically:
```bash
cargo install $(cargo install --list | rg '(?-u)^([a-z0-9_-]+) v[^:[:space:]]+:$' -r '$1')
```

# Cargo packages (work)
- cargo-cache
- dust
- eza
- delta
- mprocs
- tokei
- xan
- zellij
- zoxide
