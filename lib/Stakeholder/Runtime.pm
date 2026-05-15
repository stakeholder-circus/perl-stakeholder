package Stakeholder::Runtime;

use strict;
use warnings;
use JSON::PP;
use Stakeholder::Catalog qw(context_for list_values normalize_family registry_id renderer_key_for tranche_for);

sub _hash {
  my ($value) = @_;
  my $hash = 2166136261;
  for my $char (split //, $value) {
    $hash ^= ord $char;
    $hash = ($hash * 16777619) % 4294967296;
  }
  return $hash;
}

sub focus_payload {
  my (%args) = @_;
  my $family = normalize_family($args{family});
  die "invalid family: $args{family}" unless defined $family;

  my ($context_key, $context_value) = context_for($family);
  my $hash = _hash("$args{seed}::$family");
  my $seconds = $hash % 86400;
  my $hour = int($seconds / 3600);
  my $minute = int(($seconds % 3600) / 60);
  my $second = $seconds % 60;

  return {
    eventType => 'stakeholder.generator.output',
    sequence => 1000 + ($hash % 9000),
    family => $family,
    message => "Deterministic perl tranche for $family",
    timestamp => sprintf('2026-01-01T%02d:%02d:%02dZ', $hour, $minute, $second),
    context => {
      rendererKey => renderer_key_for($family),
      $context_key => $context_value,
      seedFingerprint => registry_id($family) . '-' . sprintf('%x', $hash),
      tranche => tranche_for($family),
      perlProfile => 'next-20-deterministic-foundation',
    },
    generationProvenance => {
      sourceRepo => 'perl-stakeholder',
      baseline => 'next20-family-focus',
      experimental => JSON::PP::false,
      adapterType => 'static-catalog',
      promptVersion => undef,
    },
    outputFormat => $args{output_format},
  };
}

sub encode_json_pretty {
  return JSON::PP->new->canonical->pretty->encode($_[0]);
}

sub render_text {
  my ($payload) = @_;
  my $context = $payload->{context};
  return join "\n",
    "family: $payload->{family}",
    "renderer: $context->{rendererKey}",
    "tranche: $context->{tranche}",
    "sequence: $payload->{sequence}",
    "timestamp: $payload->{timestamp}",
    "message: $payload->{message}";
}

sub run {
  my (@args) = @_;
  my %options = (
    seed => 'default-seed',
    output_format => 'text',
    list_values => 0,
  );

  while (@args) {
    my $arg = shift @args;
    if ($arg eq '--list-values') {
      $options{list_values} = 1;
    } elsif ($arg eq '--focus-family') {
      return (2, '', "missing value for --focus-family\n") unless @args;
      my $family = normalize_family(shift @args);
      return (2, '', "invalid --focus-family\n") unless defined $family;
      $options{focus_family} = $family;
    } elsif ($arg eq '--seed') {
      return (2, '', "missing value for --seed\n") unless @args;
      $options{seed} = shift @args;
    } elsif ($arg eq '--output-format') {
      return (2, '', "missing value for --output-format\n") unless @args;
      my $format = shift @args;
      return (2, '', "invalid --output-format: $format\n") unless $format eq 'text' || $format eq 'json';
      $options{output_format} = $format;
    } elsif ($arg eq '--experimental-provider') {
      return (2, '', "missing value for --experimental-provider\n") unless @args;
      $options{experimental_provider} = shift @args;
    } elsif ($arg =~ /^--experimental-/) {
      return (2, '', "experimental flags require --experimental-provider\n");
    } else {
      return (2, '', "unknown argument: $arg\n");
    }
  }

  return (2, '', "experimental provider '$options{experimental_provider}' is not enabled in the deterministic first tranche\n")
    if defined $options{experimental_provider};
  return (0, encode_json_pretty(list_values()), '') if $options{list_values};
  return (2, '', "focus-family is required and must be a known generator family\n") unless defined $options{focus_family};

  my $payload = focus_payload(
    family => $options{focus_family},
    seed => $options{seed},
    output_format => $options{output_format},
  );
  return (0, encode_json_pretty($payload), '') if $options{output_format} eq 'json';
  return (0, render_text($payload) . "\n", '');
}

1;
