#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use Time::Piece;

my $args = shift;
my @args = split /\s+/, $args;

my $back     = 1;
my $fmt      = '';
my $option   = '-F';
my $selector = 'cho';
my $pwd = `pwd`; chomp $pwd; $pwd = $pwd.'/';

for (@args) {
    chomp $_;
    if    ( $_ =~ /d/)  { $fmt = 'd'; }
    elsif ( $_ =~ /f/)  { $fmt = 'f'; }
    elsif ( $_ =~ /p/)  { $selector = 'peco'; }
    elsif ( $_ =~ /\./) {
        $back = 0;
        $option = '-aF'; }
    else                {
        out($pwd);
    }
}

my $dir = '.';
my $quit   = 'exit';
my $epoch = localtime->epoch;

main($pwd, $dir, $args, $fmt);

sub main {
    ($pwd, $dir, $args, $fmt) = @_;
    chomp($pwd);

    my $parent;
    if ( $back == 1 ) {
        $parent = "../";
    } else {
        $parent = "";
    }

    if ($fmt eq 'd' ) {
        $dir = `
            if [ -n "\$( ls "$option" "$pwd" | grep -e / -e @ )" ]; then
                tmp=\$(ls "$option" "$pwd" | grep -e / -e @ | sed 's/ /$epoch/g');
                for i in $quit $parent \$tmp ; do echo \$i | sed 's/$epoch/ /g'; done | $selector
            else
                for i in $quit $parent ; do echo \$i; done | $selector
            fi 2>/dev/null
        `;
    }
    elsif ($fmt eq 'f' ) {
        $dir = `
            if [ -n "\$( ls "$option" "$pwd" | grep -e / )" ]; then
                tmp=\$(ls "$option" "$pwd" | grep -v / | sed 's/ /$epoch/g');
            fi 2>/dev/null
            for i in $quit $parent \$tmp ; do echo \$i | sed 's/$epoch/ /g'; done | $selector
        `;
    } else {
        $dir = `
            tmp=\$(ls "$option" "$pwd" | grep -e / | sed 's/ /$epoch/g')
            rest=\$(ls "$option" "$pwd" | grep -v / | sed 's/ /$epoch/g')
            for i in $quit $parent \$tmp \$rest ; do echo \$i | sed 's/$epoch/ /g'; done | $selector
        `;
    }

    chomp $dir;
    if ($dir =~ /(.+)( \/|\@ )\z/x) {
        my $base = $1;
        $dir =~ s/@\z/\//;
        $pwd = "$pwd$base/";
        main($pwd, $dir, $args, $fmt);
    }
    elsif ($dir =~ /$quit/) {
        out($pwd);
    }
    elsif ($dir =~ /[^\/]$/) {
        $pwd = "$pwd$dir";
        out($pwd);
    }
    else {
        out($pwd);
    }
}

sub out {
    $pwd = shift;
    $pwd =~ s/@\z//;
    print `echo $pwd`;
    exit;
}
