#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

BEGIN {
  use_ok('Sarvik::Document');
}

my $doc = Sarvik::Document->parse(q{
#+title: hello, world
#+href:e 'foo' . '-' . 'bar'
#+backend: htmpl
#+include:e ['testlib.pl']
#+longtext: this text
#  is spread over several lines

head(css('foo.css'),
     title(_stash('title')))
});

is($doc->stash('title'),'hello, world');
is($doc->stash('href'),'foo-bar');
is($doc->stash('backend'),'htmpl');
is($doc->stash('longtext'),'this text is spread over several lines');
is($doc->process($doc->stash),
   '<head><link rel="stylesheet" href="foo.css" type="text/css" />'
     .'<title>hello, world</title></head>');

done_testing();
