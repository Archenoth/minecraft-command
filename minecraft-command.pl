#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

##Defaults... Modify these as you see fit.
#The name of the screen to try to connect to.
my $screen = "minecraft";

my %args;
getopts('c:s:n:E:M:X:hSCmq', \%args);

print "Minecraft Command, a command-line screen Minecraft server "
    . "administration tool.\n\n"
    . "Usage: $0 <arguments>\n"
    . "\t-h\t\t\tThis help screen.\n"
    . "\t-E <command>\t\tThe command to run in the event of an error.\n"
    . "\t-m\t\t\tDisplays server memory usage\n"
    . "\t-M <max memory (in B)>\tThe process returns an error if the memory\n"
    . "\t\t\t\tusage is larger than the specified value, also\n"
    . "\t\t\t\truns a command specified by the -E parameter.\n"
    . "\t-s <message>\t\tSay a message to the server.\n"
    . "\t-S\t\t\tSaves the server map.\n"
    . "\t-q\t\t\tStops the server.\n"
    . "\t-X <command>\t\tSend a custom command to the screen session.\n"
    . "\t-n <screen name>\tThe screen name that Minecraft is running on\n"
    . "\t\t\t\t(Default is \"$screen\")\n"
    . "\t-c <jarfile>\t\tCreates a screen server instance with the jar.\n"
    . "\t\t\t\t(Uses -n and -M for screen name and memory.)\n"
    . "\t-C\t\t\tCreates a screen instance. (Uses -n for name.)\n"
    and exit if defined $args{h};

print "Use $0 -h for help...\n" and exit unless defined
    $args{s} or $args{S} or $args{q} or $args{m} or $args{M} or
    $args{X} or $args{c} or $args{C};

#Arguments
$screen = $args{n} if defined $args{n};
my $errorcommand = $args{E} if defined $args{E};

#Creates a new server instance on a screen. Uses the -M max memory and the -n
#screen name for server settings.
#@paramater $jarfile <optional> The location of the jarfile to run as
#                    a server executable. If omitted, a screen
#                    instance is started without running anything on it.
sub create_instance
{
    (my $jarfile) = @_;
    print "Created " . (defined $jarfile?"server":"screen")
	. " instance on screen: $screen.\n"
	return system("screen -S $screen -d "
		      . (defined $jarfile?"-m java -jar $jarfile"
			 . (defined $args{M}?" -Xmx$args{M} -Xms$args{M}"
			    :"")
			 :""));
}

#Sends a message to the active screen session.
#@parameter $message Message to send.
sub mine_send
{
    (my $message) = @_;
    system('screen -S ' . $screen . ' -p 0 -X stuff "'
	   . $message . "\r\"") if defined $message;
}

#Gets the memory usage of the server (In Bytes)
sub get_mem
{
    foreach(`ps -C java -o rss,command`){
	return ($_ =~ /^(\d+)\s/)[0] if($_ =~ /minecraft/);
    }
    print "Cannot find process...\n";
    return 0;
}

#Checks to see if the memory exceeds the specified value
#@parameter $mem The maximum memory before failing.
sub check_mem
{
    (my $mem) = @_;
    if(get_mem() > $mem){
	system($errorcommand) if defined $errorcommand;
	return 1;
    }
    return 0;
}

create_instance($args{c}) if defined $args{c} or defined $args{C};
print "Memory: " . get_mem() . "B used...\n" if defined $args{m};
mine_send("say $args{s}") if defined $args{s} and print "Saying $args{s}...\n";
mine_send("save-all") if defined $args{S} and print "Saving server...\n";
mine_send("stop") if defined $args{q} and print "Stopping server...\n";
mine_send($args{X}) if defined $args{X} and print
    "Sending $args{X} to screen session...\n";
exit check_mem($args{M}) if defined $args{M} and not $args{c};
