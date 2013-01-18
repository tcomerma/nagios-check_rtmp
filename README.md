check_rtmp
================

nagios plugin for checking rtmp streams

It uses the rtmpdump (http://rtmpdump.mplayerhq.hu/) utility for connecting to an rtmp stream for some seconds
and determine if it's working or not.


AUTHOR: Toni Comerma
DATE: jan-2013

Notes:
  - The plugin leaves temporary files under /tmp
  - You should not run concurrent executions of this plugin for the same stream name (as they will share the same temporary file) and 
    results can be inacurate. No problem to check concurently diferent streams, of course.
  - The current is the first version, so test it and fork it.