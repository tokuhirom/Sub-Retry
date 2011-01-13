use strict;
use warnings;
use utf8;
use Test::More;
use Sub::Retry;

subtest 'simple' => sub {
    my $i = 0;
    my $ret = retry 10, 0, sub {
        die if $i++ != 5;
        return '4649';
    };
    is $ret, '4649';
};

subtest 'fail' => sub {
    my $i = 0;
    eval {
        retry 10, 0, sub {
            die "FAIL";
        };
    };
    like $@, qr/FAIL/;
    like $@, qr/\Q@{[ __FILE__ ]}/;
};

subtest 'context' => sub {
    my $i = 0;

    subtest 'list' => sub {
        my @x = retry 10, 0, sub {
            wantarray ? (1,2,3) : 0721;
        };
        is join(',', @x), '1,2,3';
    };

    subtest 'scalar' => sub {
        my $x = retry 10, 0, sub {
            wantarray ? (1,2,3) : 0721;
        };
        is $x, 0721;
    };

    subtest 'void' => sub {
        my $ok;
        retry 10, 0, sub {
            $ok++ unless defined wantarray;
        };
        ok $ok, 'void context';
    };
};

done_testing;

