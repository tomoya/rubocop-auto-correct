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

## keymap example

This package doesn't provide default keymap.

If you want to use from keybind, please setup `~/.atom/keymap.cson`

```coffee
'atom-text-editor[data-grammar~="ruby"]':
  'alt-r': 'rubocop-auto-correct:current-file'
```

## Settings

![rubocop-auto-correct setting panel](https://cloud.githubusercontent.com/assets/18009/7906495/31e36f0c-0867-11e5-8184-0bed41927757.png)

### Auto Run

When checked, Automatically run Rubocop auto correct.

- default value is `false`

When you run `Rubocop Auto Correct: Toggle Auto Run` command, can change at any time.

### Notification

When checked off, Disable after corrected notification.

- default value is `true`

When you run `Rubocop Auto Correct: Toggle Notification` command, can change at any time.

### Rubocop Command Path

When you don't install rubocop yet, Run `gem install rubocop` first.

If you already installed rubocop, Please check package setting at `Rubocop Command Path`.

For example `~/.rbenv/shims/rubocop`.

- default value is `rubocop`

## TODO

* [ ] apply buffer (not file)

### Done

* [x] rubocop path setting in config
* [x] auto run
* [x] error handle
* [x] add spec
