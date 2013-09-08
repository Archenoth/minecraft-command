minecraft-command
=================

An in-screen Minecraft administration tool.

This script was designed to help in the automation of administration
of a GNU screen-based Minecraft server instances. It allows one to
interact with a detached screen with a vanilla minecraft-server.jar
running in it.

Usage
-----

minecraft-command will accept any number of arguments, and will apply
their actions in the order specified by the in-script help list. (So,
if you say `./minecraft-command.pl -q -s "Shutting down server" -S`,
it will first say the message, then save the server, then quit because
of the order of the arguments in the help list that is displayed when
typing "`./minecraft-command.pl -h`".)

### Parameters
Below is a short description for each of the available arguments.

#### -h: Help
This will show the script help screen with brief information about all
of the possible command line arguments.

Example:
```
$ ./minecraft-command.pl -h
Minecraft Command, a command-line screen Minecraft server administration tool.

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
        -c <jarfile>            Creates a screen server instance with the jar.
                                (Uses -n and -M for screen name and memory.)
        -C                      Creates a screen instance. (Uses -n for name.)
$
```

#### -E: Error command
The error command is a command that will run only when a parameter
conditional fails... Currently the command will only run when the memory
specified by "`-M`" is exceeded, but this is soon to be expanded.

This command does nothing on it's own, so it is an error to run it on
it's own.

Example:
```
$ ./minecraft-command.pl -m
Memory: 339976B used...
$ ./minecraft-command.pl -M 300000 -E "echo The memory exceeds."
The memory exceeds.
$ ./minecraft-command.pl -M 400000 -E "echo The memory does not exceed."
$
```

#### -m: Display memory usage
This argument displays the current memory usage of the server in bytes.

Example:
```
$ ./minecraft-command.pl -m
Memory: 339976B used...
$
```

#### -M: Memory usage status and actions
This argument accepts a number, which will be the maximum amount of
bytes that the server can be using before either minecraft-command.pl
returns an error status for use in shell scripting or the "`-E`" command(s)
will be run (If it is set.)

Example:
```
$ ./minecraft-command.pl -m
Memory: 339976B used...
$ ./minecraft-command.pl -M 400000 || echo hi
$ ./minecraft-command.pl -M 300000 || echo hi
hi
$
```

#### -s: Says the message specified to the server.
This will send a message to the server to be shown to all online
players.

Example:
```
$ ./minecraft-command.pl -s "Hello all!"
Saying Hello all!...
$
```
This would send the message "Hello all" to the server for all to see.

#### -S: Saves the server.
This argument will save the server by running "`save-all`" on the screen
session.

Example:
```
$ ./minecraft-command.pl -S
Saving server...
$
```
This would save the server.

#### -q: Shuts down the server.
This will stop the server by sending "`stop`" to the screen session.

Example:
```
$ ./minecraft-command.pl -q
Stopping server...
$
```
This would stop the server.

#### -X: Sends a custom command to the screen session.
This will send a custom command to the screen session, useful for
either running a commands on the screen session if a minecraft server
isn't running on it at the time or running commands on the server that
have not yet been implemented in this script.

Example:
```
$ ./minecraft-command.pl -X "java -jar minecraft-server.jar"
$
```
This would send the command to the screen session to start the
minecraft server.

```
$ ./minecraft-command.pl -X "say Hello"
$
```
And this would do the same thing as "`./minecraft-command.pl -s Hello`".

#### -n: Names the screen session to connect to.
This argument will name the screen session that the script attempts to
connect to. The default is set the very top of minecraft-command.pl
(Which is usually "minecraft".). Use this if you wanna connect to a
minecraft server on a named screen session other than minecraft.

Example:
```
$ ./minecraft-command.pl -s "Hello all!" -n minecraftserver
Saying Hello all!...
$
```
This would send the message "Hello all!" for all to see on a minecraft
server hosted on a screen session called "minecraftserver" as opposed
to the default.

#### -c: Create a new server instance
This command will create a new server instance inside of a named
screen. It will accept parameters for -n and -M to name the screen
that the new server will be run in, and the amount of memory to
give to the JVM, respectively. Running it on its own will use the
default screen name ("minecraft", which is defined at the top of
minecraft-command.pl.)

This parameter requires the location of the jar file it will use.

If you wanna get more creative, you can just create a new screen with
"`-C`" and then use "`-X`" to do whatever you need to it.

Example:
```
$ ./minecraft-command.pl -c /minecraft/minecraft_server.jar
Created server instance on screen: minecraft.
```

This is the most basic way to invoke this parameter. It will create a
server on a new screen with the default name. This means you could
communicate with it right away using the other `minecraft-command.pl`
parameters.

Or if you wanna specify the memory usage and screen name.
```
$ ./minecraft-command.pl -c /minecraft/minecraft_server.jar -M1024M -n derp
Created server instance on screen: derp.
```

This would start a Minecraft server with the screen name "derp" with
1024MB allocated memory. You would need to further use "`-n derp`" to
talk to this server with `minecraft-command.pl`.

If you're curious, this would run the command "`screen -S derp -d -m java -jar /minecraft/minecraft_server.jar -Xmx1024M -Xms1024M`".

#### -C: Create new screen
This will create a new screen and not do anything with it... You will
be able to interact with it using the "`-X`" command and after a
server is started, you can work with it normally.

Example:
```
$ ./minecraft-command.pl -C
Created screen instance on screen: minecraft.
$
```
This is just a vanilla screen that you can do whatever you want
with... And sine it is the default name, you can interact with it
using "`-X <command>`" without the need for "`-n`" But if you want to
run a separate screen, you can specify the name on screen creation
with the "`-n <name>`" parameter.

```
$ ./minecraft-command.pl -C -n derp
Created screen instance on screen: minecraft.
$
```
This would create a new screen that can be interacted with
"`./minecraft-command.pl -n derp <Whatever>`".
