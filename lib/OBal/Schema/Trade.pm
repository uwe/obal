package OBal::Schema::Trade;

use namespace::autoclean;
use DBIx::Class::Candy -components => [qw/InflateColumn::DateTime/];

###TODO### currency

table 'trade';

column id              => {data_type => 'INTEGER',  is_nullable => 0};
column trade_id        => {data_type => 'INTEGER',  is_nullable => 0};
column execution_date  => {data_type => 'DATETIME', is_nullable => 0};
column symbol_id       => {data_type => 'INTEGER',  is_nullable => 0};
column exchange_id     => {data_type => 'INTEGER',  is_nullable => 1};
column type            => {data_type => 'VARCHAR',  is_nullable => 0};
column expiration_date => {data_type => 'DATE',     is_nullable => 1};
column strike          => {data_type => 'INTEGER',  is_nullable => 1};
column quantity        => {data_type => 'INTEGER',  is_nullable => 0};
column price           => {data_type => 'INTEGER',  is_nullable => 0};
column commission      => {data_type => 'INTEGER',  is_nullable => 0};
column combo_id        => {data_type => 'INTEGER',  is_nullable => 1};

primary_key 'id';

belongs_to qw/symbol   OBal::Schema::Symbol   symbol_id/;
belongs_to qw/exchange OBal::Schema::Exchange exchange_id/;
belongs_to qw/combo    OBal::Schema::Combo    combo_id/;


1;
