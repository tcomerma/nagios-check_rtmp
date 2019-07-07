check_rtmp
================

nagios plugin for checking rtmp streams

It uses the rtmpdump (http://rtmpdump.mplayerhq.hu/) utility for connecting to an rtmp stream for some seconds
and determine if it's working or not.


## Usage

Copy file `check_rtmp.sh` to `${nagios_home}/libexec/check_rtmp.sh`

Add command to `${nagios_home}/etc/objects/commands.cfg`

```
define command{
  command_name    check_rtmp
  command_line    $USER1$/check_rtmp.sh $ARG1$
}

```

In service (`${nagios_home}/etc/server/services.cfg`)

```
define service {
  ...
  check_command check_rtmp! -u <url> -t <timeout>
}
```

AUTHOR: Toni Comerma
DATE: jan-2013

Notes:
  - The plugin leaves temporary files under /tmp
  - You should not run concurrent executions of this plugin for the same stream name (as they will share the same temporary file) and 
    results can be inacurate. No problem to check concurently diferent streams, of course.
  - The current is the first version, so test it and fork it.