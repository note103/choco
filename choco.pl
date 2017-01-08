#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use Time::Piece;

my @args = @ARGV;

my $back     = 1;
my $option   = '-F';
my $selector = 'cho';
my $pwd = `pwd`; chomp $pwd; $pwd = $pwd.'/';
my $command = 'echo';

for (@args) {
    chomp $_;
    if ( $_ =~ /p/)  { $selector = 'peco'; }
    elsif ( $_ =~ /o/) {
        $command = 'open';
    }
    elsif ( $_ =~ /\./) {
        $back = 0;
        $option = '-aF';
    }
    else                {
        out($pwd);
    }
}

my $dir = '.';
my $quit   = 'exit';
my $epoch = localtime->epoch;

main($pwd, $dir, @args);

sub main {
    ($pwd, $dir, @args) = @_;
    chomp($pwd);

    my $parent;
    if ( $back == 1 ) {
        $parent = "../";
    } else {
        $parent = "";
    }

    $dir = `
        tmp=\$(ls "$option" "$pwd" | grep -e / | sed 's/ /$epoch/g')
        rest=\$(ls "$option" "$pwd" | grep -v / | sed 's/ /$epoch/g')
        for i in $quit $parent \$tmp \$rest ; do echo \$i | sed 's/$epoch/ /g'; done | $selector
    `;

    chomp $dir;
    if ($dir=~ /\@$/) {
        $dir=~ s/\@$//;
        unless (-e $dir) {
            $dir= "$dir/";
        } elsif (-d $dir) {
            $dir= "$dir/";
        }
    }

    if ($dir =~ /(.+)(\/)\z/x) {
        my $base = $1;
        $pwd = "$pwd$base/";
        main($pwd, $dir, @args);
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

    if ($command eq 'open' && -f $pwd) {
        print `$command $pwd`;
    }
    print `echo $pwd`;
    exit;
}
