#!/usr/bin/env bash

#===================================================================================

# newsite.sh by Terry Morgan <terry.morgan@marmaladeontoast.co.uk>
#
# A little script to set up new development sites on Mac OSX
#
# host_exists function and other bits yoinked from Patrick Gibson's virtualhost.sh:
# https://github.com/pgib/virtualhost.sh
#
# MIT License
#
# Copyright (c) 2011 Terry Morgan
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
#===================================================================================

# ---------------- Start Configuration options -----------------
# Review all configuration options and amend to suit your system and requirements

# We're storing each virtual host definition os it's own
# conf file in the following directory:

VHOSTDIR="/etc/apache2/other"

# Path to the sites folder where the new sites root folder will live

SITESDIR="$HOME/Sites"

# Path the hosts file

HOSTSFILE="/etc/hosts"

# Default localhost IP address

HOSTSIP="127.0.0.1"

# Change this to your username. The site root folder will need to be owned by you
# user for you to be able to edit it.

OWNER="Shodan"

# ---------------- END Configuration options -----------------

host_exists()
{
  if grep -q -e "^$HOSTSIP    $1$" $HOSTSFILE ; then
    return 0
  else
    return 1
  fi
}

# Create new site root folder

if [ ! -d "$SITESDIR/$1" ]; then
  echo "Creating site folder..."

  SITEROOT="$SITESDIR/$1"
  VHOST="$VHOSTDIR/$1.conf"
  LOCALHOST="$1.localhost"

  mkdir $SITEROOT
  chown $OWNER $SITEROOT

  # Set up n virtual host entry

  echo "Setting up vhost..."

  touch $VHOST
  cat << __EOF >$VHOST
# Created by newsite.sh
<VirtualHost *:80>
    DocumentRoot $SITEROOT
    ServerName $LOCALHOST
    ErrorLog "/private/var/log/apache2/$1.localhost-error_log"
    CustomLog "/private/var/log/apache2/$1.localhost-access_log" common
</VirtualHost>
__EOF

  # Add an entry to the hosts file, if one doesn't already exist

  if ! host_exists $1 ; then
    /bin/echo "Creating a hosts file entry for $LOCALHOST..."
    /bin/echo -n "+ Adding $LOCALHOST to $HOSTSFILE... "
    /bin/echo "$HOSTSIP    $LOCALHOST" >> $HOSTSFILE
    /bin/echo "done"
  fi

  echo "Restarting Apache..."

  apachectl -k graceful

  echo "All done. You da man! :)"
else
  echo "<sadface> Site folder called $1 already exists. Bailing out... </ sadface>"
fi

exit