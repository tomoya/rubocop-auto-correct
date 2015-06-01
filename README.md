# rubocop-auto-correct package [![Build Status](https://travis-ci.org/tomoya/rubocop-auto-correct.svg?branch=master)](https://travis-ci.org/tomoya/rubocop-auto-correct)

Apply RuboCop auto-correct in Atom. Scoped by `source.ruby`.

![rubocop-auto-correct:current-file](https://cloud.githubusercontent.com/assets/18009/7874437/9f40b20a-05ea-11e5-8822-229c8f79abe4.gif)

## Require

* [rubocop](https://github.com/bbatsov/rubocop)

### Install

    $ gem install rubocop

## Usage

1. Run `Rubocop Auto Correct: Current File` in Command Palette
2. Select `Rubocop Auto-correct` in Context menu
3. Select [Packages] -> [Rubocop Auto-correct] -> [Current File] in menubar

## Setting

![rubocop-auto-correct setting panel](https://cloud.githubusercontent.com/assets/18009/7906495/31e36f0c-0867-11e5-8184-0bed41927757.png)

### Auto run

When checked, Automatically run Rubocop auto correct.

default value is 'false'

When you run `Rubocop Auto Correct: Toggle Auto Run` command, can change at any time.

### Notification

When checked off, disable after corrected notification

default value is 'true'

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
