#!/bin/sh
set -e

echo "Preparing runtime...."

# Adding public site /dists symlink if not exists
if [ ! -L /repo/public/dists ]; then
  ln -s /repo/dists /repo/public/
fi

# Adding public site /pool symlink if not exists
if [ ! -L /repo/public/pool ]; then
  ln -s /repo/pool /repo/public/
fi

# Adding cron symlinks
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

# Adding update cronjob to cron.daily
if [ ! -L /repo/cron/cron.daily/repo-update-mirrors ]; then
  ln -s /repo/bin/repo-update-mirrors /etc/cron.daily/
fi

# Fixing bin permissions
chmod 700 /repo/bin/*

# Start services
echo "Starting services...."
exec /usr/bin/s6-svscan /services
