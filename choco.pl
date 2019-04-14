#!/usr/bin/env perl
use strict;
use warnings;
use Time::Piece;
use Cwd;

my $back     = 1;
my $option   = '-F';
my $selector = 'cho';
my $pwd = Cwd::getcwd().'/';

my @arg = @ARGV;
if (scalar(@arg) > 0) {
    for (@arg) {
        chomp $_;
        if ($_ =~ /\A-\w/) {
            if ($_ =~ /p/) {
                $selector = "peco";
            }
            if ($_ =~ /a/) {
                $back = 0;
                $option = '-aF';
            }
        }
    }
}

my $dir = '.';

while (1) {
    ($pwd, $dir) = run($pwd, $dir);

    $pwd =~ s/@\z//;
    if (-f $pwd) {
        print `echo $pwd`;
        last;
    }
}

sub run {
    my ($pwd, $dir) = @_;
    chomp($pwd);

    my $parent;
    if ( $back == 1 ) {
        $parent = "../";
    } else {
        $parent = "";
    }

    my $quit   = 'exit';

    while (1) {
        my $epoch = localtime->epoch;
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

        if ($dir =~ /(.+)(\/)\z/) {
            my $base = $1;
            $pwd = "$pwd$base/";
        }
        elsif ($dir =~ /^$quit$/) {
            print `echo $pwd`;
            exit;
        }
        elsif ($dir =~ /[^\/]$/) {
            $pwd = "$pwd$dir";
            last;
        }
        else {
            last;
        }
    }
    return ($pwd, $dir)
}
