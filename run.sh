#! /bin/bash

while ps ax|grep cloud | grep -v grep
do
  sleep 1
done
chef-client --local-mode --runlist 'recipe[test_task::base]'
