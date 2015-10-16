package NCTTest::WWW::Stat;

use strict;

use base qw(NCTTest::WWW);
use utf8;

sub process {
    my $self = shift;

    my $days = $self->{params}{days};
    my $stat;
    if ($days and $days =~ /^[1-9]\d*$/) {
    	my $query = "select date(to_timestamp(s.n * 86400))::varchar || ' - ' || date(to_timestamp((s.n + ?) * 86400))::varchar,
    						(CASE (select count(*) from users u where (extract(epoch from u.ctime) / 86400) between s.n and s.n + ?) WHEN 0 THEN 0
    						 ELSE (select count(*) from users u where (extract(epoch from u.ctime) / 86400) between s.n and s.n + ? and u.status = 'registered')::float /
    							  (select count(*) from users u where (extract(epoch from u.ctime) / 86400) between s.n and s.n + ?)::float END) * 100 || '%'
					 from (select generate_series((select (extract(epoch from ctime) / 86400 - 0.5)::int from users order by ctime asc limit 1),
												  (select (extract(epoch from now()) / 86400 - 0.5)::int),
								  ?) n) s";
       	$stat = $self->{db}{dbh}->selectall_arrayref($query, {}, $days - 1, $days, $days, $days, $days);
    }

    $self->{template_vars} = {
    	days => $self->{params}{days},
        section => 'stat',
        stat => $stat,
    };
}

sub template_name {
    return 'stat.tt';
}

1;