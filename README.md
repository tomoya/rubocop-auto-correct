# rubocop-auto-correct package

Apply RuboCop auto-crrect in Atom

![rubocop-auto-correct:current-file](https://cloud.githubusercontent.com/assets/18009/7369380/abc3a688-edec-11e4-9a44-58a1604c454d.gif)

## Require

* [rubocop](https://github.com/bbatsov/rubocop)

### Install

    $ gem install rubocop

## Usage

1. Run `Rubocop Auto Correct: Current File` in Command Palette
2. Select `Rubocop Auto-correct` in Context menu
3. Select [Packages] -> [Rubocop Auto-correct] -> [Current File] in menubar

## keymap example

```coffee
'atom-text-editor[data-grammar~="ruby"]':
  'alt-r': 'rubocop-auto-correct:current-file'
```

## TODO

* apply buffer (not file)
* auto run
* rubocop path setting in config
* add spec
