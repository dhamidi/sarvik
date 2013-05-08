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

sub tag {
  my $name = shift @_;

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

sub AUTOLOAD {
  my $name = (split '::',$AUTOLOAD)[-1];

  if ($name =~ m/^_\w+/) {
    no strict 'refs';
    goto &{$name};
  }

  unshift @_,$name;
  goto &tag;
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
  local *{caller.'::tag'} = \&tag;

  local $HTMPL = $self;
  my $old_stash = $HTMPL->stash($stash);
  my $result = $self->template->()->to_string();
  $HTMPL->stash($old_stash);
  return $result;
}

1;
