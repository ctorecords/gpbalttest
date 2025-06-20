package GPBExim::Model::Xapian;
use lib::abs '../../../lib';
use uni::perl ':dumper';

use GPBExim::Config;
use GPBExim::Log;

use JSON::XS;
use Search::Xapian;
use File::Path qw(remove_tree);

our $INSTANCE;

sub new {
    my ($class, $model_type, %args) = @_;
    if ($args{xapian__force}) {
        $INSTANCE && $INSTANCE->destroy();
        undef $INSTANCE;
        delete $args{force};
    }
    return $INSTANCE //= $class->_new($model_type, %args);
}

sub reset { $INSTANCE->destroy(); undef $INSTANCE }
sub is_initialized { return defined $INSTANCE }

sub _new {
    my $pkg = shift;
    my $model_type = shift;
    my $cfg = GPBExim::Config->get();
    my $args = GPBExim::Config->apply_args([qw/xapian/], @_);

    my $self = bless {
        %{$args->{x}{xapian}},
        cfg => $cfg,
    }, $pkg;
    log(debug => "Xapian model: ", $args->{x}{xapian});

    $self->{cfg} = $cfg;
    $self->init();
    $INSTANCE = $self;

    return $self;
}

sub init {
    my $self = shift;

    if (my $super_destroy = $self->can('SUPER::DESTROY')) {
        $self->$super_destroy();
    }
    delete $self->{xapian_db};
    delete $self->{indexed_xapian_email};
    if ($self->{clear_db_on_init} and $self->{path} and -d $self->{path}) {
        if ($self->{clear_db_on_destroy} and $self->{path}) {
            remove_tree($self->{path}, { error => \my $err });
            if (@$err) {
                warn "Failed to remove Xapian index at $self->{path}: @$err\n";
            }
        }
    };
    $self->{xapian_db}  = Search::Xapian::WritableDatabase->new(
        $self->{path},
        Search::Xapian::DB_CREATE_OR_OPEN
    );
}

sub setup_schema { }

sub _add_xapian_ngrams {
    my $self = shift;
    my ($min, $max)  = (3, 5);

    my ($doc, $text, $prefix) = @_;
    $max = my $length = length($text);
    for my $n ($self->{min} .. $max) {
        for my $i (0 .. $length - $n) {
            my $ngram = substr($text, $i, $n);
            $doc->add_term($prefix . $ngram);
        }
    }
}

sub index_address_at_xapian {
    my $self = shift;
    my $email = shift;
    my $id    = shift;
    my %args  = @_;

    return if defined $self->{indexed_xapian_email}{$id};

    my $term = 'N' . $email;

    # Проверка через term_exists (безопасно)
    if ($self->{xapian_db}->term_exists($term)) {
        $self->{indexed_xapian_email}{$id} = $email;
        warn "$email [id=$id] already indexed at xapian" if $args{debug};
        return;
    }

    my $doc = Search::Xapian::Document->new;
    $self->_add_xapian_ngrams($doc, $email, 'N');
    $doc->set_data(encode_json({ id => $id, email => $email }));

    $self->{xapian_db}->add_document($doc)
        or die "Can't add document for $email";

    warn "$email [id=$id] was indexed at xapian" if $args{debug};

    $self->{indexed_xapian_email}{$id} = $email;
}

sub search_by_email_substring {
    my $self      = shift;
    my $substring = shift;
    my %args      = (
        limit => $self->{xapian_max_search_result},
        @_
    );
    croak "substring is required" unless defined $substring;

    my $query   = Search::Xapian::Query->new("N$substring");
    my $enquire = Search::Xapian::Enquire->new($self->{xapian_db});
    $enquire->set_query($query);

    my $mset = $enquire->get_mset(0, $args{limit});
    my %results;

    for my $match ($mset->items) {
        my $data = $match->get_document->get_data;
        my $obj  = decode_json($data);
        $results{$obj->{id}}=$obj->{email};
    }

    return \%results;
}

sub search_id_by_email_substring {
    my $self      = shift;
    my $substring = shift;
    croak "substring is required" unless defined $substring;
    my %args      = (
        limit => $self->{max_results},
        @_
    );

    my $results = $self->search_by_email_substring($substring, %args);
    return [sort keys %$results];
}

sub search_email_by_email_substring {
    my $self      = shift;
    my $substring = shift;
    croak "substring is required" unless defined $substring;
    my %args      = (
        limit => $self->{max_results},
        @_
    );

    my $results = $self->search_by_email_substring($substring, %args);
    return [sort values %$results];
}

sub remove_db {
    my $self = shift;
    my $path = shift;

    return unless -d $path;
    remove_tree($path, { error => \my $err });
    if (@$err) {
        warn "Failed to remove Xapian index at $path: @$err\n";
    }
}

sub destroy {
    my $self = shift;

    if ($self->{clear_db_on_destroy} and $self->{path}) {
        delete $self->{xapian_db};
        delete $self->{indexed_xapian_email};
        $self->remove_db($self->{path});
    };

    undef $INSTANCE if $INSTANCE and $INSTANCE == $self;
}

1;