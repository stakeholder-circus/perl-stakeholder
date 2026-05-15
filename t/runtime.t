use strict;
use warnings;
use Test::More;
use lib 'lib';

use Stakeholder::Catalog qw(list_values);
use Stakeholder::Runtime qw();

my $values = list_values();
is scalar @{ $values->{generatorFamilies} }, 45, 'full registry exposed';
is $values->{generatorFamilies}[0]{id}, 'code_analyzer', 'first family stable';
is $values->{generatorFamilies}[0]{rendererKey}, 'classic-six.code_analyzer', 'renderer metadata exposed';

my $first = Stakeholder::Runtime::focus_payload(family => 'platform_engineering', seed => '41', output_format => 'json');
my $second = Stakeholder::Runtime::focus_payload(family => 'platform_engineering', seed => '41', output_format => 'json');
is_deeply $first, $second, 'same seed is deterministic';

my ($code, $out, $err) = Stakeholder::Runtime::run('--list-values');
is $code, 0, 'list-values exits zero';
like $out, qr/generatorFamilies/, 'list-values emits registry';

($code, $out, $err) = Stakeholder::Runtime::run('--focus-family', 'platform-engineering', '--output-format', 'json', '--seed', '41');
is $code, 0, 'json family smoke exits zero';
like $out, qr/"family" : "platform_engineering"/, 'dashed family normalizes';

($code, $out, $err) = Stakeholder::Runtime::run('--output-format', 'json');
is $code, 2, 'missing focus fails';
like $err, qr/focus-family is required/, 'missing focus error is explicit';

($code, $out, $err) = Stakeholder::Runtime::run('--experimental-provider', 'local-demo');
is $code, 2, 'experimental provider fails fast';
like $err, qr/experimental provider/, 'provider error is explicit';

($code, $out, $err) = Stakeholder::Runtime::run('--experimental-mode', 'api');
is $code, 2, 'orphan experimental flag fails';
like $err, qr/experimental flags require --experimental-provider/, 'orphan experimental error is explicit';

done_testing();
