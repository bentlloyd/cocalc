# Loading and configuring the codemirror editor

window.CodeMirror = CodeMirror = require('codemirror')


require('codemirror/addon/mode/overlay.js')
require('codemirror/addon/selection/active-line.js')
require('codemirror/addon/comment/comment.js')

require('codemirror/addon/dialog/dialog.js')
require('codemirror/addon/dialog/dialog.css')

require('codemirror/addon/search/searchcursor.js')

require('codemirror/addon/edit/matchbrackets.js')
require('codemirror/addon/edit/closebrackets.js')
require('codemirror/addon/edit/trailingspace.js')
require('codemirror/addon/edit/continuelist.js')
require('codemirror/addon/edit/matchtags.js')
require('codemirror/addon/edit/closetag.js')
require('codemirror/addon/wrap/hardwrap.js')
require('codemirror/addon/runmode/runmode.js')
require('codemirror/addon/fold/brace-fold.js')
require('codemirror/addon/fold/foldcode.js')
require('codemirror/addon/fold/foldgutter.js')
require('codemirror/addon/fold/foldgutter.css')

require('codemirror/addon/fold/markdown-fold.js')
require('codemirror/addon/fold/comment-fold.js')
require('codemirror/addon/fold/indent-fold.js')
require('codemirror/addon/fold/xml-fold.js')
require('codemirror/addon/hint/anyword-hint.js')
require('codemirror/addon/hint/css-hint.js')
require('codemirror/addon/hint/html-hint.js')
require('codemirror/addon/hint/javascript-hint.js')

require('codemirror/addon/hint/show-hint.js')
require('codemirror/addon/hint/show-hint.css')

require('codemirror/addon/hint/sql-hint.js')
require('codemirror/addon/hint/xml-hint.js')

require('./modes')

# Keyboard bindings
require('codemirror/keymap/vim.js')
require('codemirror/keymap/emacs.js')
require('codemirror/keymap/sublime.js')

# For some reason python-hint.js got removed from codemirror itself
require('./addon/hint/python-hint.js')

require('./addon/smc-search.js')



# CSS

require('codemirror/lib/codemirror.css')
require('codemirror/theme/solarized.css')
require('codemirror/theme/twilight.css')
require('codemirror/theme/vibrant-ink.css')
require('codemirror/theme/night.css')
require('codemirror/theme/cobalt.css')
require('codemirror/theme/neat.css')
require('codemirror/theme/erlang-dark.css')
require('codemirror/theme/lesser-dark.css')
require('codemirror/theme/elegant.css')
require('codemirror/theme/monokai.css')
require('codemirror/theme/ambiance-mobile.css')
require('codemirror/theme/ambiance.css')
require('codemirror/theme/rubyblue.css')
require('codemirror/theme/blackboard.css')
require('codemirror/theme/xq-dark.css')
require('codemirror/theme/eclipse.css')
require('codemirror/theme/3024-day.css')
require('codemirror/theme/3024-night.css')
require('codemirror/theme/base16-light.css')
require('codemirror/theme/base16-dark.css')
require('codemirror/theme/the-matrix.css')
require('codemirror/theme/paraiso-dark.css')
require('codemirror/theme/paraiso-light.css')
require('codemirror/theme/tomorrow-night-eighties.css')

require('./mode/mediawiki/mediawiki.css')
