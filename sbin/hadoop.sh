#!/bin/bash

function vaild_host() {
  if [[ $(grep -c hadoop-master1 /etc/hosts) -eq 0 ]]; then
    echo 'need to edit etc hosts'
    return 0
  else
    return 1
  fi
}

function init_hdfs() {
  echo "hdfs init start"
  hdfs namenode -format
}

function op_master() {
  if vaild_host; then
    return
  fi

  case $1 in
  start)
    echo 'start hadoop nn,rm'
    hdfs --daemon start namenode
    yarn --daemon start resourcemanager
    ;;
  stop)
    echo 'stop hadoop nn,rm'
    hdfs --daemon stop namenode
    yarn --daemon stop resourcemanager
    ;;
  restart)
    echo 'restart'
    hdfs --daemon stop namenode
    yarn --daemon stop resourcemanager
    hdfs --daemon start namenode
    yarn --daemon start resourcemanager
    ;;
  *)
    echo 'input correct command'
    ;;
  esac
}

function op_slave() {
  if vaild_host; then
    return
  fi

  case $1 in
  start)
    echo 'start hadoop dn,nm'
    hdfs --daemon start datanode
    yarn --daemon start nodemanager
    ;;
  stop)
    echo 'stop hadoop dn,nm'
    hdfs --daemon stop datanode
    yarn --daemon stop nodemanager
    ;;
  restart)
    echo 'restart'
    hdfs --daemon stop datanode
    yarn --daemon stop nodemanager
    hdfs --daemon start datanode
    yarn --daemon start nodemanager
    ;;
  *)
    echo 'input correct command'
    ;;
  esac
}

function op_start_mr_js() {
  echo 'start jobhistory server'
  mr-jobhistory-daemon.sh start historyserver
}

function op_stop_mr_js() {
  echo 'stop jobhistory server'
  mr-jobhistory-daemon.sh stop historyserver
}

function op_stop_all() {
  echo 'stop all server'
  hdfs --daemon stop datanode
  yarn --daemon stop nodemanager

  hdfs --daemon stop namenode
  yarn --daemon stop resourcemanager
}

function op_stop_other() {
  echo 'stop js,ts server'

  mr-jobhistory-daemon.sh stop historyserver

  yarn --daemon stop timelineserver
}

function op_start_all() {
  echo 'start all server'
  hdfs --daemon start namenode
  yarn --daemon start resourcemanager

  hdfs --daemon start datanode
  yarn --daemon start nodemanager
}

function op_start_other() {
  echo 'start js,ts server'
  mr-jobhistory-daemon.sh start historyserver

  yarn --daemon start timelineserver
}
