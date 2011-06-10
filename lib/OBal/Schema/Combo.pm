package OBal::Schema::Combo;

use namespace::autoclean;
use DBIx::Class::Candy;


table 'combo';

column id      => {data_type => 'INTEGER', is_nullable => 0};
column comment => {data_type => 'VARCHAR', is_nullable => 1};

primary_key 'id';

has_many qw/trades OBal::Schema::Trade combo_id/;


1;
