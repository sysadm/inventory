#!/bin/bash

source /home/inventory/.rvm/scripts/rvm
export PATH=$PATH:/home/inventory/.rvm/bin/

function serv_start ()
{
    cd /home/inventory/inventory.multitel.be/current
    bundle exec unicorn_rails -c /home/inventory/inventory.multitel.be/current/config/unicorn/production.rb -E production -D
    bin/delayed_job start
}

function serv_stop ()
{
    if [[ -s "~inventory/inventory.multitel.be/current/tmp/pids/unicorn.pid" ]]; then
	  kill -s QUIT `cat ~inventory/inventory.multitel.be/current/tmp/pids/unicorn.pid` 2>/dev/null
    else
	  kill -s QUIT `ps ax |grep unicorn|grep master|grep inventory |awk {'print $1'}` 2>/dev/null
    fi
    if [[ -s "~inventory/inventory.multitel.be/current/tmp/pids/delayed_job.pid" ]]; then
	  kill -s QUIT `cat ~inventory/inventory.multitel.be/current/tmp/pids/delayed_job.pid` 2>/dev/null
    else
      kill -s QUIT `ps ax |grep delayed_job|grep -v grep |awk {'print $1'}` 2>/dev/null
    fi
}

function serv_restart ()
{
    cd /home/inventory/inventory.multitel.be/current
    bin/delayed_job restart
    if [[ -s "~inventory/inventory.multitel.be/current/tmp/pids/unicorn.pid" ]]; then
	  PID=`cat tmp/pids/unicorn.pid`
    else
	  PID=`ps ax |grep unicorn|grep master|grep inventory |awk {'print $1'}`
    fi
    kill -USR2 $PID
    sleep 3
    kill -WINCH $PID 2>/dev/null
    sleep 3
    kill -QUIT $PID 2>/dev/null
}

case "$1" in
start) echo "Server starting..."
    serv_start
    ;;
stop) echo "Server shutdown..."
    serv_stop
    ;;
restart) echo "Server restarting..."
    serv_restart
    ;;
*) echo "Using: production.sh [action] . Where action is start/stop/restart."
    ;;
esac
