package Stakeholder::Catalog;

use strict;
use warnings;
use Exporter qw(import);

our @EXPORT_OK = qw(all_families context_for list_values normalize_family renderer_key_for registry_id tranche_for);

my @classic_six = qw(
  code_analyzer
  data_processing
  jargon
  metrics
  network_activity
  system_monitoring
);

my @modern_core = qw(
  agent_workflows
  platform_engineering
  observability_ai_runtime
  delivery_preview_ops
  supply_chain_security
);

my @ai_governance = qw(
  ai_inference_ops
  evaluation_and_guardrails
  knowledge_retrieval
  edge_client_runtime
  identity_and_trust
  aibom_provenance
  agent_boundary_security
  embedded_agentic_pipeline
  data_governance_compliance
  finops_capacity
);

my @security_blockchain = qw(
  blockchain_protocol_ops
  cross_chain_interop
  proof_and_sequencer_ops
);

my @overlay_quantum = qw(
  hybrid_runtime_ops
  capacity_cost_controller
  batch_execution_tuner
  compiler_maintainer
  interop_adapter_engineer
  preflight_capacity_planner
  simulator_performance_engineer
);

my @health_protocol = qw(
  fhir_profile_generator
  smart_launch_oauth
  bulk_fhir_population_ops
  hl7v2_feed_ops
  clinical_workflow_events
  dicomweb_imaging_ops
  openehr_semantic_record_ops
  device_telemetry_clinical
  emr_vendor_adapter
  ocpp_chargepoint_ops
  ocpi_roaming_ops
  mcp_a2a_ops
  streaming_bus_ops
  service_mesh_rpc_ops
);

my @all = (@classic_six, @modern_core, @ai_governance, @security_blockchain, @overlay_quantum, @health_protocol);
my %all = map { $_ => 1 } @all;
my %ai = map { $_ => 1 } @ai_governance;
my %security = map { $_ => 1 } @security_blockchain;
my %overlay = map { $_ => 1 } @overlay_quantum;

my %dedicated = (
  code_analyzer => [ 'classic-six.code_analyzer', 'analysisFocus', 'regex-contract-audit', 'classic-six' ],
  data_processing => [ 'classic-six.data_processing', 'dataWindow', 'tabular-stream-reconciliation', 'classic-six' ],
  jargon => [ 'classic-six.jargon', 'languagePolicy', 'perl-ecosystem-glossary', 'classic-six' ],
  metrics => [ 'classic-six.metrics', 'signalBlend', 'latency-error-saturation', 'classic-six' ],
  network_activity => [ 'classic-six.network_activity', 'transportMix', 'http-sse-socket', 'classic-six' ],
  system_monitoring => [ 'classic-six.system_monitoring', 'telemetryScope', 'runtime-build-host', 'classic-six' ],
  agent_workflows => [ 'modern-core.agent_workflows', 'coordinationMode', 'script-orchestration-handshake', 'modern-core' ],
  platform_engineering => [ 'modern-core.platform_engineering', 'platformSurface', 'prove-cpanless-release-lane', 'modern-core' ],
  observability_ai_runtime => [ 'modern-core.observability_ai_runtime', 'runtimeSignals', 'logs-metrics-provider-audit', 'modern-core' ],
  delivery_preview_ops => [ 'modern-core.delivery_preview_ops', 'deliveryGuardrail', 'preview-release-checkpoints', 'modern-core' ],
  supply_chain_security => [ 'modern-core.supply_chain_security', 'supplyChainPosture', 'core-module-integrity-attestation', 'modern-core' ],
);

sub registry_id {
  my ($family) = @_;
  $family =~ s/_/-/g;
  return $family;
}

sub all_families {
  return @all;
}

sub normalize_family {
  my ($value) = @_;
  return undef unless defined $value;
  $value = lc $value;
  $value =~ s/^\s+|\s+$//g;
  $value =~ s/-/_/g;
  return $all{$value} ? $value : undef;
}

sub renderer_key_for {
  my ($family) = @_;
  return $dedicated{$family}[0] if exists $dedicated{$family};
  return 'fallback.ai_governance' if $ai{$family};
  return 'fallback.security_blockchain' if $security{$family};
  return 'fallback.overlay_quantum' if $overlay{$family};
  return 'fallback.health_protocol';
}

sub tranche_for {
  my ($family) = @_;
  return $dedicated{$family}[3] if exists $dedicated{$family};
  my $key = renderer_key_for($family);
  $key =~ s/^fallback\./fallback-/;
  return $key;
}

sub context_for {
  my ($family) = @_;
  return ($dedicated{$family}[1], $dedicated{$family}[2]) if exists $dedicated{$family};
  my $group = renderer_key_for($family);
  $group =~ s/^fallback\.//;
  return ('fallbackFamily', $group);
}

sub list_values {
  return {
    outputFormats => [qw(text json)],
    flags => [qw(list-values focus-family output-format seed experimental-provider)],
    generatorFamilies => [
      map {
        {
          id => $_,
          registryId => registry_id($_),
          rendererKey => renderer_key_for($_),
          tranche => tranche_for($_),
        }
      } @all
    ],
    classicSix => [ map { registry_id($_) } @classic_six ],
    modernCore => [ map { registry_id($_) } @modern_core ],
    fallbackFamilies => [ map { registry_id($_) } (@ai_governance, @security_blockchain, @overlay_quantum, @health_protocol) ],
    implementationMode => 'family-focus-deterministic',
  };
}

1;
