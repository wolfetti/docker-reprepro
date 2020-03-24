#!/bin/sh
set -e

echo "Preparing runtime...."

# =============================
# Adding public folders to site
# =============================
if [ ! -L /repo/public/dists ]; then
  ln -s /repo/dists /repo/public/
fi

if [ ! -L /repo/public/pool ]; then
  ln -s /repo/pool /repo/public/
fi
# =============================

# =============================
# Adding cron symlinks
# =============================
if [ ! -L /repo/cron/crontab ]; then
  ln -s /etc/crontab /repo/cron/
fi

if [ ! -L /repo/cron/cron.hourly ]; then
  ln -s /etc/cron.hourly /repo/cron/
fi

if [ ! -L /repo/cron/cron.daily ]; then
  ln -s /etc/cron.daily /repo/cron/
fi

if [ ! -L /repo/cron/cron.weekly ]; then
  ln -s /etc/cron.weekly /repo/cron/
fi

if [ ! -L /repo/cron/cron.monthly ]; then
  ln -s /etc/cron.monthly /repo/cron/
fi
# =============================

# =============================
# Fixing permissions
# =============================

# Bin
chmod 700 /repo/bin/*

# GPG database
chmod 700 /repo/gnupg
chmod 600 /repo/gnupg/*

if [ -f /repo/gnupg/gpg.conf ]; then
  chmod 644 /repo/gnupg/gpg.conf
fi

if [ -f /repo/gnupg/tofu.db ]; then
  chmod 644 /repo/gnupg/tofu.db
fi

if [ -d /repo/gnupg/private-keys-v1.d ]; then
  chmod 700 /repo/gnupg/private-keys-v1.d
  chmod 600 /repo/gnupg/private-keys-v1.d/*
fi

if [ -f /repo/gnupg/S.gpg-agent ]; then
  chmod 1700 /repo/gnupg/S.*
fi

# SSH
chmod 600 /repo/ssh/*key
chmod 644 /repo/ssh/*.pub
chmod 600 /repo/ssh/authorized_keys

# READMEs
for d in $(/bin/ls /repo); do
  if [ -f /repo/$d/README.txt ]; then
    chmod 644 /repo/$d/README.txt
  fi
done
# =============================

echo "Starting services...."
exec /usr/bin/s6-svscan /services
