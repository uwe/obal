package OBal::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    INCLUDE_PATH       => OBal->path_to('tmpl'),
    TEMPLATE_EXTENSION => '.tt',
    render_die         => 1,
);


1;
