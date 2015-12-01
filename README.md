# cigale

[![Build Status](https://travis-ci.org/itchio/cigale.svg)](https://travis-ci.org/itchio/cigale)

Just like jenkins-job-builder:

  * cigale generates XML configuration that Jenkins can grok, from a bunch of
    human-readable, diff-friendly, YAML files.
  * It's not production-ready

Contrary to jenkins-job-builder:

  * The source code is actually readable
  * Macros are just a YAML subtree that can be instanciated with
  parameters of any types (scalars, sequences, etc.)
  * It's not production-ready

## Installation

Execute:

```bash
bundle install
rake install
```

## Usage

Try running:

```bash
cigale test spec/fixtures/parity/git-scm.yml -o output/directory
```

## Contributing

1. Fork it ( https://github.com/itchio/cigale/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
