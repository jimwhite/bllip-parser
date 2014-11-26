#!/bin/bash

PARSER_TRAINING_DIR=xtrain
PARSER_TUNING_DIR=xtune

PENNWSJTREEBANK=/corpora/LDC/LDC99T42/RAW/parsed/mrg/wsj

if [ -d "$PARSER_TRAINING_DIR" ]; then

echo "Training with per-parser data."

mkdir tmp

#XTRAIN=`echo $PENNWSJTREEBANK/0[2-9]/*mrg $PENNWSJTREEBANK/1[0-9]/*mrg $PENNWSJTREEBANK/2[0-1]/*mrg $BROWNTREEBANK/*01.mrg $BROWNTREEBANK/*[1-9][0-9].mrg $BROWNTREEBANK/*0[3-9].mrg`
#XTRAIN=`echo $PENNWSJTREEBANK/0[2-9]/*mrg $PENNWSJTREEBANK/1[0-9]/*mrg $PENNWSJTREEBANK/2[0-1]/*mrg $BROWNTREEBANK/*.mrg`

XTRAIN=`echo $PARSER_TRAINING_DIR/*.mrg`
echo $XTRAIN >tmp/train-all-files.txt
cat $XTRAIN >tmp/train-all.mrg 


if [ -d "$PARSER_TUNING_DIR" ]; then
XDEV=`echo $PARSER_TUNING_DIR/*.mrg`
else
#XDEV=`echo $BROWNTREEBANK/*02.mrg`
XDEV=`echo $PENNWSJTREEBANK/24/*.mrg`
fi

echo $XDEV >tmp/dev-all-files.txt
cat $XDEV >tmp/dev-all.mrg

make reranker

# This model is used to parse the SECTIONS list (23 23 24) of WSJ.
# What do we need it for?  It's still here because they get passed to the feature extractor.
# See Makefile lines 478 ~ 516.  I need to figure out what that's for and I'm supposed to configure it.
first-stage/TRAIN/allScript first-stage/DATA/EN tmp/train-all.mrg tmp/dev-all.mrg

echo allScript = $?
echo ===================

fi

echo make nbesttrain
make -j 50 nbesttrain
echo make nbesttrain = $?

echo ===================

echo make train-reranker
make -j 1 train-reranker
echo train-reranker = $?

#echo ===================
#
#echo make eval-reranker
#make eval-reranker
#echo eval-reranker = $?
