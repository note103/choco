# NAME

dirmove - move around directories.

# DESCRIPTION

直感的な操作でディレクトリ間を移動します。

# DEMO

### peco
![dirmove_peco](https://dl.dropboxusercontent.com/u/7779513/dirmove/dirmove_peco.gif)

### sentaku
![dirmove_sentaku](https://dl.dropboxusercontent.com/u/7779513/dirmove/dirmove_sentaku.gif)

# SYNOPSIS

    # with 'peco'.
    $ m

    # with 'sentaku'.
    $ m s

    # Include dot-directories.
    $ m .

    # Include dot-directories with sentaku.
    $ m s .    # or 'm . s'

# Installation

    # Install
    $ cd
    $ git clone git@github.com:note103/dirmove.git

    # Edit .bashrc
    function m {
        if [ -n "$*" ] ; then
            DIR=$(perl ~/dirmove/dirmove.pl "$*");
        else
            DIR=$(perl ~/dirmove/dirmove.pl);
        fi
    
        if [ -n "$DIR" ] ; then
            cd "$DIR"
        fi
    }

    # Command 'm' and Option 's' are example names. Replace it with that you want.

# REQUIREMENT

- [peco](https://github.com/peco/peco)

## OPTION

- [sentaku](https://github.com/rcmdnk/sentaku)

# LICENSE

Copyright (C) Hiroaki Kadomatsu.  
This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

# AUTHOR

Hiroaki Kadomatsu (@note103)

- [Blog](http://note103.hateblo.jp/)
- [Twitter](https://twitter.com/note103)
