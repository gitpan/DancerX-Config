package DancerX::Config;
{
  $DancerX::Config::VERSION = '0.01';
}
use strict;
use warnings;
use B qw(perlstring);
use FindBin qw($Bin);
use Cwd qw(getcwd abs_path);
use Dancer ":syntax";
use Dancer::Config;
use Data::Dumper;

sub import {
    my $class = shift;
    my $app_dir = $class->find_dancer_appdir;
    my $curr_app_dir = config->{appdir} || q{};
    if ($app_dir ne $curr_app_dir) {
        config->{appdir} = $app_dir;
        Dancer::Config::load();
    }
    my $decoder = bless {dancer_cfg => config, config => config}, __PACKAGE__;
    $decoder->placeholder;
}

sub placeholder {
    my $self = shift;
    my $config = $self->{config};
    my $change_before = Data::Dumper->new([$config])->Indent(0)->Dump;
    my $change_after = $change_before;
    $change_after =~s{\~\*([a-zA-Z0-9\.\_]+)\*\~}{
        my $token = $1;
        my $path = join "", map {sprintf "{%s}", perlstring($_)} split /\./, $token;
        eval qq{return \$self->{dancer_cfg}$path || ""};
    }ge;
    if ($change_before ne $change_after) {
        my $new_config = eval "my $change_after";
        %$config = (%$new_config);
    }
    return;
}

sub find_dancer_appdir {
    my $class = shift;
    my $appdir = q{};
    if ($ENV{APP_DIR} && -d $ENV{APP_DIR}) {
        $appdir = $ENV{APP_DIR};
        return abs_path($appdir) if -f "$appdir/config.yml";
    }
    $appdir = getcwd();
    return abs_path($appdir) if -f "$appdir/config.yml";
    $appdir = "$Bin/../";
    return abs_path($appdir) if -f "$appdir/config.yml";
    die "Cannot find any dancer config.yml file";
}

1;
__END__
=head1 NAME

DancerX::Config - Dancer config smart finder + parser

=head1 SYNOPSIS

=head3 Case 1

    dancer config.yml at /Sites/website/config.yml
    
    a test script run at ~/tests/00_here.t
    BEGIN {$ENV{APP_DIR} = "/Sites/website"}
    use DancerX::Config;

    my $config = Dancer::config;

-head3 Case 2

Set a dynamic variable before the SQLite file path in the config.

        plugins:
            DBIC:
               dsn: "dbi:SQLite:dbname=~*appdir*~/dbfiles/my.db"

    use DancerX::Config;
    print Dancer::setting("DBIC")->{dsn}
    
~*appdir*~ will be replaced to value of Dancer::setting("appdir")

=head1 DESCRIPTION

Try to find the app dir in 3 placesr "current dir", "../$FindBin::Bin" and $ENV{APP_DIR}

=head1 AUTHOR

Michael Vu

=head1 LICENSE AND COPYRIGHT

Copyright 2009-2010 Michael Vu

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
