# cigale

[![Build Status](https://travis-ci.org/itchio/cigale.svg)](https://travis-ci.org/itchio/cigale)
[![Gem Version](https://badge.fury.io/rb/cigale.svg)](https://badge.fury.io/rb/cigale)

cigale generates XML configuration that Jenkins can grok, from a bunch of
human-readable, diff-friendly, YAML files.

Key points:

  * The source code should be human-readable
  * Macros are just a YAML subtree that can be instanciated with
  parameters of any types (scalars, sequences, etc.)

## Installation

Run:

```bash
gem install cigale
```

## Usage

The `test` command generates XML files for you to inspect

```bash
cigale test spec/fixtures/parity/builders/fixtures/ant001.yaml -o tmp
```

This would create the `./tmp` directory and generate XML files in there.

You can also specify a whole directory, in which case, cigale will parse
the whole directory recursively and generate all job definition it finds:

```bash
cigale test ci/jobs -o tmp
```

To upload your job configuration to a running Jenkins instance

## What can I use?

You can browse the `spec/fixtures/` directory to see what's possible.

Another good reference sources is the [Jenkins Job Builder documentation][jjbdoc],
which cigale usually supports a superset of (at least in the categories listed
in `spec/parity_spec.rb`)

[jjbdoc]: (http://jenkins-job-builder.readthedocs.org/en/latest/definition.html)

## Macros

Define a macro with a top-level element starting with `:`

```yaml
- :git-advanced:
    git:
      url: 'git@{host}:{user}/{name}.git'
      credentials-id: 'some-credentials'
      branches:
        - '{branches}'
```

N.B: Always use quotes when using variable substitution, e.g. `'{a}'`, otherwise
it'll be interpreted as a YAML object.

Use a macro by having a subtree be an object whose only key is a dot followed
by the macro's name:

```yaml
- job:
    name: cigale
    scm:
      - .git:
          host: github.com
          user: itchio
          name: cigale
          branches: **
```

The following will expand to:

```yaml
- job:
    name: cigale
    scm:
      - git:
          url: 'git@github.com:itchio/cigale.git'
          credentials-id: 'some-credentials'
          branches:
            - '**'
```

If you're unsure what something will expand to, you can use the `dump` command:

```bash
cigale dump my-def.yml -o tmp
```

## Contributing

1. Fork it ( https://github.com/itchio/cigale/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

cigale is released under the MIT License.

Read the `LICENSE.txt` file in this repository for more informations.
