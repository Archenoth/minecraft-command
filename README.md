minecraft-command
=================

An in-screen Minecraft administration tool.


This is a little Perl script to help in the automation of
administration of a GNU screened Minecraft instance.


Usage
-----

minecraft-command will accept any number of arguments, an will apply
their actions in the order specified by the in-script help list. (So,
if you say `./minecraft-command.pl -q -s "Shutting down server" -S`,
it will first say the message, then save the server, then quit it
because of the order of the arguments in the help list as shown below.)

If you call `./minecraft-command.pl -h`, it will give you the
following:


```
Usage: ./minecraft-command.pl <arguments>
        -h                      This help screen.
        -E <command>            The command to run in the event of an error.
        -m                      Displays server memory usage
        -M <max memory (in B)>  The process returns an error if the memory
                                usage is larger than the specified value, also
                                runs a command specified by the -E parameter.
        -s <message>            Say a message to the server.
        -S                      Saves the server map.
        -q                      Stops the server.
        -X <command>            Send a custom command to the screen session.
        -n <screen name>        The screen name that Minecraft is running on
                                (Default is "minecraft")
```

Below is a short description for each of the above arguments.

### -h: Help
This will show the above help screen... Nothing too complicated.

Example:
```
$ ./minecraft-command.pl -h
Minecraft Command, a command-line screen Minecraft server
administration tool.

Usage: ./minecraft-command.pl <arguments>
        -h                      This help screen.
        -E <command>            The command to run in the event of an error.
        -m                      Displays server memory usage
        -M <max memory (in B)>  The process returns an error if the memory
                                usage is larger than the specified value, also
                                runs a command specified by the -E parameter.
        -s <message>            Say a message to the server.
        -S                      Saves the server map.
        -q                      Stops the server.
        -X <command>            Send a custom command to the screen session.
        -n <screen name>        The screen name that Minecraft is running on
                                (Default is "minecraft")
$
```

### -E: Error command
The error command is a command that will run when a conditional error
occurs... Currently the command will only run when the memory
specified by -M is exceeded.

This command does nothing on it's own currently.

Example:
```
$ ./minecraft-command.pl -m
Memory: 339976B used...
$ ./minecraft-command.pl -M 300000 -E "echo The memory exceeds."
The memory exceeds.
$ ./minecraft-command.pl -M 400000 -E "echo The memory does not exceed."
$
```

### -m: Display memory usage
This argument displays the current memory usage of the server in bytes.

Example:
```
$ ./minecraft-command.pl -m
Memory: 339976B used...
$
```

### -M: Memory usage status and actions
This argument accepts a number, which will be the maximum amount of
bytes that the server can be using before either minecraft-command.pl
returns an error condition for use in shell scripting or the -E
commands will be run (If it is set.)

Example:
```
$ ./minecraft-command.pl -m
Memory: 339976B used...
$ ./minecraft-command.pl -M 400000 || echo hi
$ ./minecraft-command.pl -M 300000 || echo hi
hi
$
```

### -s: Says the message specified to the server.
This will send a message to the server to be shown to all players
currently on the server.

Example:
```
$ ./minecraft-command.pl -s "Hello all!"
$
```
This would send the message "Hello all" to the server for all to see.

### -S: Saves the server.
This argument will save the server by running save-all on the screen
session.

Example:
```
$ ./minecraft-command.pl -S
$
```
This would save the server.

### -q: Shuts down the server.
This will stop the server.

Example:
```
$ ./minecraft-command.pl -q
$
```
This would stop the server.

### -X: Sends a custom command to the screen session.
This will send a custom command to the screen session, useful for
either running a command to start the minecraft server on the screen
session if it isn't already or running commands on the server that
have not yet been implemented in this script.

Example:
```
$ ./minecraft-command.pl -X "java -jar miencraft-server.jar"
$
```
This would send the command to the screen session to start the
minecraft server.

```
$ ./minecraft-command.pl -X "say Hello"
$
```
And this would do the same thing as "`./minecraft-command.pl -s Hello`".

### -n: Names the screen session to connect to.
This argument will name the screen session that the script attempts to
connect to. The default is set the very top of minecraft-command.pl
(Which is usually "minecraft".). Use this if you wanna connect to a
minecraft server on a named screen session other than minecraft.

Example:
```
$ ./minecraft-command.pl -s "Hello all!" -n minecraftserver
$
```
This would send the message "Hello all!" for all to see on a minecraft
server hosted on a screen session called "minecraftserver" as opposed
to the default.
