# apache_spark

[![Build Status](https://travis-ci.org/clearstorydata-cookbooks/apache_spark.svg?branch=master)](https://travis-ci.org/clearstorydata-cookbooks/apache_spark)

This cookbook installs and configures Apache Spark.

* GitHub: https://github.com/clearstorydata-cookbooks/apache_spark
* Chef Supermarket: https://supermarket.chef.io/cookbooks/apache_spark
* Travis CI: https://travis-ci.org/clearstorydata-cookbooks/apache_spark
* Documentation: http://clearstorydata-cookbooks.github.io/apache_spark/chef/apache_spark.html

## Overview

This cookbook installs and configures Apache Spark. Currently, only the standalone deployment mode
is supported. Future work:

  * YARN and Mesos deployment modes
  * installs

## Configuration

* `node['apache_spark']['install_mode']` -- `tarball` to install from a downloaded tarball, 
  or `package` to install from an OS-specific package.

## Testing

### ChefSpec

```
bundle install
bundle exec rspec
```

### Test Kitchen

```
bundle install
bundle exec kitchen test
```

## Contributing

If you would like to contribute this cookbook's development, please follow the steps below:

* Fork this repository on GitHub
* Make your changes
* Run tests
* Submit a pull request

## License

Apache License 2.0

https://www.apache.org/licenses/LICENSE-2.0
