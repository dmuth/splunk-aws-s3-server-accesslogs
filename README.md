

# Splunk for AWS S3 Server Access Logs

This an app I built using <a href="https://github.com/dmuth/splunk-lab">Splunk Lab</a>
to extract data from AWS S3 Server Access Logs and use that data for graphs and analysis.

<a href="img/aws-s3-bucket-report.png"><img src="img/aws-s3-bucket-report.png" width="400" /></a>
<a href="img/top-bucket-objects.png"><img src="img/top-bucket-objects.png" width="400" /></a>


## Getting your AWS S3 Server Access Logs

You'll need to <a href="https://docs.aws.amazon.com/AmazonS3/latest/dev/ServerLogs.html">configure Server Access Logging in AWS S3</a>. Once that's done, you can either
pull down many small logfiles directly, or instead perform daily rollup on them
<a href="https://github.com/dmuth/aws-s3-server-access-logging-rollup">with an AWS S3 Rollup app</a> which I built specifically for this purpose.

Either way, you can use the `aws` CLI app to download all of your logs into `logs/` 
directory and then concatenate the contents of each directory into a single file for that bucket with something like this:

- `aws s3 sync s3://my-accesslogs/rollup-day/ logs`
- `cd logs/`
- `for DIR in $(find . -type d); do cat $DIR/* > $DIR.txt; done`
- `for DIR in $(find . -type d); do rm -rfv $DIR/* > $DIR.txt; done`

Naturally, this is highly dependent on how you're storing logs.


## Starting up Splunk Lab

Next, start up Splunk Lab with this command:

- `bash <(curl -s https://raw.githubusercontent.com/dmuth/splunk-aws-s3-server-accesslogs/master/go.sh)`

The script will guide you through various settings you can send to Splunk Lab.

From there, you can go to <a href="https://localhost:8000/">https://localhost:8000</a>,
log into Splunk with the credentials you specified when starting it, and you should be
able to search for data or view reports in dashbaords.


## Known Issues


### Q: I see an error about exceeding "the configured depth_limit"?

A: You'll need to increase that value in `app/limits.conf`. You can <a href="https://answers.splunk.com/answers/661864/regex-data-parsing-using-delimiter-comma-has-excee.html">read more about that here</a>.


## Development

- `./bin/devel.sh splunk`
- `./bin/build.sh`
- `./bin/push.sh`


## Additional Resources

- <a href="https://docs.aws.amazon.com/AmazonS3/latest/dev/LogFormat.html">AWS S3 Server Access Log Format</a>


## Credits

- <a href="http://patorjk.com/software/taag/#p=display&h=0&v=0&f=Standard&t=Splunk%20%0AAWS%20S3%20Logs">This ASCII Text Generator</a>
- <a href="http://www.splunk.com/">Splunk</a> - For having a fantastic analytics platform


## Bugs/Contact

Here's how to get in touch with me:

- <a href="http://twitter.com/dmuth">Twitter</a>
- <a href="http://facebook.com/dmuth">Facebook</a>
- <a href="http://www.dmuth.org/">Blog</a>
- <a href="mailto:doug.muth@gmail.com">Email</a>


