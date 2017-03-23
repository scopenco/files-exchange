#
# Cookbook Name:: env-filesexchange
# Recipe:: _iptables.rb
#
# Copyright 2016-2017 Andrei Skopenko
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

include_recipe 'simple_iptables::redhat'

simple_iptables_rule 'web' do
  rule '-p tcp -m multiport --dport 80,443 -m conntrack --ctstate NEW'
  jump 'ACCEPT'
end

simple_iptables_rule 'rsync' do
  rule '-p tcp -m multiport --dport 873 -m conntrack --ctstate NEW'
  jump 'ACCEPT'
end

simple_iptables_rule 'ftp' do
  rule '-p tcp -m multiport --dport 21 -m conntrack --ctstate NEW'
  jump 'ACCEPT'
end
