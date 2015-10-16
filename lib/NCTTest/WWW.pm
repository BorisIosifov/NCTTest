package NCTTest::WWW;
# Базовый класс для обработчиков запросов

use strict;

use Data::Dumper;
use Template;
use Encode qw(encode decode);

my $project_dir = '/home/boris/NCTTest/';

sub new {
    my $class = shift;
    my $args = shift;

    my $object = {
        path => $args->{cgi}->path_info,
        params => {$args->{cgi}->Vars},
        config => $args->{server}{config},
        db => $args->{server}{db},
        template_vars => {},
    };

    foreach my $p (keys %{$object->{params}}) {
        $object->{params}{$p} = decode('UTF-8', $object->{params}{$p});
    }

    $object = bless $object, $class;
    return $object;
}

# возвращает контент страницы
sub content {
    my $self = shift;

    if (my $content = $self->content_without_template) {
        return $content;
    }

    my $config = {
        INCLUDE_PATH => $project_dir . 'templates/',
        INTERPOLATE  => 0,
        POST_CHOMP   => 0,
        EVAL_PERL    => 0,
        ENCODING     => 'utf-8',
    };

    my $template = Template->new($config);

    my $content;
    $template->process($self->template_name, $self->{template_vars}, \$content) or die $template->error;
    $content = encode('UTF-8', $content);

    return $content;
}

# обрабатывает запрос
sub process {
    my $self = shift;
    return $self->redirect('/admin/');
}

# возвращает название шаблона
sub template_name {
    return;
}

# если возвращает истину, то страница редиректит на url, который берется с возвращаемого значения этой функции
# используется как аксессор
sub redirect {
    my $self = shift;
    my $url = shift;

    if ($url) {
        $self->{redirect} = $url;
    }

    return $self->{redirect};
}

# если возвращает истину, то шаблонизатор не используется, а контент береться с возвращаемого значения этой функции
# используется как аксессор
sub content_without_template {
    my $self = shift;
    my $content = shift;

    if($content) {
        $self->{content_without_template} = $content;
    }

    return $self->{content_without_template};
}

1;
