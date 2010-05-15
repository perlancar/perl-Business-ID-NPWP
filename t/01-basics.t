#!perl -T

use strict;
use warnings;
use Test::More tests => 16 +10;

use Business::ID::NPWP;

ok(!(validate_npwp("") ? 1:0), "procedural style (1)");
ok((validate_npwp("00.000.001.8-000.000") ? 1:0), "procedural style (2)");

isa_ok(Business::ID::NPWP->new(""), "Business::ID::NPWP", "new() works on invalid NPWP");

ok(Business::ID::NPWP->new("00.000.001.8-000.000")->validate, "valid NPWP (1)");
ok(Business::ID::NPWP->new("0.000.001.8-000.000")->validate, "valid NPWP (2, first digit optional)");
ok(Business::ID::NPWP->new("00.000.001.8-000")->validate, "valid NPWP (3, branch code optional)");

ok(!Business::ID::NPWP->new("00.000.000.8-000.000")->validate, "invalid NPWP: zero serial");

my $i = 0;
my @npwp = qw(
02.183.241.5-000.000
02.061.179.4-000.000
01.957.716.2-000.000
02.808.957.1-000.000
02.183.787.7-000.000
01.749.700.9-000.000
01.132.928.1-000.000
01.002.720.9-000.000
01.233.075.9-000.000
01.000.724.3.000.000
);
for (@npwp) {
    $i++;
    ok(Business::ID::NPWP->new($_)->validate, "check digit checking ($i)");
}

is(Business::ID::NPWP->new("12.000.001.3-000.000")->taxpayer_code,    "12", "taxpayer_code");
is(Business::ID::NPWP->new("12.000.001.3-000.000")->kode_wajib_pajak, "12", "taxpayer_code (alias, kode_wajib_pajak)");
is(Business::ID::NPWP->new("12.000.001.3-000.000")->kode_wp,          "12", "taxpayer_code (alias, kode_wp)");

is(Business::ID::NPWP->new("00.000.001.8-000.000")->check_digit, "8", "check_digit");

is(Business::ID::NPWP->new("00.000.001.8-004.000")->local_tax_office_code, "004", "local_tax_office_code");
is(Business::ID::NPWP->new("00.000.001.8-004.000")->kode_kpp,              "004", "local_tax_office_code (alias, kode_kpp)");

is(Business::ID::NPWP->new("00.000.001.8-000.005")->branch_code, "005", "branch_code");
is(Business::ID::NPWP->new("00.000.001.8-000.005")->kode_cabang, "005", "branch_code (kode_cabang)");

is(Business::ID::NPWP->new("00 000 001 8 000 000")->normalize, "00.000.001.8-000.000", "normalize");
