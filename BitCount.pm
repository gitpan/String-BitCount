# $Id: BitCount.pm,v 1.4 2003/03/28 16:21:38 win Exp $

package String::BitCount;

use 5.004;
use strict;
use Carp 'carp';
use vars qw(
    $VERSION @ISA @EXPORT
);

require Exporter;

@ISA = qw(Exporter);

$VERSION = "1.12";

@EXPORT = qw(BitCount showBitCount);

my $bits = '0';
for (0 .. 7) {
    $bits .= join '', map { ++$_ } split '', $bits;
}

my $test = '';
eval "require 5.006";
if (!$@) {
    eval "require 5.008";
    if ($@) {
	# Perl v5.6.0 or v5.6.1
	$test = 'do { use bytes; length }  != do { no bytes; length }';
    } else {
	# Perl v5.8.0 and later
	$test = 'tr/\0-\377/\0/c';
    }
    $test .= ' && carp "Wide character in argument";';
}

eval <<EDQ;
    sub BitCount {
	# can't use join, wide char bug in v5.6
	local \$_ = shift; while (\@_) { \$_ .= shift }
	$test \$_ =~ tr/\\0-\\377/$bits/;
	tr/1// + tr/2// * 2 + tr/3// * 3 + tr/4// * 4
	       + tr/5// * 5 + tr/6// * 6 + tr/7// * 7 + tr/8// * 8;
    }

    sub showBitCount {
	my(\@s) = \@_;
	foreach (\@s) {
	    $test tr/\\0-\\377/$bits/;
	}
	wantarray ? \@s : join '', \@s;
    }
EDQ
die $@ if $@;

1;
__END__

=head1 NAME

String::BitCount - count number of "1" bits in strings

=head1 SYNOPSIS

  use String::BitCount;

  # next line recommended for Perl versions 5.006 and newer.
  use bytes;

  # get the number of bits in $string.
  my $count = BitCount($string);

  # prints '334'; The number of bits in the codes
  # of 'a', 'b' and 'c' are '3', '3' and '4'.
  print showBitCount('abc'), "\n";

=head1 DESCRIPTION

=over 8

=item BitCount LIST

Joins the elements of LIST into a single string
and returns the the number of bits in this string.
Only code points in the range 0x00 .. 0xFF are allowed.

=item showBitCount LIST

Copies the elements of LIST to a new list and converts
the new elements to strings of digits showing the number
of set bits in the original byte.  In array context returns
the new list.  In scalar context joins the elements of the
new list into a single string and returns the string.

=back

=head1 NOTES

The arguments of this subroutines are restricted to strings of 
characters having code points in the range 0x00 .. 0xFF.
If any string argument has code points greater than 0xFF (255)
a "Wide character" warning will be issued.

=head1 AUTHOR

Winfried Koenig <w.koenig@acm.org>

=head1 SEE ALSO

perl(1)

=cut
