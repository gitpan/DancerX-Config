use strict;
use warnings;

use Test::More tests => 2;                      # last test to print
BEGIN {$ENV{APP_DIR} = "../.."}
use DancerX::Config;

is Dancer::setting("test1"), Dancer::setting("template");
is Dancer::setting("test2"), Dancer::setting("engines")->{template_toolkit}{encoding}."!!OK";
