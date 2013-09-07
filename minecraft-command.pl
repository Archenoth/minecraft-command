#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

##Defaults... Modify these as you see fit.
#The name of the screen to try to connect to.
my $screen = "minecraft";

my %args;
getopts('s:n:E:M:X:hSmq', \%args);

print "Minecraft Command, a command-line screen Minecraft server "
    . "administration tool.\n\n"
    . "Usage: $0 <arguments>\n"
    . "\t-h\t\t\tThis help screen.\n"
    . "\t-E <command>\t\tThe command to run in the event of an error.\n"
    . "\t-m\t\t\tDisplays server memory usage\n"
    . "\t-M <max memory (in KB)>\tThe process returns an error if the memory\n"
    . "\t\t\t\tusage is larger than the specified value, also\n"
    . "\t\t\t\truns a command specified by the -E parameter.\n"
    . "\t-s <message>\t\tSay a message to the server.\n"
    . "\t-S\t\t\tSaves the server map.\n"
    . "\t-q\t\t\tStops the server.\n"
    . "\t-X <command>\t\tSend a custom command to the screen session.\n"
    . "\t-n <screen name>\tThe screen name that Minecraft is running on\n"
    . "\t\t\t\t(Default is \"minecraft\")\n" and exit if defined $args{h};

print "Use $0 -h for help...\n" and exit unless defined
    $args{s} or $args{S} or $args{q} or $args{m} or $args{M} or $args{X};

#Arguments
$screen = $args{n} if defined $args{n};
my $errorcommand = $args{E} if defined $args{E};

sub mine_send
{
    (my $message) = @_;
    system('screen -S ' . $screen . ' -p 0 -X stuff "'
	   . $message . "\r\"") if defined $message;
}

sub check_mem
{
    foreach(`ps -C java -o rss,command`){
	return ($_ =~ /^(\d+)\s/)[0] if($_ =~ /minecraft/);
    }
    print "Cannot find process...\n";
    return 0;
}

print "Memory: " . check_mem() . "KB used...\n" if defined $args{m};
mine_send("say $args{s}") if defined $args{s} and print "Saying $args{s}...\n";
mine_send("save-all") if defined $args{S} and print "Saving server...\n";
mine_send("stop") if defined $args{q} and print "Stopping server...\n";
mine_send($args{X}) if defined $args{X} and print
    "Sending $args{X} to screen session...\n";

if(defined $args{M} and (check_mem() > $args{M})){
    return 1 unless defined $errorcommand;
    system($errorcommand);
}
