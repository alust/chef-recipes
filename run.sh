#! /bin/bash

chef-client --local-mode --runlist 'recipe[test_task::base]'
