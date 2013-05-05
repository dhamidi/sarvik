package Sarvik::Trie;

use strict;
use warnings;

use Class::Struct
  count => '$',
  separator => '$',
  root  => 'Sarvik::Trie::Node';

use Sarvik::Trie::Node;

sub path {
  my ($self,$key) = @_;

  return [split $self->separator,$key];
}

sub get {
  my ($self,$key) = @_;

  return undef unless $self->root;

  return $self->root->find($self->path($key));
}

sub find {
  my ($self,$prefix) = @_;

  return () unless ($prefix || $self->root);

  my $base = $self->root->find($self->path($prefix));
  my @result = ($self);

  $base->collect(\@result);

  return @result;
}

sub put {
  my ($self,$key,$value) = @_;

  $self->root(Sarvik::Trie::Node->new())
    unless $self->root;

  $self->root->insert($self->path($key),$value);

  $self->count(($self->count || 0) + 1);

  return $value;
}

sub remove {
  my ($self,$key) = @_;

  my @path = @{ $self->path($key) };
  my $target = pop @path;

  my $parent = $self->root->find(\@path);

  if (exists $parent->children->{$target}) {
    $target = $parent->children($target);
    my $retval = $target->value;
    $target->value(undef);

    $self->count($self->count - 1);

    return $retval;
  } else {
    return undef;
  }
}

1;
