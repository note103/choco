# NAME

choco - Move around directories and files intuitively.

# DESCRIPTION

直感的な操作でファイル／ディレクトリを操作します。

# DEMO

### move by peco
![choco_peco](./demo/choco_peco_open.gif)

### move by cho
![choco_cho](./demo/choco_cho.gif)

# Installation

1) Download a repository or the script `choco.pl`.

2) Edit .bashrc

```bash
function choco {
    local path=$(perl /path/to/choco/choco.pl $@)

    local basename=${path##*/}
    local dirname=""
    if [ -f "$path" ]; then
        dirname="${path%%$basename}"
    elif [ -d "$path" ]; then
        dirname="$path"
    fi
    cd "$dirname"
}
```

3) Add alias (example)

```bash
# use peco
alias j=choco
alias ja="choco -a"

# use cho
alias s="choco -s cho"
alias sa="choco -s cho -a"

# use peco & open target file
## `open` command is for Mac only.
alias jo="choco -c open"
alias jao="choco -a -c open"
```

# REQUIREMENT

- [peco](https://github.com/peco/peco)
- [cho](https://github.com/mattn/cho)

# LICENSE

Copyright (C) Hiroaki Kadomatsu.  
This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

# AUTHOR

Hiroaki Kadomatsu (@note103)

- [Blog](http://note103.hateblo.jp/)
- [Twitter](https://twitter.com/note103)
