#!/usr/bin/perl

# Copyright 2018 Michael Schlenstedt, michael@loxberry.de
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


##########################################################################
# Modules
##########################################################################

use LoxBerry::System;
use LoxBerry::Web;
use CGI;
#use Config::Simple;
use warnings;
use strict;

##########################################################################
# Variables
##########################################################################

##########################################################################
# Read Settings
##########################################################################

# Version of this script
my $version = "0.0.1";

#$cfg = new Config::Simple("$lbhomedir/config/system/general.cfg");

##########################################################################
# Main program
##########################################################################

# Get CGI
our $cgi = CGI->new;

my $maintemplate = HTML::Template->new(
                filename => "$lbptemplatedir/settings.html",
                global_vars => 1,
                loop_context_vars => 1,
                die_on_bad_params=> 0,
                #associate => $cfg,
                # debug => 1,
                );

my %L = LoxBerry::System::readlanguage($maintemplate, "language.ini");

# Actions to perform
if ( param('do') ) { 
	$do = quotemeta( param('do') ); 
	if ( $do eq "start") {
		system ("$lbpbindir/lms_wrapper.sh start");
	}
	if ( $do eq "stop") {
		system ("$lbpbindir/lms_wrapper.sh stop");
	}
	if ( $do eq "restart") {
		system ("$lbpbindir/lms_wrapper.sh restart");
	}
	if ( $do eq "enable") {
		system ("$lbpbindir/lms_wrapper.sh enable");
	}
	if ( $do eq "disable") {
		system ("$lbpbindir/lms_wrapper.sh disable");
	}
}

# Check current state
my $state;
qx ( systemctl is-active logitechmediaserver );
if ($? eq 0) {
	my $pid = qx ( cat /var/run/logitechmediaserver.pid );
	chomp $pid;
	$state = "Active. PID is: $pid";
} else {
	$state = "Not active";
}
$maintemplate->param( STATE => $state);

# Check boot state
my $bootstate;
qx ( systemctl is-enabled logitechmediaserver );
if ($? eq 0) {
	$bootstate = "Enabled";
} else {
	$bootstate = "Disabled";
}
$maintemplate->param( BOOTSTATE => $bootstate);

# Navbar
our $host = "$ENV{HTTP_HOST}";
our $port = qx ( cat /var/lib/squeezeboxserver/prefs/server.prefs | grep -e '^httpport' | awk -F ': ' '{ print \$2 }' );

our %navbar;
$navbar{1}{Name} = "$L{'SETTINGS.LABEL_LMS'}";
$navbar{1}{URL} = "http://$host:$port";
$navbar{1}{target} = '_blank';

$navbar{2}{Name} = "$L{'SETTINGS.LABEL_LMS_SETTINGS'}";
$navbar{2}{URL} = "http://$host:$port/settings/index.html";
$navbar{2}{target} = '_blank';

# Print Template
LoxBerry::Web::lbheader("LMS for LoxBerry", "http://www.loxwiki.eu:80");
print $maintemplate->output;
LoxBerry::Web::lbfooter();

exit;

