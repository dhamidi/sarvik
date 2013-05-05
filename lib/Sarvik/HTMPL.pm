package Sarvik::HTMPL;

use strict;
use warnings;

use Sarvik::HTMPL::Node;

use Class::Struct
  stash     => '%',
  template  => '$';


our ($AUTOLOAD,$HTMPL);

sub html (&) {
  my ($code) = @_;

  return __PACKAGE__->new(
    stash => {},
    template => $code,
   );
}

sub AUTOLOAD {
  my ($name) = $AUTOLOAD =~ m/::(.*)$/;

  if ($name =~ m/^_\w+/) {
    no strict 'refs';
    goto &{$name};
  }

  my ($attr,@args) = (undef,@_);

  if (ref $args[0] eq 'HASH') {
    $attr = shift @args;
  }

  return Sarvik::HTMPL::Node->new(
    name => $name,
    attributes => $attr,
    children => \@args,
   );
}

sub _stash {
  my ($key,$value) = @_;
  return unless defined $HTMPL;

  if (defined $value) {
    $HTMPL->stash($key => $value);
  }

  return $HTMPL->stash($key);
}

sub to_string {
  my ($self,$stash) = @_;

  no strict 'refs';
  local $^H = $^H;
  strict->unimport;
  local *{caller.'::AUTOLOAD'} = \&AUTOLOAD;

  local $HTMPL = $self;
  my $old_stash = $HTMPL->stash($stash);
  my $result = $self->template->()->to_string();
  $HTMPL->stash($old_stash);
  return $result;
}

1;
