#!/usr/bin/env bash

# We're storing each virtual host definition os it's own
# conf file in the following directory:
 
VHOSTDIR="/etc/apache2/other"

# The following file contains the virtual host template
# that we're basing our new virtual host definition on

DEFAULTCONF="default.txt"

# Path to the sites folder where the new sites root folder
# will live

SITESDIR="$HOME/Sites"

# Path the hosts file

HOSTSFILE="/etc/hosts"

# Default localhost IP address

HOSTSIP="127.0.0.1"

# host_exists function yoinked from 
# https://github.com/pgib/virtualhost.sh
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
  mkdir "$SITESDIR/$1"  

  # Copy and amend default virtual host entry

  echo "Setting up vhost..."
  touch $1.conf
  cat $DEFAULTCONF | sed "s/xxxx/$(echo $1 | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g')/g" > $1.conf
  mv $1.conf "$VHOSTDIR/$1.conf"

  # Add an entry to the hosts file, if one doesn't already exist

  HOST="$1.localhost"

  if ! host_exists $1 ; then
    /bin/echo "Creating a hosts file entry for $HOST..."
    /bin/echo -n "+ Adding $HOST to $HOSTSFILE... "
    /bin/echo "$HOSTSIP    $1" >> $HOSTSFILE
    /bin/echo "done"
  fi

  echo "Restarting Apache..."

  apachectl -k graceful

  echo "All done :)"
else
  echo "Site folder called $1 already exists. Bailing out..."
fi

exit