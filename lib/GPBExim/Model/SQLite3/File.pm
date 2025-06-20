package GPBExim::Model::SQLite3::File;

use lib::abs '../../../../lib';
use uni::perl ':dumper';
use parent 'GPBExim::Model::SQLite3';

sub init {
    my $self = shift;
    my %args = (
        @_
    );

    $self->SUPER::init(@_);

    $self->{path} ||= $self->{cfg}{db}{path};
    $self->{schema_path} ||= $self->{cfg}{db}{schema_path} // '';

    if ($self->{cfg}{db}{clear_db_on_init} and -e $self->{path}) {
        unlink $self->{path} or warn "Failed to remove file $self->{dbfile}: $!";
    }

    return $self;
}

sub DESTROY {
    my $self = shift;

    if (my $super_destroy = $self->can('SUPER::DESTROY')) {
        $self->$super_destroy();
    }

    # Опционально — удаление файла БД
    if ($self->{cfg}{db}{clear_db_on_destroy} and -e $self->{path}) {
        unlink $self->{path} or warn "Failed to remove file $self->{dbfile}: $!";
    }

}


1;