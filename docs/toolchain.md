# Toolchain

- Host CLI: built-in/Homebrew Perl
- Required core modules: `JSON::PP`, `FindBin`, `Test::More`
- Native syntax check: `perl -c bin/stakeholder.pl`
- Native tests: `prove -Ilib t`
- Docker runtime: `perl:5.40-slim`
