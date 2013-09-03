#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;


my %args;
getopts('s:n:hSq', \%args);

print "Minecraft Command, a command-line screen Minecraft\n"
    . "server administration tool.\n\n"
    . "Usage: $0 <arguments>\n"
    . "\t-h\t\t\tThis help screen.\n"
    . "\t-s <message>\t\tSay a message to the server.\n"
    . "\t-S\t\t\tSaves the server map.\n"
    . "\t-q <message>\t\tStops the server.\n"
    . "\t-n <screen name>\tThe screen name that Minecraft is running on\n"
    . "\t\t\t\t(Default is \"minecraft\")\n" and exit if defined $args{h};

print "use $0 -h for help...\n" and exit unless defined
    $args{s} or $args{S} or $args{q};

#defaults
my $screen = "minecraft";

#arguments
$screen = $args{n} if defined $args{n};

sub mine_send
{
    (my $message) = @_;
    system('screen -S ' . $screen . ' -p 0 -X stuff "'
	   . $message . "\r\"") if defined $message;
}

mine_send("say $args{s}") if defined $args{s} && print "Saying $args{s}...\n";
mine_send("save-all") if defined $args{S} && print "Saving server...\n";
mine_send("stop") if defined $args{q} && print "Stopping server...\n";
