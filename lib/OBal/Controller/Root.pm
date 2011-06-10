package OBal::Controller::Root;

use Moose;
use namespace::autoclean;

use Data::Dump qw/pp/;

BEGIN { extends 'Catalyst::Controller' }

use OBal::API;


my $CURRENT = require 'stock-prices.pl';


__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ($self, $c) = @_;

    my $api = OBal::API->new(schema => $c->model('Options')->schema);

    my %balance = ();

    # get all symbols
    my @symbols = $c->model('Options::Symbol')->all;

    my $total = 0;
    foreach my $symbol (@symbols) {
        my ($money, $position) = $api->by_symbol($symbol->name, $CURRENT->{$symbol->name});
        my $dump = pp $position;
        $dump =~ s/^\{\n?//;
        $dump =~ s/\n?\}$//;
        $balance{$symbol->name} = {
            money    => $money,
            position => $dump,
        };
        $total += $money;
    }

    $c->stash(BALANCE => \%balance, TOTAL => $total);
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

sub end : ActionClass('RenderView') {}


__PACKAGE__->meta->make_immutable;

1;
