#! /bin/bash

set
chef-client -l debug -L /tmp/chef.log -V --local-mode --runlist 'recipe[test_task::base]'
echo 10 seconds
sleep 10
chef-client -l debug -L /tmp/chef.log -V --local-mode --runlist 'recipe[test_task::base]'
echo 60 seconds
sleep 60
chef-client -l debug -L /tmp/chef.log -V --local-mode --runlist 'recipe[test_task::base]'
