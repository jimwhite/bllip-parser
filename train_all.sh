#!/bin/bash

BROWNTREEBANK=xtrain

if [ -d "$DIRECTORY" ]; then

echo "Doing self-training."

PENNWSJTREEBANK=/corpora/LDC/LDC99T42/RAW/parsed/mrg/wsj

mkdir tmp

XTRAIN=`echo $PENNWSJTREEBANK/0[2-9]/*mrg $PENNWSJTREEBANK/1[0-9]/*mrg $PENNWSJTREEBANK/2[0-1]/*mrg $BROWNTREEBANK/*01.mrg $BROWNTREEBANK/*[1-9][0-9].mrg $BROWNTREEBANK/*0[3-9].mrg`
echo $XTRAIN >tmp/train-all-files.txt
cat $XTRAIN >tmp/train-all.mrg 

XDEV=`echo $BROWNTREEBANK/*02.mrg`
echo $XDEV >tmp/dev-all-files.txt
cat $XDEV >tmp/dev-all.mrg

first-stage/TRAIN/allScript first-stage/DATA/EN tmp/train-all.mrg tmp/dev-all.mrg

echo allScript = $?
echo ===================

fi

echo make nbesttrain
make -j 50 nbesttrain
echo make nbesttrain = $?

echo ===================

echo make train-reranker
make train-reranker
echo train-reranker = $?

#echo ===================
#
#echo make eval-reranker
#make eval-reranker
#echo eval-reranker = $?
