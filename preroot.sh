#!/bin/bash

# Shell script which is executed by bash *BEFORE* installation is started
# (*BEFORE* preinstall and *BEFORE* preupdate). Use with caution and remember,
# that all systems may be different!
#
# Exit code must be 0 if executed successfull. 
# Exit code 1 gives a warning but continues installation.
# Exit code 2 cancels installation.
#
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Will be executed as user "root".
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# You can use all vars from /etc/environment in this script.
#
# We add 5 additional arguments when executing this script:
# command <TEMPFOLDER> <NAME> <FOLDER> <VERSION> <BASEFOLDER>
#
# For logging, print to STDOUT. You can use the following tags for showing
# different colorized information during plugin installation:
#
# <OK> This was ok!"
# <INFO> This is just for your information."
# <WARNING> This is a warning!"
# <ERROR> This is an error!"
# <FAIL> This is a fail!"

# To use important variables from command line use the following code:
COMMAND=$0    # Zero argument is shell command
PTEMPDIR=$1   # First argument is temp folder during install
PSHNAME=$2    # Second argument is Plugin-Name for scipts etc.
PDIR=$3       # Third argument is Plugin installation folder
PVERSION=$4   # Forth argument is Plugin version
#LBHOMEDIR=$5 # Comes from /etc/environment now. Fifth argument is
              # Base folder of LoxBerry
PTEMPPATH=$6  # Sixth argument is full temp path during install (see also $1)

# Combine them with /etc/environment
PCGI=$LBPCGI/$PDIR
PHTML=$LBPHTML/$PDIR
PTEMPL=$LBPTEMPL/$PDIR
PDATA=$LBPDATA/$PDIR
PLOG=$LBPLOG/$PDIR # Note! This is stored on a Ramdisk now!
PCONFIG=$LBPCONFIG/$PDIR
PSBIN=$LBPSBIN/$PDIR
PBIN=$LBPBIN/$PDIR

if [ -e $LBSCONFIG/is_raspberry.cfg ]; then
       	downloados=arm
	echo "<INFO> Our architecture is: Raspberry"
fi
if [ -e $LBSCONFIG/is_x86.cfg ]; then
       	downloados=i386
	echo "<INFO> Our architecture is: x86"
fi
if [ -e $LBSCONFIG/is_x64.cfg ]; then
       	downloados=amd64
	echo "<INFO> Our architecture is: x64"
fi

# Latest available package in 7.9 branch
lmsup_url_version="http://downloads.slimdevices.com/nightly/?ver=8.3"
lmsup_temp="/tmp/lms.update"
wget -q -O $lmsup_temp $lmsup_url_version
lmsup_version=$(grep -A 1 "_all.deb" $lmsup_temp | grep -v grep | cut -c 95- | cut -d"<" -f1 | cut -d"_" -f1 | cut -d"~" -f1 )

url="http://www.mysqueezebox.com/update/?version=$lmsup_version&revision=1&geturl=1&os=deb$downloados"
latest_lms=$(wget -q -O - "$url")
echo "<INFO> Latest LMS package is: $latest_lms"

rm -r /tmp/lms_sources
mkdir -p /tmp/lms_sources
cd /tmp/lms_sources

wget --progress=dot:mega $latest_lms

lms_deb=${latest_lms##*/}
if [ -e "/tmp/lms_sources$lms_deb" ]; then
	echo "<FAIL> Something went wrong downloading $lms_deb. Giving up."
	exit 2
fi
echo "<INFO> Downloaded package: $lms_deb"
echo "<INFO> Installing $lms_deb..."
dpkg -i $lms_deb

if ! dpkg -V logitechmediaserver; then
	echo "<FAIL> Something went wrong installing $lms_deb. Giving up."
	exit 2
fi

echo "<INFO> Adding user squeezeboxserver to group loxberry and audio"
usermod -aG loxberry squeezeboxserver
usermod -aG audio squeezeboxserver

echo "<INFO> Enable logitechmediaserver at boot"
systemctl enable logitechmediaserver
systemctl stop logitechmediaserver
systemctl start logitechmediaserver

exit 0
