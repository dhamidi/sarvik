package Sarvik::Template;

use strict;
use warnings;

use Class::Struct
  errstr  => '$',
  backend => '$',
  body    => '$';

our %Backends = (
  htmpl => {
    name => 'Sarvik::HTMPL',
    func => sub {
      my ($body,$env) = @_;
      my $result;

      eval sprintf("%s = Sarvik::HTMPL::html {\n%s\n};",
                   '$result', $body);

      die "$@$!\n" if $@;

      return $result->to_string($env);
    },
  },
);

sub _load {
  my ($self) = @_;

  unless (exists $Backends{$self->backend}) {
    $self->errstr("no such backend: ".$self->backend);
    return;
  }

  my $backend = $Backends{$self->backend};
  my $module = $backend->{name};
  eval "use $module";
  die "$@$!\n" if $@;

  return $backend->{func};
}

sub process {
  my ($self,$env) = @_;

  my $handler = $self->_load;

  return $handler->($self->body,$env);
}

1;
