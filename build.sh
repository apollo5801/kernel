#!/bin/sh
cd modules/vibetonz
make KDIR=../../
cd ../fm_si4709
make KDIR=../../
cd ../compcache
make KDIR=../../
cd ../overclock
make KDIR=../..

