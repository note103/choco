#!/usr/bin/env perl
use strict;
use warnings;
use Cwd;
use Getopt::Long qw(:config posix_default gnu_compat);
use Pod::Usage;


my $opts = { selector => 'peco', };

GetOptions(
    $opts => qw(
        selector|s=s
        hidden|a
        help|h
    ),
);

pod2usage if ($opts->{help});

my $selector = $opts->{selector};

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

    my $parent = '';
    $parent = '../' if ( $parent_flag == 1 );

    while (1) {
        $dir = `
            dirs=\$(ls "$ls_opts" "$pwd" | grep -e /)
            files=\$(ls "$ls_opts" "$pwd" | grep -v /)
            for i in exit $parent \$dirs \$files ; do echo \$i; done | $selector
        `;
        chomp $dir;

        if ($dir=~ /[\@\*]\z/) {
            $dir=~ s/[\@\*]\z//;
            $dir= "$dir/" if (-d $dir);
        }

        if ($dir eq 'exit') {
            print `echo $pwd`;
            exit;
        }
        elsif ($dir =~ m!(.+)/\z!) {
            my $base = $1;
            $pwd = "$pwd$base/";
        }
        elsif ($dir =~ m![^/]\z!) {
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
