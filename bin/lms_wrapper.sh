#!/bin/sh

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

# Version 0.1

PATH="/sbin:/bin:/usr/sbin:/usr/bin:$LBHOMEDIR/bin:$LBHOMEDIR/sbin"

ENVIRONMENT=$(cat /etc/environment)
export $ENVIRONMENT

case "$1" in
  start)
	# Starting logitechmediaserver service 
	echo "Starting logitechmediaserver service"
	systemctl enable logitechmediaserver
	systemctl start logitechmediaserver
	exit 0
	;;
  stop)
	# Stopping logitechmediaserver service 
	echo "Stopping logitechmediaserver service"
	systemctl stop logitechmediaserver
	exit 0
	;;
  restart)
	# Restarting logitechmediaserver service 
	echo "Restarting logitechmediaserver service"
	systemctl restart logitechmediaserver
	exit 0
  	;;
  enable)
	# Enabling logitechmediaserver service 
	echo "Enabling logitechmediaserver service"
	systemctl enable logitechmediaserver
	exit 0
	;;
  disable)
	# Enabling logitechmediaserver service 
	echo "Disabling logitechmediaserver service"
	systemctl disable logitechmediaserver
	exit 0
	;;
  *)
        echo "Usage: $0 [start|stop|restart|enable|disable]" >&2
        exit 3
  ;;

esac
