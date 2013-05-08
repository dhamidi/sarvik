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
#+longtext: this text
#  is spread over several lines

p(_stash('title'))
});

is($doc->stash('title'),'hello, world');
is($doc->stash('href'),'foo-bar');
is($doc->stash('backend'),'htmpl');
is($doc->stash('longtext'),'this text is spread over several lines');
is($doc->process($doc->stash),'<p>hello, world</p>');

done_testing();
