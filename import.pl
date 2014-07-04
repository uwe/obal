#!/usr/bin/perl

use strict;
use warnings;

use Data::Dump       qw/pp/;
use Math::Round      qw/round/;
use Text::xSV::Slurp qw/xsv_slurp/;

use lib 'lib';
use OBal::Schema;


my %ASSET = (
    STK  => \&stock,
    OPT  => \&option,
    FUT  => \&future,
    CASH => \&cash,
);

my %PUT_CALL = (
    P => 'PUT',
    C => 'CALL',
);

my %SYMBOL = (
    'DBKd' => 'DBK',
    'RWEd' => 'RWE',
);


my $schema = OBal::Schema->connect('dbi:mysql:options', 'root', 'root', {mysql_enable_utf8 => 1});

my $trades = xsv_slurp 'orders.csv';

foreach my $trade (@$trades) {
    my $importer = $ASSET{$trade->{AssetClass}} or die pp $trade;

    $importer->($trade);
}



sub stock {
    my ($trade) = @_;

    my %data = (
        trade_id       => $trade->{TradeID},
        execution_date => datetime($trade->{TradeDate}, $trade->{TradeTime}),
        symbol_id      => symbol2id($trade->{Symbol}, $trade->{Multiplier}),
        exchange_id    => exchange2id($trade->{Exchange}),
        type           => 'STK',
        quantity       => $trade->{Quantity},
        price          => round($trade->{TradePrice} * 100),
        commission     => round($trade->{IBCommission} * 100),
    );
    rs('Trade')->find_or_create(\%data);
}

sub option {
    my ($trade) = @_;

    my %data = (
        trade_id       => $trade->{TradeID},
        execution_date  => datetime($trade->{TradeDate}, $trade->{TradeTime}),
        symbol_id       => symbol2id($trade->{UnderlyingSymbol}, $trade->{Multiplier}),
        exchange_id     => exchange2id($trade->{Exchange}),
        type            => $PUT_CALL{$trade->{'Put/Call'}},
        expiration_date => $trade->{Expiry},
        strike          => round($trade->{Strike} * 100),
        quantity        => $trade->{Quantity},
        price           => round($trade->{TradePrice} * 100),
        commission      => round($trade->{IBCommission} * 100),
    );
    rs('Trade')->find_or_create(\%data);
}

sub future {
    my ($trade) = @_;

    warn "Ignore FUT trade...";
}

sub cash {
    my ($trade) = @_;

    warn "Ignore CASH trade...";
}


sub rs { $schema->resultset('OBal::Schema::' . shift) }

sub datetime {
    my ($date, $time) = @_;

    $date =~ s/(\d{4})(\d\d)(\d\d)/$1-$2-$3/;

    if ($time) {
        $time =~ s/(\d\d)(\d\d)(\d\d)/$1:$2:$3/;
        $date .= ' ' . $time;
    }

    return $date;
}

sub symbol2id {
    my ($name, $multiplier) = @_;

    my %symbol = (
        name       => $SYMBOL{$name} || $name,
        multiplier => $multiplier == 1 ? 100 : $multiplier,
    );
    my $symbol = rs('Symbol')->find_or_create(\%symbol);

    return $symbol->id;
}

sub exchange2id {
    my ($name) = @_;
    return undef if $name eq '--';

    my $exchange = rs('Exchange')->find_or_create({name => $name});

    return $exchange->id;
}

