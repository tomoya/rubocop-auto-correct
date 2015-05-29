# rubocop-auto-correct package

Apply RuboCop auto-correct in Atom. Scoped by `source.ruby`.

![rubocop-auto-correct:current-file](https://cloud.githubusercontent.com/assets/18009/7369380/abc3a688-edec-11e4-9a44-58a1604c454d.gif)

## Require

* [rubocop](https://github.com/bbatsov/rubocop)

### Install

    $ gem install rubocop

## Usage

1. Run `Rubocop Auto Correct: Current File` in Command Palette
2. Select `Rubocop Auto-correct` in Context menu
3. Select [Packages] -> [Rubocop Auto-correct] -> [Current File] in menubar

## Setting

![rubocop-auto-correct setting panel](https://cloud.githubusercontent.com/assets/18009/7857284/35de545a-056a-11e5-8d56-18e324e040ca.png)

### Auto run

When checked, Automatically run Rubocop auto correct.

default value is 'false'

When you run `Rubocop Auto Correct: Toggle Auto Run` command, can change at any time.

### Rubocop command path

It is possible to set from the Packages Settings.

default value is 'rubocop'

### keymap example

Package doesn't provide keymap. If you want to use keybind, please setup `~/.atom/keymap.cson`

```coffee
'atom-text-editor[data-grammar~="ruby"]':
  'alt-r': 'rubocop-auto-correct:current-file'
```

## TODO

* [ ] apply buffer (not file)
* [ ] add spec

### Done

* [x] rubocop path setting in config
* [x] auto run
* [x] error handle
