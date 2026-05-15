> [!WARNING]
> This repository is AI-assisted and manually reviewed. It is local-only in the next-20 deterministic sprint.

# perl-stakeholder

Perl implementation of the stakeholder deterministic first tranche.

## Current tranche

- Full dedicated `classic-six + modern-core` generator families.
- Grouped fallback for later generator families.
- Deterministic normalized JSON with same-seed stability.
- `--list-values`, `--focus-family`, `--output-format`, `--seed`, and explicit `--experimental-provider` fail-fast.
- Full live-provider/runtime support remains deferred to the later provider wave.

## Commands

- `python3 scripts/validate_scaffold.py`
- `perl -c bin/stakeholder.pl`
- `prove -Ilib t`
- `perl -Ilib bin/stakeholder.pl --list-values`
- `perl -Ilib bin/stakeholder.pl --output-format json --focus-family code_analyzer --seed 123`
- `docker build -t perl-stakeholder .`
