#!perl

use warnings;
use strict;

use Test::More tests => 51;

use Net::IP::XS qw(ip_normalize);

my @data = (
    ['1.0.0.1/32' => ['1.0.0.1', '1.0.0.1']],
    ['0.0.0.0/24' => ['0.0.0.0', '0.0.0.255']],
    ['0.0.0.0/0' =>  ['0.0.0.0', '255.255.255.255']],
    ['1.2/16' => ['1.2.0.0', '1.2.255.255']],
    ['0::0/0' => ['0000:0000:0000:0000:0000:0000:0000:0000',
                  'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff']],
    ['AAAA::/16' => ['aaaa:0000:0000:0000:0000:0000:0000:0000',
                  'aaaa:ffff:ffff:ffff:ffff:ffff:ffff:ffff']],
    ['1:2:3:4::/64' => ['0001:0002:0003:0004:0000:0000:0000:0000',
                  '0001:0002:0003:0004:ffff:ffff:ffff:ffff']],
    ['0.0.0.0/32,' => ['0.0.0.0', '0.0.0.1']],
    ['0.0.0.0/32||||' => ['0.0.0.0', '0.0.0.0']],
    ['0.0.0.0/32,/32,/32' => ['0.0.0.0', '0.0.0.2']],
    ['0/8,/8,/8' => ['0.0.0.0', '2.255.255.255']],
    ['0/8,/8,/8,/24' => ['0.0.0.0', '3.0.0.255']],
    ['asdf/asdf' => []],
    ['-asdf' => []],
    ['-' => []],
    ['255-' => []],
    ['255-    ' => []],
    ['- ' => []],
    ['asdf - 128.0.0.1' => []],
    ['0' => ['0.0.0.0']],
    ['0::0' => ['0000:0000:0000:0000:0000:0000:0000:0000']],

    ['0.0.0.0-1.0.0.0' => ['0.0.0.0', '1.0.0.0']],
    ['0-255' => ['0.0.0.0', '255.0.0.0']],
    ['0-255.255' => ['0.0.0.0', '255.255.0.0']],
    ['1.2.3.4     -   5.6.7.8' => ['1.2.3.4', '5.6.7.8']],
    ['0::0-1::1' =>
        ['0000:0000:0000:0000:0000:0000:0000:0000',
         '0001:0000:0000:0000:0000:0000:0000:0001']],
    ['abcd::-abce::' => ['abcd:0000:0000:0000:0000:0000:0000:0000',
                         'abce:0000:0000:0000:0000:0000:0000:0000']],
    ['0.0.0.0 + 1' => ['0.0.0.0', '0.0.0.1']],
    ['0.0.0.0 + 255' => ['0.0.0.0', '0.0.0.255']],
    ['0.0.0.0 + 256' => ['0.0.0.0', '0.0.1.0']],
    ['1.0.0.0 + 65535' => ['1.0.0.0', '1.0.255.255']],
    ['0.0.0.0+1' => ['0.0.0.0', '0.0.0.1']],
    ['0.0.0.0+255' => ['0.0.0.0', '0.0.0.255']],
    ['0.0.0.0+256' => ['0.0.0.0', '0.0.1.0']],
    ['1.0.0.0+65535' => ['1.0.0.0', '1.0.255.255']],
    ['1.0.0.0+1234567812389123578457847543278547345' => []],
    ['0::0 + 65536' => ['0000:0000:0000:0000:0000:0000:0000:0000',
                        '0000:0000:0000:0000:0000:0000:0001:0000']],
    ['0000:: - FFFF::' => ['0000:0000:0000:0000:0000:0000:0000:0000',
                           'ffff:0000:0000:0000:0000:0000:0000:0000']],
    ['0::0/0' => ['0000:0000:0000:0000:0000:0000:0000:0000',
                  'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff']],
    ['0::0/128,/128,/128,/128,/128,/128' => [
        '0000:0000:0000:0000:0000:0000:0000:0000',
        '0000:0000:0000:0000:0000:0000:0000:0005']],
    ['1' x 2500 => []],
    ['abcd::/ab' => []],
    ['abcd::/1' => []],
    ['abcd::/200' => []],
    ['abcd::/-200' => []],
    ['1.2.3.4/ab' => []],
    ['1.2.3.4/100' => []],
    ['1.2.3.4/-100' => []],
    ['1.2.3.4/0' => []],
    ['1.2.3.4 + ABCD' => []],
    ['ZZZZ' => []],
);

for my $entry (@data) {
    my ($arg, $res) = @{$entry};
    my @res_t = ip_normalize($arg);
    is_deeply(\@res_t, $res, "Got normalized result for $arg");
}

1;