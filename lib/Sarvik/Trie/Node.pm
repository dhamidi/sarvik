package Sarvik::Trie::Node;

use strict;
use warnings;

use Class::Struct
  value => '$',
  children => '%';

sub insert {
  my ($self,$path,$value) = @_;

  my @path = @{ $path };
  my $current_node = \$self;

  while (my $part = shift @path) {
    if (exists ${$current_node}->children->{$part}) {
      $current_node = \${$current_node}->children($part);
    } else {
      my $next = __PACKAGE__->new();
      $next->value($value) unless scalar @path;
      ${$current_node}->children($part => $next);
      $current_node = \$next;
    }
  }
}

sub find {
  my ($self,$path) = @_;

  my @path = @{ $path };
  my $current_node = \$self;

  while (my $part = shift @path) {
    if (exists ${$current_node}->children->{$part}) {
      $current_node = \${$current_node}->children($part);
    } else {
      return $self;
    }
  }

  return ${$current_node};
}

sub collect {
  my ($self,$result) = @_;

  my @children =
    map { $_->[1] }
      sort { $a->[0] cmp $b->[0] }
        map { [ $_, $self->children($_) ] }
          keys %{ $self->children };

  push @{ $result }, @children;

  $_->collect($result) foreach @children;
}

sub is_leaf {
  my ($self) = @_;

  return values %{ $self->children } == 0;
}

1;
