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
  * Support installing from Cloudera and HDP Spark packages.

## Compatibility

The following platforms are currently tested:

* Ubuntu 12.04
* CentOS 6.5

The following platforms are not tested but will probably work (tests coming soon):

* Fedora 21
* Ubuntu 14.04

## Configuration

* `node['apache_spark']['install_mode']`: `tarball` to install from a downloaded tarball,
  or `package` to install from an OS-specific package.
* `node['apache_spark']['download_url']`: the URL to download Apache Spark binary distribution
  tarball in the `tarball` installation mode.
* `node['apache_spark']['checksum']`: SHA256 checksum for the Apache Spark binary distribution
  tarball.
* `node['apache_spark']['pkg_name']`: package name to install in the `package` installation mode.
* `node['apache_spark']['pkg_version']`: package version to install in the `package` installation
  mode.
* `node['apache_spark']['install_dir']`: target directory to install Spark to in the `tarball`
  installation mode. In the `package` mode, this must be set to the directory that the package
  installs Spark into.
* `node['apache_spark']['install_base_dir']`: in the `tarball` installation mode, this is where
  the tarball is actually extracted, and a symlink pointing to the subdirectory containing a
  specific Spark version is created at `node['apache_spark']['install_dir']`.
* `node['apache_spark']['user']`: UNIX user to create for running Spark.
* `node['apache_spark']['group']`: UNIX group to create for running Spark.
* `node['apache_spark']['standalone']['master_host']`: Spark standalone-mode workers will connect to
  this host.
* `node['apache_spark']['standalone']['master_bind_ip']`: the IP the master should bind to. This
  should be set in such a way that workers will be able to connect to the master.
* `node['apache_spark']['standalone']['master_port']`: the port for the Spark standalone master to
  listen on.
* `node['apache_spark']['standalone']['master_webui_port']`: Spark standalone master web UI port.
* `node['apache_spark']['standalone']['worker_bind_ip']`: the IP address workers bind to.
  They bind to all network interfaces by default.
* `node['apache_spark']['standalone']['worker_webui_port']`: the port for the Spark worker web UI
  to listen on.
* `node['apache_spark']['standalone']['job_dir_days_retained']`: `app-...` subdirectories of
  `node['apache_spark']['standalone']['worker_work_dir']` older than this number of days will be
  deleted periodically on worker nodes to prevent unbounded accumulation. These directories contain
  Spark executor stdout/stderr logs. The directories will still be retained to honor
  `node['apache_spark']['standalone']['job_dir_num_retained']`.
* `node['apache_spark']['standalone']['job_dir_num_retained']`: the minimum number of Spark
  executor log directories (`app-...`) to retain, regardless of creation time.
* `node['apache_spark']['standalone']['worker_dir_cleanup_log']`: log file path for the Spark
  executor log directories cleanup script.
* `node['apache_spark']['standalone']['worker_cores']`: the number of "cores" (threads) to allocate
  on each worker node.
* `node['apache_spark']['standalone']['worker_work_dir']`: the directory to store Spark
  executor logs and Spark job jars.
* `node['apache_spark']['standalone']['worker_memory_mb']`: the amount of memory in MB to allocate
  to each worker (i.e. the maximum total memory used by different applications' executors running
  on a worker node).
* `node['apache_spark']['standalone']['default_executor_mem_mb']`: the default amount of memory
  to be allocated to a Spark application's executor on each node.
* `node['apache_spark']['standalone']['log_dir']`: the log directory for Spark masters and workers.
* `node['apache_spark']['standalone']['daemon_root_logger']`: the `spark.root.logger` property
  is set to this.
* `node['apache_spark']['standalone']['max_num_open_files']`: the maximum number of open files to
  set using `ulimit` before launching a worker.
* `node['apache_spark']['standalone']['java_debug_enabled']`: whether Java debugging options are
  to be enabled for Spark processes. Note: currently, this option is not working as intended.
* `node['apache_spark']['standalone']['default_debug_port']`: default Java debug port to use.
  A free port is chosen if this port is unavailable.
* `node['apache_spark']['standalone']['master_debug_port']`: default Java debug port to use for
  Spark masters. A free port is chosen if this port is unavailable.
* `node['apache_spark']['standalone']['worker_debug_port']`: default Java debug port to use for
  Spark workers. A free port is chosen if this port is unavailable.
* `node['apache_spark']['standalone']['executor_debug_port']`: default Java debug port to use for
  Spark standalone executors. A free port is chosen if this port is unavailable.
* `node['apache_spark']['standalone']['common_extra_classpath_items']`: common classpath items to
  add to Spark application driver and executors (but not Spark master and worker processes).
* `node['apache_spark']['standalone']['worker_dir']`: Set to a non-nil value to tell the spark worker to use an alternate directory for spark scratch space
* `node['apache_spark']['standalone']['worker_opts']`: Set to a non-nil value to pass along any additional settings to the spark worker. E.G.: `-Dspark.worker.cleanup.enabled=true -Dspark.worker.cleanup.appDataTtl=86400`.  Ideal for worker options only that you do not want in the default configuration file.
* `node['apache_spark']['conf']['...']`: Spark configuration options that go into the default
  Spark configuration file. See https://spark.apache.org/docs/latest/configuration.html for details.
* `node['apache_spark']['standalone']['local_dirs']`: a list of local directories to use on workers.
  This is where map output files are stored, so these directories should have enough space
  available.

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
