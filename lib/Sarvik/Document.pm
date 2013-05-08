package Sarvik::Document;

use strict;
use warnings;

use Sarvik::Template;

use Class::Struct
  body => '$',
  template => '$',
  stash => '%';

sub _parse_continuation_line {
  my ($line) = @_;

  if ($line =~ m/^# (.*)/) {
    return (1,$1);
  } else {
    return (0);
  }
}

sub _parse_headline {
  my ($line) = @_;

  if ($line =~ m/^#\+([^:]+):([^ ]+)?\s+(.*)/) {
    return (1,$1,defined $2? $2 : '',$3);
  } else {
    return (0);
  }
}

{
  my %MODIFIERS = (
    e => sub { my ($value) = @_;
               my $retval = eval "$value";
               die "$@$!\n" if $@;
               return $retval; },
   );

  sub _process_modifiers {
    my ($modifiers,$value) = @_;

    my @modifiers = split '',$modifiers;

    foreach my $mod (@modifiers) {
      warn "Unknown modifier $mod!\n" unless exists $MODIFIERS{$mod};
      $value = $MODIFIERS{$mod}->($value);
    }

    return $value;
  }
}

sub _parse_header {
  my ($text,$result) = @_;
  my @lines = split /\n/,$text;

  # leading blank lines should be ignored
  shift @lines while length($lines[0]) == 0;

  # now parse the actual headers
  while (@lines > 0) {
    my $line = shift @lines;

    # headlines are of the form
    #
    #     #+var_name:modifiers value
    #
    # a headline's value span multiple lines, by starting the following
    # lines with "# ", e.g.
    #
    #    #+foo: bar
    #    # baz
    #
    # results in "foo" having the value "barbaz"
    my ($success,$key,$modifiers,$value) = _parse_headline($line);

    if ($success) {
      my ($continue,$restval) = (1,undef);

      while (1) {
        ($continue,$restval) = _parse_continuation_line($lines[0]);

        if ($continue) { $line = shift @lines; }
        else { last; }

        $value .= $restval;
      }

      $result->{$key} = _process_modifiers($modifiers,$value);
    }

    last if $line =~ m/^\s*$/;
  }

  return join("\n",@lines);
}

sub parse {
  my ($package,$text) = @_;

  my %stash = ();
  my $body  = _parse_header($text,\%stash);

  my $self = new($package,body => $body, stash => \%stash);

  $self->stash(backend =>'htmpl') unless $self->stash('backend');

  $self->template(Sarvik::Template->new(backend => $self->stash('backend'),
                                        body    => $body));

  return $self;
}

sub process {
  my ($self,$env) = @_;
  return $self->template->process($env);
}

1;
