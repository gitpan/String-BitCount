package String::BitCount;

use strict;
use vars qw(
    $VERSION $Version $Revision
    @ISA @EXPORT
);

require Exporter;

@ISA = qw(Exporter);

$Version = $VERSION = "1.11";
($Revision = substr(q$Revision: 1.2 $, 10)) =~ s/\s+$//;

@EXPORT = qw(BitCount showBitCount);

my $bits = '0';
for (0 .. 7) {
    $bits .= join '', map { ++$_ } split '', $bits;
}

eval <<EDQ;
    sub BitCount {
	(local \$_ = join '', \@_) =~ tr/\\0-\\377/$bits/;
	tr/1// + tr/2// * 2 + tr/3// * 3 + tr/4// * 4
	       + tr/5// * 5 + tr/6// * 6 + tr/7// * 7 + tr/8// * 8;
    }

    sub showBitCount {
	my(\@s) = \@_;
	foreach (\@s) {
	    tr/\\0-\\377/$bits/;
	}
	wantarray ? \@s : join '', \@s;
    }
EDQ
die $@ if $@;

1;

__END__

=head1 NAME

String::BitCount, BitCount showBitCount - count number of "1" bits in string

=head1 SYNOPSIS

    use String::BitCount;

=head1 DESCRIPTION

=over 8

=item BitCount LIST

Joins the elements of LIST into a single string
and returns the the number of bits in this string.

=item showBitCount LIST

Copies the elements of LIST to a new list and converts
the new elements to strings of digits showing the number
of set bits in the original byte.  In array context returns
the new list.  In scalar context joins the elements of the
new list into a single string and returns the string.

=back

=head1 AUTHOR

Winfried Koenig <win@in.rhein-main.de>

=head1 SEE ALSO

perl(1)

=cut
