package OBal::Schema::Symbol;

use namespace::autoclean;
use DBIx::Class::Candy;


table 'symbol';

column id         => {data_type => 'INTEGER', is_nullable => 0};
column name       => {data_type => 'VARCHAR', is_nullable => 0};
column multiplier => {data_type => 'INTEGER', is_nullable => 0};

primary_key 'id';
unique_constraint [qw/name/];

has_many qw/trades OBal::Schema::Trade symbol_id/;


1;
