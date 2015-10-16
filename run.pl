#!/usr/bin/perl

use strict;
use lib::abs 'lib';

binmode STDERR, ':utf8';

use File::Find;
use Data::Dumper;

use NCTTest::Server;
use NCTTest::Config;

my $config = NCTTest::Config->new;

# автоматически подключаем все модули, лежащие в директории WWW - обработчики запросов
sub require_module {
    if ($_ and $_ =~ /\.pm$/) {
        my $file = $File::Find::name;
        my $topdir = $File::Find::topdir;
        $file =~ s/$topdir\///x;
        $file =~ s/\.pm$//;
        my @file = split /\//, $file;
        my $module = 'NCTTest::WWW::' . join ('::', @file);
        eval "require $module";
        warn $@ if $@;
    }
}

find({wanted => \&require_module, no_chdir => 1}, $config->{project_dir} . 'lib/NCTTest/WWW/');

my $server = NCTTest::Server->new($config->{port});
$server->run();
#my $pid = $server->background();
#print "Use 'kill $pid' to stop server.\n";
