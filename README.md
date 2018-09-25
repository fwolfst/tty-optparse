# Goal

Provide a sane method of configuring a tool either via command line options (`tool --option 2`) and/or a configuration file.
Options provided via command line take precedence over options specified in the configuration file.

This is an example for `tty-config` in combination with Ruby `optparse` stdlib, orginally for piotrmurach/tty-config#1 .


```sh
$ ./tty-optparse
No configuration file found.
Need to specify at least host and port (call with --help to find out how).
```

```sh
$ ./tty-optparse --host localhost --port 8811
No configuration file found.
Connect to user@localhost:8811
```

```sh
$ cat ~/.tty-optparse.conf
host: 127.0.0.1
port: 7711
$ ./tty-optparse
Connect to user@127.0.0.1:7711
```

```sh
$ cat ~/.tty-optparse.conf
host: 127.0.0.1
port: 7711
$ ./tty-optparse --host localhost
Connect to user@localhost:7711
```
