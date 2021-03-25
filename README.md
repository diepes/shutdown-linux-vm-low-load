# shutdown-linux-vm-low-load
Bash script to check for Linux load and shutdown VM if below threshold.


## Usage:
run the script from cron every 10 min. (As root or user with sudo /usr/bin/shutdown with no password)

When it run it checks that uptime > 10min and load > 1, if not it waits 10min checks load if still < 1, does sudo shutdown.

## Goal:
Adhock servers running longrunning jobs, shutdown server when jobs end, to save cloud cost.
In AWS(2021) when server shutdown, there is not CPU cost, only the ESB disk.


