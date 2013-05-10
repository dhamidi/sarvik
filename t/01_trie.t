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

foreach my $path ('a/c', 'a/c/dc') {
  my @with_path = $t->find_to('a/c');
  is(scalar @with_path,2);
  is($with_path[0]->value,1);
  is($with_path[1]->value,3);
}

is($t->count,3,'element count');

is($t->get('a')->value, 1, 'retrieve value');
is(scalar $t->find('a'), 3, 'retrieve with prefix');

is($t->get('a/b')->value, 2, 'retrieve nested');
is(scalar $t->find('a/b'), 1, 'nested retrieve with prefix');

is($t->remove('a'),1, 'remove');
is($t->get('a/b')->value, 2, 'find child after removal');

is($t->count,2,'element count after removal');

is($t->put('/a',10),10,'insert with leading separator');
isnt($t->get('a')->value,$t->get('/a')->value,'retrieve with leading separator');
is($t->get('/a')->value,10);

done_testing();
