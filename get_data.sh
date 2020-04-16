#!/bin/bash

ccfiles=(
    'crawl-data/CC-MAIN-2020-10/segments/1581875141396.22/robotstxt/CC-MAIN-20200216182139-20200216212139-00000.warc.gz'
    'crawl-data/CC-MAIN-2020-10/segments/1581875141396.22/wat/CC-MAIN-20200216182139-20200216212139-00000.warc.wat.gz'
    'crawl-data/CC-MAIN-2020-10/segments/1581875141396.22/wet/CC-MAIN-20200216182139-20200216212139-00000.warc.wet.gz'
    'crawl-data/CC-MAIN-2020-10/segments/1581875141396.22/warc/CC-MAIN-20200216182139-20200216212139-00000.warc.gz'
  );

for ccfile in ${ccfiles[@]}; do
  mkdir -p `dirname $ccfile`
  echo "Downloading `basename $ccfile` ..."
  echo "---"
  wget --no-clobber https://commoncrawl.s3.amazonaws.com/$ccfile -O $ccfile
done
