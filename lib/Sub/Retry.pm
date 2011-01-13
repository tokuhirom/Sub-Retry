package Sub::Retry;
use strict;
use warnings;
use 5.008001;
our $VERSION = '0.01';
use parent qw/Exporter/;
use Time::HiRes qw/sleep/;

our @EXPORT = qw/retry/;

sub retry {
    my ( $times, $delay, $code ) = @_;

    my $err;
  LOOP: for ( 1 .. $times ) {
        if (wantarray) {
            my @ret = eval { $code->() };
            unless ($err = $@) {
                return @ret;
            }
        }
        elsif (not defined wantarray) {
            eval { $code->() };
            unless ($err = $@) {
                return;
            }
        }
        else {
            my $ret = eval { $code->() };
            unless ($err = $@) {
                return $ret;
            }
        }
        sleep $delay;
    }
    die $err;
}

1;
__END__

=encoding utf8

=head1 NAME

Sub::Retry - retry $n times

=head1 SYNOPSIS

    use Sub::Retry;
    use LWP::UserAgent;

    my $ua = LWP::UserAgent->new();
    my $res = retry 3, 1, sub {
        $ua->post('http://example.com/api/foo/bar');
    };

=head1 DESCRIPTION

Sub::Retry provides the fuction named 'retry'.

=head1 FUNCTIONS

=over 4

=item retry($n_times, $delay, \&code)

This function calls C<< \&code >>. If the code throws exception, this function retry C<< $n_times >> after C<< $delay >> seconds.

Return value of this function is the return value of C<< \&code >>. This function cares L<wantarray>.

=back

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF GMAIL COME<gt>

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
