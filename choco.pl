#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use Time::Piece;

my @args = @ARGV;

my $back     = 1;
my $command = 'echo';
my $option   = '-F';
my $pwd = `pwd`; chomp $pwd; $pwd = $pwd.'/';
my $selector = 'cho';

my @arg = @ARGV;

if (scalar(@arg) > 0) {
    for (@arg) {
        if ($_ =~ /-/) {
            if ($_ =~ /p/) {
                $selector = "peco";
            }
            if ($_ =~ /a/) {
                $back = 0;
                $option = '-aF';
            }
        }
        else {
            $command = $_;
        }
    }
}

for (@args) {
    chomp $_;
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
        $dir= "$dir/" if (-d $dir);
    }

    if ($dir =~ /(.+)(\/)\z/x) {
        my $base = $1;
        $pwd = "$pwd$base/";
        main($pwd, $dir, @args);
    }
    elsif ($dir =~ /^$quit$/) {
        print `echo $pwd`;
        exit;
    }
    elsif ($dir =~ /[^\/]$/) {
        $pwd = "$pwd$dir";
        out($pwd, $dir, @args);
    }
    else {
        out($pwd, $dir, @args);
    }
}

my $res;
sub out {
    $pwd = shift;
    $pwd =~ s/@\z//;

    $dir = shift;
    @args = @_;

    if (-f $pwd) {
        print `echo $pwd`;
        exit;
    }
    else {
        main($pwd, $dir, @args);
    }
}
