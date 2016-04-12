#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';

my $args = shift;

$args = 1 unless $args;
my @args = split /\s+/, $args;

my $attr = {};
$attr->{option} = 1;
$attr->{selector} = 1;

for (@args) {
    if ($_ eq 's') {
        $attr->{selector} = 's';
    } elsif ($_ eq '.') {
        $attr->{option} = '.';
    }
}

my $dir = '.';
my $pwd = `pwd`;

main($pwd, $dir, $args);

sub main {
    ($pwd, $dir, $args) = @_;
    chomp($pwd);

    my $selector = '';
    if ($attr->{selector} eq 's') {
        $selector = 'sentaku'
    } else {
        $selector = 'peco'
    }

    # 不可視チェック
    my $back = '';
    my $option = '';

    if ($attr->{option} eq '.') {
        $option = '-aF';
    } else {
        $option = '-F';
        $back = "../\n";
    }

    $dir = `
    if [ -n "\$( ls "$option" "$pwd" | grep / )" ]; then
        str=""\$( ls "$option" "$pwd" | grep / )
        for i in \$str
        do
            echo \$i
        done | "$selector"
    else
        echo "$back" | "$selector"
    fi 2>/dev/null
    `;

    # ディレクトリが無ければ（＝改行が戻り）脱出
    out($pwd) if ($dir =~ /\A\n\z/);

    # 移動中断したら（＝空文字が戻り）脱出
    if ($dir eq '') {
        out($pwd);
    } else {
        $dir =~ s/\/$//;
        $pwd = "$pwd/$dir";
        main($pwd, $dir, $args);
    }
}

sub out {
    $pwd = shift;
    print `echo $pwd`;
    exit;
}
