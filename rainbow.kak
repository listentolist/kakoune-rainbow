declare-option -hidden str rainbow_path %sh{dirname "$kak_source"}

provide-module rainbow %§

require-module connect

# list of colors ordered by level
declare-option str-list rainbow_colors 'red' 'green' 'yellow' 'blue' \
  'magenta' 'cyan' 'bright-red' 'bright-green' 'bright-yellow' \
  'bright-blue' 'bright-magenta' 'bright-cyan'

declare-option str-list rainbow_opening '(' '[' '{'
declare-option str-list rainbow_closing ')' ']' '}'
# the regex that should be colorized
declare-option str rainbow_regex '(?<!#\\)[{}\[\]()]'
# regexes that should be excluded
declare-option str rainbow_string '(?<!#\\)"([^"]|\\")*(?<!\\)"'
declare-option str rainbow_comment_line '(?<!#\\);[^\n]*'
declare-option str rainbow_comment_block

# options used for creating the range-specs for highlighting 
declare-option -hidden range-specs rainbow_specs
declare-option -hidden str-list rainbow_selections
declare-option -hidden str-list rainbow_ranges

define-command -override rainbow %{
  evaluate-commands -draft %{
    try %{
      add-highlighter window/ ranges rainbow_specs
    }
    try %{
      # select from 20 lines below the current view to the buffer top
      # for identifying the level of the brackets
      execute-keys 'gb20x;Gk'
      # exclude strings and comments
      execute-keys 'S' %opt{rainbow_string} '|' \
        %opt{rainbow_comment_line} '<ret>'
      # select the brackets
      execute-keys 's' %opt{rainbow_regex} '<ret>)'
      set-option buffer rainbow_selections %val{selections}
      set-option buffer rainbow_ranges %val{selections_desc}
    } catch %{
      set-option buffer rainbow_selections ''
      set-option buffer rainbow_ranges ''
    }
  }
  # the program for creating the range-specs is run in the background
  connect-shell sh -c %{
    rainbow_selections="$(:get %opt{rainbow_selections})"
    rainbow_ranges="$(:get %opt{rainbow_ranges})"
    :send set-option window rainbow_specs "$5" \
      $(printf "%s\n%s\n%s\n%s\n%s\n%s" \
        "$rainbow_selections" "$rainbow_ranges" "$1" "$2" "$3" | "$4")
  } -- "%opt{rainbow_colors}" "%opt{rainbow_opening}" "%opt{rainbow_closing}" \
       "%opt{rainbow_path}/bin/kak-rainbow.scm" "%val{timestamp}"
}

# filetype specific hooks

hook -group rainbow global WinSetOption filetype=scheme %{
    set-option buffer rainbow_string '(?<!#\\)"([^"]|\\")*(?<!\\)"'
    set-option buffer rainbow_comment_line '(?<!#\\);[^\n]*'
    set-option buffer rainbow_opening '(' '[' '{'
    set-option buffer rainbow_closing ')' ']' '}'
    set-option buffer rainbow_regex '(?<!#\\)[{}\[\]()]'
}

§
