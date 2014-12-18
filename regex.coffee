# Copyright 2014 Simon Lydell
# X11 (“MIT”) Licensed. (See LICENSE.)

# <http://es5.github.io/#A.1>

# Don’t worry, you don’t need to know CoffeeScript. It is only used for its
# readable regex syntax. Everything else is done in JavaScript in index.js.

module.exports = ///
  ( # <whitespace>
    \s+
  )
  |
  ( # <comment>
    //.*
  )
  |
  ( # <comment>
    /\*
    (?:
      [^*]
      |
      \*(?!/)
    )*
    ( \*/ )?
  )
  |
  ( # <string>
    ([ ' " ])
    (?:
      (?!\6) [^ \\ \r \n ]
      |
      \\(?: \r\n | [\s\S] )
    )*
    (\6)?
  )
  |
  ( # <regex>
    /
    # Cannot (and should not) start with a `*`, since `/*` comments are already matched at this point.
    (?:
      \[
      (?:
        [^ \] \\ \r \n ]
        |
        \\.
      )*
      \]
      |
      [^ / \] \\ \r \n ]
      |
      \\.
    )+
    /
    (?:
      (?!
        \s*
        (?:
          \b
          |
          [ \u0080-\uFFFF $ \\ ' " ~ ( { ]
          |
          [ + \- ! ](?!=)
          |
          \.?\d
        )
      )
      |
      [ g m i y ]{1,4} \b
      (?!
        [ \u0080-\uFFFF $ \\ ]
        |
        \s*
        (?:
          [ + \- * % & | ^ < > ! = ? ( { ]
          |
          /(?! [ / * ] )
        )
      )
    )
  )
  |
  ( # <number>
    -?
    (?:
      0[xX][ \d a-f A-F ]+
      |
      (?:
        \d*\.\d+
        |
        \d+\.? # Support one trailing dot for integers only.
      )
      (?: [eE][+-]?\d+ )?
    )
  )
  |
  ( # <name>
    # See <http://mathiasbynens.be/notes/javascript-identifiers>.
    (?:
      # Cannot (and should not) start with a digit, because numbers are already matched at this point.
      [ $ \w \u0080-\uFFFF ]
      |
      # Unicode escape sequence.
      \\u[ \d a-f A-F ]{4}
      |
      # ES6 unicode escape sequence.
      \\u\{[ \d a-f A-F ]{1,6}\}
    )+
  )
  |
  ( # <operator>
    # Word operators (such as `instanceof`) are matched as <name>s.
    -- | \+\+
    |
    && | \|\|
    |
    => # ES6 function arrow.
    |
    \.{3} # ES6 splat.
    |
    (?:
      [ + \- * / % & | ^ ]
      |
      <{1,2} | >{1,3}
      |
      !=? | ={1,2}
    )=?
    |
    [ ? : ~ ]
  )
  |
  ( # <punctuation>
    # A comma can also be an operator, but is matched as <punctuation> only.
    [ ; , . [ \] ( ) { } ]
  )
  |
  ( # <invalid>
    ^$ # Empty.
    |
    [\s\S] # Catch-all rule for anything not matched by the above.
  )
///g
