package OBal::API;

use Moose;


has schema => (is => 'ro', required => 1);


sub rs { (shift)->schema->resultset('OBal::Schema::' . shift) }


sub by_symbol {
    my ($self, $name, $price) = @_;
    $price = ($price || 0) * 100;

    my $symbol = $self->rs('Symbol')->find({name => $name});
    return unless $symbol;

    my $money    = 0;
    my %position = ();

    my @trades = $self->rs('Trade')->search(
        {symbol_id => $symbol->id},
        {order_by  => 'execution_date'},
    );

    foreach my $trade (@trades) {
        my $symbol = $trade->symbol->name;
        if ($trade->type eq 'STK') {
            $position{$symbol}{STK} += $trade->quantity;
            $money -= $trade->quantity * $trade->price - $trade->commission;
        }
        elsif ($trade->type eq 'CALL' or $trade->type eq 'PUT') {
            $position{$symbol}{$trade->type}{$trade->expiration_date->ymd}{$trade->strike} += $trade->quantity;
            $money -= $trade->quantity * $trade->symbol->multiplier * $trade->price - $trade->commission;
        }
        else {
            die 'Unknown type: ' . $trade->type;
        }
    }

    # clean up position hash
    _cleanup(\%position);
    if ($position{$name}) {
        %position = %{$position{$name}};
    } else {
        %position = ();
    }

    my $entry = 0;
    if (my $quantity = $position{STK}) {
        # calculate entry price (break even)
        $entry = $money / $quantity;

        # add current price to balance
        $money += $quantity * $price;
    }

    return ($money, \%position, $entry);
}

sub _cleanup {
    my ($pos) = @_;

    my @keys = keys %$pos;
    foreach my $key (@keys) {
        if (ref $pos->{$key}) {
            _cleanup($pos->{$key});
            delete $pos->{$key} unless %{$pos->{$key}};
        }
        elsif ($pos->{$key} == 0) {
            delete $pos->{$key};
        }
    }
}


1;
