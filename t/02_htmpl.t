use strict;
use warnings;
use Test::More;

BEGIN {
  use_ok('Sarvik::HTMPL');
}

my $doc = Sarvik::HTMPL::html {
  h1(q{hello world})
};

is(ref $doc,'Sarvik::HTMPL');
is($doc->to_string,'<h1>hello world</h1>', 'to string');

$doc = Sarvik::HTMPL::html {
  p({class => 'warning'},q{some text})
};

is($doc->to_string,'<p class="warning">some text</p>', 'with attributes');

$doc = Sarvik::HTMPL::html {
  ul(li('first'),
     li('second'));
};

is($doc->to_string,'<ul><li>first</li><li>second</li></ul>','with children');

$doc = Sarvik::HTMPL::html {
  p(_stash('greeting'))
};

is($doc->to_string({
  greeting => 'hello'
 }), '<p>hello</p>', 'with stashed values');

$doc = Sarvik::HTMPL::html {
  a({href => '?foo=1&bar=2'},'foobar')
};

is($doc->to_string, '<a href="?foo=1&amp;bar=2">foobar</a>','entity encoding of attributes');

$doc = Sarvik::HTMPL::html {
  p('1&1')
};

is($doc->to_string, '<p>1&amp;1</p>','entity encoding of text nodes');

done_testing();

