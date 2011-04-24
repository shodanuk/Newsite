#!/usr/bin/env bash

# We're storing each virtual host definition os it's own
# conf file in the following directory:

VHOSTDIR="/etc/apache2/other"

# Path to the sites folder where the new sites root folder
# will live

SITESDIR="$HOME/Sites"

# Path the hosts file

HOSTSFILE="/etc/hosts"

# Default localhost IP address

HOSTSIP="127.0.0.1"

# Your username. The site root folder will need to be owned by you
# user for you to be able to edit it.

OWNER="Shodan"

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

  echo "All done :)"
else
  echo "Site folder called $1 already exists. Bailing out..."
fi

exit