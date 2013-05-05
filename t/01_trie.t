use strict;
use warnings;
use Test::More;

BEGIN {
  use_ok('Sarvik::Trie');
}

my $t = Sarvik::Trie->new(separator => '/');

ok($t,'trie creation');

is($t->put('a',1),1,'insert into empty trie');
is($t->put('a/b',2), 2, 'nested insert');
is($t->put('a/c',3), 3, 'nested insert');

is($t->get('a')->value, 1, 'retrieve value');
is(scalar $t->find('a'), 3, 'retrieve with prefix');

is($t->get('a/b')->value, 2, 'retrieve nested');
is(scalar $t->find('a/b'), 1, 'nested retrieve with prefix');

is($t->remove('a'),1, 'remove');
is($t->get('a/b')->value, 2, 'find child after removal');

done_testing();
