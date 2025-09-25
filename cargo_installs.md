# Cargo install commands

list cargo installed packages:
```bash
cargo install --list | rg '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' '
```

update cargo packages automatically:
```bash
cargo install $(cargo install --list | rg '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' ')
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
