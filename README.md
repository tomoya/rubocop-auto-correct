# rubocop-auto-correct package [![Build Status](https://travis-ci.org/tomoya/rubocop-auto-correct.svg?branch=master)](https://travis-ci.org/tomoya/rubocop-auto-correct)

Apply RuboCop auto-correct in Atom. Scoped by `source.ruby`.

![rubocop-auto-correct:current-file](https://cloud.githubusercontent.com/assets/18009/8393555/a35f1530-1d4f-11e5-9a5f-089927e54f38.gif)

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

![rubocop-auto-correct setting panel](https://cloud.githubusercontent.com/assets/18009/8393441/5636d7de-1d4a-11e5-9588-107a0eadb909.png)

### Auto Run

This package support auto run. When checked, Automatically run Rubocop auto correct. But, **It's to need activation**.

Activation method is to run manually `Rubocop Auto Correct: Current File` Once at Atom window.

- default value is `false`

When you run `Rubocop Auto Correct: Toggle Auto Run` command, can change at any time.

### Correct File

If you want to correct directly in the file, When checked. You don't need to save after corrected.

- default value is `false`

I recommend to enable Auto Run & Correct File. Then, really all files are corrected automatically.

### Notification

When checked off, Disable after corrected notification.

- default value is `true`

When you run `Rubocop Auto Correct: Toggle Notification` command, can change at any time.

### Rubocop Command Path

When you don't install rubocop yet, Run `gem install rubocop` first.

If you already installed rubocop, Please check package setting at `Rubocop Command Path`.

For example `~/.rbenv/shims/rubocop`.

- default value is `rubocop`

## Contributing

1. Fork it ( https://github.com/tomoya/rubocop-auto-correct/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
