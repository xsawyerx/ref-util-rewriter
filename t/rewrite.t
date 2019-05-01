use strict;
use warnings;
use Test::More tests => 2 + 8;

BEGIN {
    use_ok('Ref::Util::Rewriter');
}

can_ok(
    Ref::Util::Rewriter::,
    qw<rewrite_doc rewrite_string rewrite_file>,
);

my @tests = (
    q{ref $foo eq 'ARRAY';}        => q{is_arrayref($foo);},
    q{ref($foo) eq 'ARRAY';}       => q{is_arrayref($foo);},
    q{ref  ($foo) eq 'ARRAY';}     => q{is_arrayref($foo);},
    q{ref($foo) or}                => q{is_ref($foo) or},
    q!if (ref($foo) eq 'ARRAY') {! => q!if (is_arrayref($foo)) {!,
    q{ref($foo) eq 'ARRAY' or}     => q{is_arrayref($foo) or},
    q!sub { my $is_arrayref = ref $self eq 'ARRAY'; }! => q!sub { my $is_arrayref = is_arrayref($self); }!,
    q!sub { my $is_arrayref = ref $self eq 'ARRAY' && $x == 42; }! => q!sub { my $is_arrayref = is_arrayref($self) && $x == 42; }!,

    # not supported (yet?)
    #qq{ref(\$foo) # comment\nor}   => q{is_ref($foo) or # comment},
);

while ( my ( $input, $output ) = splice @tests, 0, 2 ) {
    my $test_name = $input;
    is(
        Ref::Util::Rewriter::rewrite_string($input),
        $output,
        $test_name,
    );
}
