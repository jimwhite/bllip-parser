#! /bin/sh
#
# Parses a section of treebank and evaluates the parser output using evalb
#
# Should be called with the treebank source files as an argument

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

"$SCRIPT_DIR/second-stage/programs/prepare-data/ptb" -c $* | "$SCRIPT_DIR/parse.sh" -K > parse-trees.tmp
"$SCRIPT_DIR/second-stage/programs/prepare-data/ptb" -e $* > gold-trees.tmp
"$SCRIPT_DIR/evalb/evalb" -p "$SCRIPT_DIR/evalb/new.prm" gold-trees.tmp parse-trees.tmp
rm parse-trees.tmp gold-trees.tmp
