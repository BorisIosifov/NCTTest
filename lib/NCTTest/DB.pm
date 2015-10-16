package NCTTest::DB;

use strict;

use Data::Dumper;
use DBI;

sub new {
    my $class = shift;
    my $config = shift;
    my $object = {};

    $object->{dbh} = DBI->connect(
        $config->{db_source},
        $config->{db_username},
        $config->{db_password},
        {
            AutoCommit => 1,
            pg_enable_utf8 => 1,
        }
    );

    $object = bless $object, $class;
    return $object;
}

1;