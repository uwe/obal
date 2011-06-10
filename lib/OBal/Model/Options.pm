package OBal::Model::Options;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'OBal::Schema',
    connect_info => {
        dsn               => 'dbi:mysql:options',
        user              => 'root',
        password          => 'root',
        mysql_enable_utf8 => 1,
    },
);


1;
