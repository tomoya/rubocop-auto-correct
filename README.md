# rubocop-auto-correct package

Apply RuboCop auto-crrect in Atom

![rubocop-auto-correct:current-file](https://cloud.githubusercontent.com/assets/18009/7368984/a1853f96-ede8-11e4-8516-1997bc061ca5.gif)

## Require

* [rubocop](https://github.com/bbatsov/rubocop)

### Install

    $ gem install rubocop

## Usage

1. Run `Rubocop Auto Correct: Current File` in Command Palette
2. Context menu `Rubocop Auto-correct`
3. Packages -> Rubocop Auto-correct -> Current File in menubar

## keymap example

```coffee
'atom-text-editor[data-grammar~="ruby"]':
  'alt-r': 'rubocop-auto-correct:current-file'
```

## TODO

* apply buffer (not file)
* auto run
* rubocop path setting in config
