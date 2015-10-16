package NCTTest::WWW::Admin;

use strict;

use base qw(NCTTest::WWW);
use utf8;

sub process {
    my $self = shift;

    my $error;
    if ($self->{params}{action} eq 'add') {
        my $name = $self->{params}{name};
        $error = 'Не введено имя' unless $name;

        my $phone = $self->{params}{phone};
        $error = 'Не верно введен телефон' unless $phone and $phone =~ /^\d{10}$/;

        my $ctime = $self->{params}{ctime};
        $error = 'Не верно введено время' if $ctime and $ctime !~ /^\d\d\d\d-\d\d-\d\d( \d\d:\d\d:\d\d)?$/;

        unless ($error) {
            my $query = 'insert into users (name, phone' . ($ctime ? ', ctime' : '') . ') values (?, ?' . ($ctime ? ', ?' : '') . ')';
            $self->{db}{dbh}->do($query, {}, $name, $phone, ($ctime ? ($ctime) : ()));

            return $self->redirect('/admin/');
        }
    }

    if ($self->{params}{action} eq 'change_status') {
        my $status = $self->{params}{status};
        return $self->content_without_template('wrong_status') unless $status and $status ~~ ['new', 'registered', 'refused', 'unavailable'];

        my $id = $self->{params}{id};
        return $self->content_without_template('wrong_id') unless $id and $id =~ /^[1-9]\d*$/;

        $self->{db}{dbh}->do('update users set status = ? where id = ?', {}, $status, $id);

        return $self->content_without_template('ok');
    }

    my $lpp = $self->{config}{lines_per_page} || 20;
    my $page = $self->{params}{page};
    $page = 1 unless $page and $page =~ /^[1-9]\d*$/;

    my $order_type;
    if ($self->{params}{sort} == 4) {
        $order_type = 'name asc';
    } elsif ($self->{params}{sort} == 3) {
        $order_type = 'name desc';
    } elsif ($self->{params}{sort} == 2) {
        $order_type = 'ctime asc';
    } else {
        $order_type = 'ctime desc';
    }

    my $count = $self->{db}{dbh}->selectrow_array('select count(*) from users');

    my $query = "select * from users order by $order_type limit ? offset ?";
    my $users = $self->{db}{dbh}->selectall_arrayref($query, {Slice => {}}, $lpp, ($page -1) * $lpp);
    $_->{ctime} =~ s/(\.\d+)?(\+\d{2,4})?$// foreach @$users;

    $self->{template_vars} = {
        error => $error,
        params => $self->{params},
        users => $users,
        pages => int(($count - 1) / $lpp) + 1,
        page => $page,
        section => 'admin',
        sort => $self->{params}{sort},
    };
}

sub template_name {
    return 'admin.tt';
}

1;