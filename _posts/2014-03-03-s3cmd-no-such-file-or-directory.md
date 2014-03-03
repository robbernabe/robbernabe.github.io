---
layout: post
title: "s3cmd: No such file or directory"
date: 2014-03-03T16:37:58-05:00
updated: 2014-03-03T16:37:58-05:00
tags:
  - debug logs
  - s3cmd
  - gpg
---

If you've ever used [s3cmd](http://s3tools.org/s3cmd) and are using encryption support,
then you might run into this problem when uploading a file to s3:

    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        An unexpected error has occurred.
      Please report the following lines to:
       s3tools-bugs@lists.sourceforge.net
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    Problem: OSError: [Errno 2] No such file or directory
    S3cmd:   1.0.1

    Traceback (most recent call last):
      File "/usr/local/bin/s3cmd", line 2006, in <module>
        main()
      File "/usr/local/bin/s3cmd", line 1950, in main
        cmd_func(args)
      File "/usr/local/bin/s3cmd", line 372, in cmd_object_put
        exitcode, full_name, extra_headers["x-amz-meta-s3tools-gpgenc"] = gpg_encrypt(full_name_orig)
      File "/usr/local/bin/s3cmd", line 1420, in gpg_encrypt
        code = gpg_command(command, cfg.gpg_passphrase)
      File "/usr/local/bin/s3cmd", line 1402, in gpg_command
        p = subprocess.Popen(command, stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.STDOUT)
      File "/usr/local/Cellar/python/2.7.6/Frameworks/Python.framework/Versions/2.7/lib/python2.7/subprocess.py", line 709, in __init__
        errread, errwrite)
      File "/usr/local/Cellar/python/2.7.6/Frameworks/Python.framework/Versions/2.7/lib/python2.7/subprocess.py", line 1326, in _execute_child
        raise child_exception
    OSError: [Errno 2] No such file or directory

    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        An unexpected error has occurred.
        Please report the above lines to:
       s3tools-bugs@lists.sourceforge.net
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

The problem was that s3cmd was looking for gpg in the wrong location:

    rbernabe ~ $ grep gpg .s3cfg
    gpg_command = /usr/bin/gpg

On my local Mac the gpg binary was in /usr/local/bin:

    rbernabe ~ $ which gpg
    /usr/local/bin/gpg

Updating the line `gpg_command` in the .s3cfg file accordingly fixed the error.
