# Directory tree

Here is my example `/etc`:

    /
    |-- bin
    |-- doc
    `-- etc
        |-- init
        |   `-- osx
        |       `-- app
        |-- libs
        |-- rc
        `-- scripts

## etc/init/

This `init` directory has configuration files that is executed by the `Makefile`.

### etc/init/osx/

OS X only

## etc/libs/

Library files of shell script has been saved.

## etc/scripts/

Shell script that did not become a command has been saved.
(btw, the commands has been stored in the `/bin` directory.)

vim: ft=markdown
