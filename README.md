## Running the code locally

First, you'll need to get the relevant demo data locally, which can be done by running `./get_data.sh`.

To run the jobs locally, you can simply run:

```
python page_analysis.py --conf-path mrjob.conf --no-output --output-dir output/ input/test.wat
```

## Running via Elastic MapReduce

To run the job on Amazon Elastic MapReduce (their automated Hadoop cluster offering), you need to add your AWS access key ID and AWS access key to `mrjob.conf`.
By default, the configuration file only launches two machines, both using spot instances to be cost effective. If you are running this for a full fledged job, you will likely want to make the master server a normal instance, as spot instances can disappear at any time.

Using option two as shown above, you can then run the script on EMR by running:

    python page_analysis.py -r emr --conf-path mrjob.conf --no-output --output-dir s3://commoncrawl-runner/out/ input/test.wat

this time reading 100 WARC files from Common Crawl's Public Data Set bucket `s3://commoncrawl/`. The output is written to S3 - do not forget to point the output (`s3://my-output-bucket/path/` is just a dummy) to a S3 bucket and path you have write permissions. The output directory must not exist!

## Running it over all of Common Crawl

To run your mrjob task over the entirety of the Common Crawl dataset, you can use the WARC, WAT, or WET file listings found at `CC-MAIN-YYYY-WW/[warc|wat|wet].paths.gz`. Data can be found [here](https://commoncrawl.org/the-data/get-started/).

It is highly recommended to run over batches of files at a time and then perform a secondary reduce over those results.
Running a single job over the entirety of the dataset complicates the situation substantially.
We also recommend having [N map jobs for the N files](https://groups.google.com/forum/#!topic/mrjob/o9t5FrgkMCs) you'll be attempting such that if there is a transient error, the minimal amount of work will be lost.

You'll also want to place your results in an S3 bucket instead of having them streamed back to your local machine.
For full details on this, refer to the mrjob documentation.

Note about locally buffering WARC/WAT/WET files: The default temp folder (set via hadoop.tmp.dir, default /tmp/) must be large enough to buffer content from S3 for all task running on a machine. You might point it explicitly to a directory on a volume large enough by passing `--s3_local_temp_dir=/path/to/tmp`.


chmod -R a+rwx .