sub css {
  return tag(link => {rel => 'stylesheet',
                      type => 'text/css',
                      href => $_[0] });
}

1;
