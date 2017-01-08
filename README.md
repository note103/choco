# NAME

choco - Move around directories and files conveniently.

# DESCRIPTION

直感的な操作でファイル／ディレクトリを操作します。

# DEMO

### cho
![choco_cho](https://dl.dropboxusercontent.com/u/7779513/blog/2016-06-25_sh_cho.gif)

### peco
![choco_peco](https://dl.dropboxusercontent.com/u/7779513/blog/2016-06-26_sh_peco.gif)

# Installation

    1. Download a repogitory or the script 'choco.pl'.

    2. Edit .bashrc

    function choco {
        local arg=$(perl /path/to/choco/choco.pl "$@")
        local basename=${arg##*/}
        local dirname="${arg%%$basename}"
        cd "$dirname"
        echo $arg
    }

    3. Add alias (example)

    alias c="choco"
    alias c.="choco ."
    alias co="choco o"
    alias co.="choco o ."

    alias p="choco p"
    alias p.="choco p ."
    alias po="choco p o"
    alias po.="choco p o ."

    # option `o` is for Mac only.

# REQUIREMENT

- [cho](https://github.com/mattn/cho)
- [peco](https://github.com/peco/peco)

# LICENSE

Copyright (C) Hiroaki Kadomatsu.  
This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

# AUTHOR

Hiroaki Kadomatsu (@note103)

- [Blog](http://note103.hateblo.jp/)
- [Twitter](https://twitter.com/note103)
