#! /bin/sh
# RERANKDATA=ec50-connll-ic-s5
# RERANKDATA=ec50-f050902-lics5

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

MODELDIR="$SCRIPT_DIR/second-stage/models/ec50spfinal"
ESTIMATORNICKNAME=cvlm-l1c10P1
"$SCRIPT_DIR/first-stage/PARSE/parseIt" -l399 -N50 "$SCRIPT_DIR/first-stage/DATA/EN/" $* | "$SCRIPT_DIR/second-stage/programs/features/best-parses" -l "$MODELDIR/features.gz" "$MODELDIR/$ESTIMATORNICKNAME-weights.gz"
