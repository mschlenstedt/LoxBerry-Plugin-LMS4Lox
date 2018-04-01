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
use LoxBerry::Storage;
use LoxBerry::Web;
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
my $cgi = CGI->new;

my $maintemplate = HTML::Template->new(
                filename => "$lbptemplatedir/settings.html",
                global_vars => 1,
                loop_context_vars => 1,
                die_on_bad_params=> 0,
                #associate => $cfg,
                # debug => 1,
                );

my %L = LoxBerry::System::readlanguage($maintemplate, "language.ini");

# Should Fhem Server be started
#if ( param('do') ) { 
#	$do = quotemeta( param('do') ); 
#	if ( $do eq "start") {
#		system ("$installfolder/system/daemons/plugins/$psubfolder start");
#	}
#	if ( $do eq "stop") {
#		system ("$installfolder/system/daemons/plugins/$psubfolder stop");
#	}
#	if ( $do eq "restart") {
#		system ("$installfolder/system/daemons/plugins/$psubfolder restart");
#	}
#}

# Print Template
LoxBerry::Web::lbheader("LMS for LoxBerry", "http://www.loxwiki.eu:80");
print $maintemplate->output;
LoxBerry::Web::lbfooter();

exit;

