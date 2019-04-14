#!/usr/bin/env perl
use strict;
use warnings;
use Time::Piece;
use Cwd;
use Smart::Options;


my $opts = Smart::Options->new
    ->default(selector => 'peco')->alias(s => 'selector')
    ->alias(a => 'hidden')
    ->parse;

my $selector = 'peco';
if ($opts->{selector} eq 'cho') {
    $selector = $opts->{selector};
}

my $ls_opts = '-F';
my $parent_flag = 1;

if ($opts->{hidden}) {
    $ls_opts = '-aF';
    $parent_flag = 0;
}

my $pwd = Cwd::getcwd().'/';
my $dir = '.';

while (1) {
    ($pwd, $dir) = run($pwd, $dir);

    $pwd =~ s/[\@\*]\z//;
    if (-f $pwd) {
        print `echo $pwd`;
        last;
    }
}

sub run {
    my ($pwd, $dir) = @_;
    chomp($pwd);

    my $parent;
    if ( $parent_flag == 1 ) {
        $parent = "../";
    } else {
        $parent = "";
    }

    my $quit   = 'exit';

    while (1) {
        my $epoch = localtime->epoch;
        $dir = `
            dirs=\$(ls "$ls_opts" "$pwd" | grep -e / | sed 's/ /$epoch/g')
            files=\$(ls "$ls_opts" "$pwd" | grep -v / | sed 's/ /$epoch/g')
            for i in $quit $parent \$dirs \$files ; do echo \$i | sed 's/$epoch/ /g'; done | $selector
        `;
        chomp $dir;

        if ($dir=~ /[\@\*]\z/) {
            $dir=~ s/[\@\*]\z//;
            $dir= "$dir/" if (-d $dir);
        }

        if ($dir =~ /(.+)(\/)\z/) {
            my $base = $1;
            $pwd = "$pwd$base/";
        }
        elsif ($dir =~ /\A$quit\z/) {
            print `echo $pwd`;
            exit;
        }
        elsif ($dir =~ /[^\/]\z/) {
            $pwd = "$pwd$dir";
            last;
        }
        else {
            last;
        }
    }
    return ($pwd, $dir)
}
