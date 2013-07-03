#!/bin/bash

PARSER_TRAINING_DIR=xtrain
PARSER_TUNING_DIR=xtune

PENNWSJTREEBANK=notused

if [ ! -d "$PARSER_TRAINING_DIR" ]; then

echo "Where's the per-parser data (xtrain)?."

exit 111

fi

XTRAIN=`echo $PARSER_TRAINING_DIR/*.mrg`

XDEV=`echo $PARSER_TUNING_DIR/*.mrg`

make reranker

echo make nbesttrain
make -j 50 nbesttrain
result = $?

echo make nbesttrain = $?

if [ $result == 0 ]; then

echo ===================

echo make train-reranker
make -j 1 train-reranker
result = $?

echo train-reranker = $result

fi

#echo ===================
#
#echo make eval-reranker
#make eval-reranker
#echo eval-reranker = $?
