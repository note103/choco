#!/usr/bin/env perl
use strict;
use warnings;
use Cwd;
use Getopt::Long qw(:config posix_default gnu_compat);
use Pod::Usage;


my $opts = {
    selector => 'peco',
    command => 'echo',
};

GetOptions(
    $opts => qw(
        selector|s=s
        command|c=s
        hidden|a
        help|h
    ),
);

pod2usage if ($opts->{help});

my $selector = $opts->{selector};
my $command = $opts->{command};

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

    # シンボリックリンク及び実行ファイルの末尾記号を削除
    $pwd =~ s/[\@\*]\z//;

    if (-f $pwd) {
        print `$command $pwd`;
        print `echo $pwd` unless $command eq 'echo';
        last;
    }
}

sub run {
    my ($pwd, $dir) = @_;
    chomp($pwd);

    my $parent = '';
    $parent = '../' if ( $parent_flag == 1 );

    while (1) {
        # 一覧から選択
        $dir = `
            dirs=\$(ls "$ls_opts" "$pwd" | grep -e /)
            files=\$(ls "$ls_opts" "$pwd" | grep -v /)
            for i in exit $parent \$dirs \$files ; do echo \$i; done | $selector
        `;
        chomp $dir;

        # シンボリックリンクまたは実行ファイルなら末尾記号を削除
        # ディレクトリならスラッシュを末尾に追加
        if ($dir=~ /[\@\*]\z/) {
            $dir=~ s/[\@\*]\z//;
            $dir= "$dir/" if (-d $dir);
        }

        if ($dir eq 'exit') {
            print `echo $pwd`;
            exit;
        }
        elsif ($dir =~ m!(.+)/\z!) {
            # ディレクトリならディレクトリ名をパスの末尾に付加して繰り返し継続
            my $base = $1;
            $pwd = "$pwd$base/";
        }
        elsif ($dir =~ m![^/]\z!) {
            # ファイルならファイル名をパスの末尾に付加して繰り返しから離脱
            $pwd = "$pwd$dir";
            last;
        }
        else {
            last;
        }
    }
    return ($pwd, $dir)
}


__END__

=head1 SYNOPSIS

choco [options] [FILE]

Options:

  -h --help            Show help
  -s --selector        Set selector [default: peco]
  -a --hidden          Add to target hidden files
