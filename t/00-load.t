#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Business::ID::NPWP' );
}

diag( "Testing Business::ID::NPWP $Business::ID::NPWP::VERSION, Perl $], $^X" );
