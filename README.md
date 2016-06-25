# NAME

dirmove - move around directories.

# DESCRIPTION

直感的な操作でファイル／ディレクトリを操作します。

# DEMO

### cho
![dirmove_cho](https://dl.dropboxusercontent.com/u/7779513/blog/2016-06-25_sh_cho.gif)

### peco
![dirmove_peco](https://dl.dropboxusercontent.com/u/7779513/blog/2016-06-25_sh_peco.gif)

# Installation

    # Download a repogitory or the script 'dirmove.pl'.
    $ cd
    $ git clone git@github.com:note103/dirmove.git

    # Edit .bashrc (example)
    function ch {
        dir=$(perl ~/repos/src/github.com/note103/_dev/dirmove/dirmove.pl "$*")
        echo "$dir"
    }
    function chopen {
        arg=$(ch "$*")
        cd $(echo "$arg" | perl -pe 'chomp $_; s!\A(.+?)([^\/]+)\z!$1!')
        if [ ! -d "$arg" ] ; then open "$arg"; fi
    }

    # Add alias (example)
    alias s=chopen
    alias p="chopen p"

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
