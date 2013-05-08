#!/usr/bin/perl

use strict;
use warnings;
use Test::More;

BEGIN {
  use_ok('Sarvik::Template');
}

my $body = <<'EOF';
a({href => 'style.css'})
EOF

my $tmpl = Sarvik::Template->new(
  backend => 'htmpl',
  body    => $body,
);

is($tmpl->process,'<a href="style.css"></a>');

done_testing();
