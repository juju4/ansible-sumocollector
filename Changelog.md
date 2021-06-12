

* juju4, 2017-05
  Validate Travis Test, add Kitchen+Serverspec
  Validate install on Ubuntu Trusty, Xenial
  Use all recent ansible modules
  Ensure idempotency
  Run as user option
  Clean-up

* Changelog from wgregorian
Switched from single source file to /etc/sumo/sumo.d
Supports automatic docker app logs if using journald or syslog driver.
By default installs sumo as systemd unit running a docker container.
Supports file based (rather than cloud based) management.
Tunes host to avoid sumo errors setting ulimits.
Installs sysstat to host for performance monitoring to support Linux Performance Dashboard.
Sets up cron jobs for sysstat and disk checks.
Installs monitors for traefik and mesos.
Installs host metrics to support Host Metrics dashboard
Transitions from old sumo.conf to recommended user.properties file.

Having extra files in /etc/sumo/sumo.d is not a problem.  If path is not found
sumo blade will not load.  Sumo watches the sourcefile or folder so changes
should be taken up automatically without restarting the process.

Currently only the docker install method is fully supported.
The yum install seems to lag behind docker and tarball versions
and sumo support recommended the tar or docker install.
The docker container closely resembles the tar install (/opt/SumoCollector).
If a native install is needed, handlers.yml would need to be modified and
a systemd service based on native install should be written for surviving host shutdowns etc.
