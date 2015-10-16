package NCTTest::Server;

use strict;

use Data::Dumper;
use HTTP::Server::Simple::CGI;
use base qw(HTTP::Server::Simple::CGI);

use NCTTest::DB;
use NCTTest::Config;

sub after_setup_listener {
    my $self = shift;
    $self->{config} = NCTTest::Config->new;
    $self->{db} = NCTTest::DB->new($self->{config});
}

sub handle_request {
    my $self = shift;
    my $cgi  = shift;

    my $path = $cgi->path_info();
    my @path = split /\//, $path;
    shift @path;
    my $hclass = $path[0] ? 'NCTTest::WWW::' . ucfirst($path[0]) : 'NCTTest::WWW';

    my $header = {
        -charset    => 'utf-8',
    };

    my $h;
    eval {
        # инициализируем обработчик запроса
        $h = $hclass->new({
            server => $self,
            cgi => $cgi,
        });
    };
    if ($@) {
        print $@;
    }

    if (ref($h)) {
        my $content;
        my $redirect;
        eval {
            # обрабатываем запрос
            $h->process;
            $redirect = $h->redirect;
            $content = $h->content unless $redirect;
        };
        if ($@) {
            warn $@;
            print "HTTP/1.0 500 Internal server error\r\n";
            print $cgi->header(%$header);
            print $@;
        } else {
            if ($redirect) {
                print $cgi->redirect(
                    -uri    => $redirect,
                    -nph    => 1,
                    -status => '302 Temporary Moved'
                );
            } else {
                print "HTTP/1.0 200 OK\r\n";
                print $cgi->header(%$header);
                print $content;
            }
        }
         
    } else {
        print "HTTP/1.0 404 Not found\r\n";
        print $cgi->header(%$header),
            $cgi->start_html('Not found'),
            $cgi->h1('Not found'),
            $cgi->end_html;
    }
}

1;