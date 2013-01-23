use strict;
use warnings;
use FindBin qw($Bin);
use Test::More tests => 3;                      # last test to print
BEGIN {$ENV{APP_DIR} = "$Bin/.."}
use DancerX::Config;

my $appdir = Dancer::setting("appdir");
is Dancer::setting("data")->{dir}, "$appdir/data";
is Dancer::setting("data")->{hybrid_cache}{dir}, "$appdir/data/hybrid_cache";
is Dancer::setting("data")->{hybrid_cache}{all_locations}, "$appdir/data/hybrid_cache/all_locations";
