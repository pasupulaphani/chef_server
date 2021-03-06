#
# Cookbook Name:: phaninder.com
# Recipe:: static_setup
#
# Copyright 2013, phaninder.com
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

### Static dir create and set permissions
group "www-data" do
  members ["nginx", "deploy"]
  append true
end

directory "#{node[:myblog][:static][:root_dir]}/#{node[:myblog][:static][:hostname]}" do
	owner "nginx"
  group "www-data"
  mode  00674
  action :create
  recursive true
end

bash "make_static_root_executable" do
  user "root"
  cwd node[:myblog][:static][:root_dir]
  code <<-EOH
    chmod a+x *
  EOH
end

### set_site definition
set_site node[:myblog][:static][:hostname] do
  enable true
end

### set /etc/hosts
hostsfile_entry node['phaninder.com'][:A_record] do
  hostname  node[:myblog][:static][:hostname]
  action    :append
end