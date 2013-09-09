#
# Author:: Didier Bathily (<bathily@njin.fr>)
# Cookbook Name:: play2
# Recipe:: default
#
# Copyright 2013, njin
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

play2Home 		= node[:play2][:home]
destinationName = "play-#{node[:play2][:version]}"
zipName 		= destinationName+".zip"
destinationPath = play2Home+"/"+destinationName 
archiveFile		= play2Home+"/"+zipName

package "zip"
package "unzip"

directory play2Home do
  action :create
  mode 0755
end

execute "install-play2" do
    user "root"
    cwd play2Home
    command <<-EOH
    unzip play-#{node[:play2][:version]}.zip
    ln -sf #{destinationPath}/play /usr/bin/play
    chmod 0755 #{destinationPath}/play
    EOH
    action :nothing
end

remote_file "#{play2Home}/play-#{node[:play2][:version]}.zip" do
    source node[:play2][:url]+node[:play2][:version]+"/#{zipName}"
    checksum node[:play2][:checksum]
    mode "0644"
    notifies :run, "execute[install-play2]", :immediately
    action :create_if_missing
end
