#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use LWP::UserAgent;

use lib::abs '../lib';

use_ok('NCTTest::Server');
use_ok('NCTTest::Config');
use_ok('NCTTest::DB');
use_ok('NCTTest::WWW');
use_ok('NCTTest::WWW::Admin');
use_ok('NCTTest::WWW::Stat');

can_ok('NCTTest::Server', qw(run handle_request));
can_ok('NCTTest::Config', qw(new));
can_ok('NCTTest::DB', qw(new));
can_ok('NCTTest::WWW', qw(new process content template_name redirect content_without_template));
can_ok('NCTTest::WWW::Admin', qw(new process content template_name redirect content_without_template));
can_ok('NCTTest::WWW::Stat', qw(new process content template_name redirect content_without_template));

my $config = NCTTest::Config->new;
isa_ok($config, 'NCTTest::Config');

my $db = NCTTest::DB->new($config);
isa_ok($db, 'NCTTest::DB');

my $ua = LWP::UserAgent->new;

my $admin_res = $ua->request(HTTP::Request->new(GET => 'http://' . $config->{domain} . ':' . $config->{port} . '/admin/'));
ok($admin_res->is_success);

my $stat_res = $ua->request(HTTP::Request->new(GET => 'http://' . $config->{domain} . ':' . $config->{port} . '/stat/'));
ok($stat_res->is_success);

done_testing();
