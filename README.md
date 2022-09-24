## Overview
Harvesting metadata from your coding sessions.

This plugin maps autocommands to remote procedure calls. The calls include the
absolute path to the current buffer. The server uses that information to find
the file and extract some metadata.

The server and client resides in [this][1] repository.

## Requirements
For the plugin to work you need to do the following:

- Build the server and client binaries and place them somewhere in your $PATH.
- Make sure you have uuidgen installed and in your $PATH.

[1]: https://github.com/creativecreature/code-harvest
