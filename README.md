# rubocop-auto-correct package [![Build Status](https://travis-ci.org/tomoya/rubocop-auto-correct.svg?branch=master)](https://travis-ci.org/tomoya/rubocop-auto-correct)

Auto-correct ruby source code by using rubocop in Atom.

![rubocop-auto-correct:current-file](https://cloud.githubusercontent.com/assets/18009/8393555/a35f1530-1d4f-11e5-9a5f-089927e54f38.gif)

## Prerequisites

You have [rubocop](https://github.com/bbatsov/rubocop) installed.

    $ gem install rubocop

## Usage

1. Run `Rubocop Auto Correct: Current File` from Command Palette
2. Select `Rubocop Auto-correct` in Context menu
3. Select [Packages] -> [Rubocop Auto-correct] -> [Current File] in menu bar

### Commands

| Name | Description |
| ---- | ----------- |
| `RUbocop Auto Correct: Current File` | Run rubocop auto-correct to current file |
| `RUbocop Auto Correct: Toggle Notification` | Toggle notification option |
| `RUbocop Auto Correct: Toggle Only Fixed Notification` | Toggle only fixes notification option |
| `RUbocop Auto Correct: Toggle Auto Run` | Toggle auto run option |
| `RUbocop Auto Correct: Toggle Debug Mode` | Toggle debug-mode option |

## Keymap example

This package does not provide default keymap.

If you want to use the commands from keybinding, please set up `~/.atom/keymap.cson` following the below:

```coffee
'atom-text-editor[data-grammar~="ruby"]':
  'alt-r': 'rubocop-auto-correct:current-file'
```

## Settings

![rubocop-auto-correct setting panel](https://cloud.githubusercontent.com/assets/18009/17727348/aa08a8d8-6493-11e6-9a14-7efc28d17315.png)

If you have a custom `.rubocop.yml`, this package will search it on project's root folder or on `$HOME/.rubocop.yml`

### Auto Run

This package supports auto-run. When checked, it runs Rubocop auto correct. But, **it does not run automatically unless you activate this package**.

You can activate it by running manually `Rubocop Auto Correct: Current File` once at Atom window.

- default value is `false`

You can enable/disable this option by `Rubocop Auto Correct: Toggle Auto Run` command at any time.

### Correct File

You can correct a file directly if you enable this option. You do not need to save file after correcting it.

- default value is `false`

I recommend you to enable `Auto Run` & `Correct File` options. Then, all files are corrected automatically.

### Notification

When this option is disabled, you do not receive any notifications even thought a file is corrected.

- default value is `true`

You can enable/disable this option by `Rubocop Auto Correct: Toggle Notification` command at any time.

### Only Fixes Notification

When this option is disabled, you will get all rubocop notifications appeared.

- default value is `true`

You can enable/disable this option by `Rubocop Auto Correct: Toggle Only Fixes Notification` command at any time.

### Rubocop Command Path

If you already installed rubocop, please check package setting at `Rubocop Command Path`. For example `~/.rbenv/shims/rubocop`.

If you want to set arguments, please set arguments with command at here. For example `rubocop --format simple`

- default value is `rubocop`

### Debug Mode

When this option is disabled, you can get log on console.

- default value is `false`

You can enable/disable this option by `Rubocop Auto Correct: Toggle Debug Mode` command at any time.

## Contributing

1. Fork it ( https://github.com/tomoya/rubocop-auto-correct/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
