# Rainbow brackets plugin for Kakoune

This plugin provides rainbow brackets highlighting

## Installation

Clone the repository into the autoload directory or if you use
[plug.kak](https://github.com/andreyorst/plug.kak), just put this into
your kakrc:

```
plug "listentolist/kakoune-rainbow" domain "gitlab.com" config %{
    require-module rainbow
    # suggested mapping
    # map global user r ": rainbow<ret>" -docstring "rainbow brackets"
    # map global user R ": rmhl window/ranges_rainbow_specs<ret>" \
    #     -docstring "remove rainbow highlighter"
}
```

You need to have [GNU Guile](https://www.gnu.org/software/guile/) and the
[connect.kak](https://github.com/alexherbo2/connect.kak) plugin installed.

## Commands

- `rainbow`
 
## Options

- `rainbow_colors`
- `rainbow_opening`, default: `'(' '[' '{'`
- `rainbow_closing`, default: `')' ']' '}'`
- `rainbow_regex`, regex for matching the brackets; default: `'(?<!#\\)[{}\[\]()]'`
- regexes that should be excluded:
    * `rainbow_string`, default: `'(?<!#\\)"([^"]|\\")*(?<!\\)"'`
    * `rainbow_comment_line`, default `'(?<!#\\);[^\n]*'`
    * `rainbow_comment_block`, default `''`
- options used for creating the range-specs for highlighting 
    * `rainbow_specs`
    * `rainbow_selections`
    * `rainbow_ranges`

## Usage

Just run `rainbow`. The default configuration is designed for scheme
code. But you can change the options for other filetypes.
