#
# Cookbook Name:: rackspace-dns
# Resource:: zone
#
# Copyright 2015, Rackspace
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Rackspace::DNS

default_action :create

actions :create, :delete

attribute :domain, :kind_of => String, :name_attribute => true
attribute :email, :kind_of => String, :required => true
attribute :ttl, :kind_of => [String, Integer], :default => 300
attribute :rackspace_username, :kind_of => [String, NilClass], :default => nil
attribute :rackspace_api_key, :kind_of => [String, NilClass], :default => nil
attribute :rackspace_auth_region, :kind_of => [String, NilClass], :default => 'us'
attribute :mock,                  kind_of: [TrueClass, FalseClass], default: false

def initialize(*args)
  super
  @rackspace_username ||= node['rackspace_dns']['rackspace_username']
  @rackspace_api_key ||= node['rackspace_dns']['rackspace_api_key']
  @rackspace_auth_region ||= node['rackspace_dns']['rackspace_auth_region']
end
