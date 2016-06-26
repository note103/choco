# NAME

dirmove - move around directories.

# DESCRIPTION

直感的な操作でファイル／ディレクトリを操作します。

# DEMO

### cho
![dirmove_cho](https://dl.dropboxusercontent.com/u/7779513/blog/2016-06-25_sh_cho.gif)

### peco
![dirmove_peco](https://dl.dropboxusercontent.com/u/7779513/blog/2016-06-26_sh_peco.gif)

# Installation

    1. Download a repogitory or the script 'dirmove.pl'.

    2. Edit .bashrc (example for Mac)
    function dm {
        dir=$(perl /path/to/dirmove/dirmove.pl "$*")
        echo "$dir"
    }
    function dfm {
        local arg=$(dm "$*")
        local basename=${arg##*/}
        cd ${arg%%$basename}
        if [ ! -d "$arg" ] ; then open "$arg"; fi
    }

    3. Add alias (example)
    alias s=dfm
    alias p="dfm p"

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
