package Sarvik::HTMPL::Node;

use strict;
use warnings;

use Class::Struct
  attributes => '%',
  name => '$',
  children => '@';

our %VOID = (
  area => 1,
  base => 1,
  br => 1,
  col => 1,
  command => 1,
  embed => 1,
  hr => 1,
  img => 1,
  input => 1,
  keygen => 1,
  link => 1,
  meta => 1,
  param => 1,
  source => 1,
  track => 1,
  wbr => 1,
);

our %ENTITIES = (
  q{"} => 'quot',
  q{'} => 'apos',
  q{<} => 'lt',
  q{>} => 'gt',
);

sub to_string {
  my ($self) = @_;

  if ($VOID{$self->name}) {
    return sprintf('<%s%s />',$self->name, $self->attribute_string);
  } else {
    return sprintf('<%s%s>%s</%s>',
                   $self->name,
                   $self->attribute_string,
                   join('',map {
                     ref $_ eq __PACKAGE__ ? $_->to_string : entity_encode($_)
                   } @{ $self->children }),
                   $self->name);
  }
}

sub attribute_string {
  my ($self) = @_;

  return join('',map {
    sprintf(' %s="%s"', $_, entity_encode($self->attributes($_)))
  } keys %{ $self->attributes });
}

sub entity_encode {
  my ($str) = @_;

  $str =~ s/&/&amp;/g;          # has to be first

  while (my ($char,$replacement) = each %ENTITIES) {
    $str =~ s/$char/&$replacement;/ge;
  }

  return $str;
}
1;
