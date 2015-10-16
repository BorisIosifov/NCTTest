package NCTTest::Config;

use strict;

sub new {
    my $class = shift;

    my $config = {
        # абсолютный путь к директории приложения
        project_dir => '/home/boris/NCTTest/',

        # порт
        port => '8888',

        # домен
        domain => 'localhost',

        # параметры подключения к БД
        db_source => 'dbi:Pg:dbname=bb_test;host=localhost;port=5432',
        db_username => 'boris',
        db_password => 'boris',

        # количество записей, показываемых на одной странице
        lines_per_page => 20,
    };

    $config = bless $config, $class;
    return $config;
}

1;