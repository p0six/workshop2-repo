#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'java::default'

package 'httpd' do
  action :install
end

template '/etc/httpd/conf/httpd.conf' do
  source 'httpd.conf.erb'
  mode '0644'
  variables(port: node['apache']['port'])
  notifies :restart, 'service[httpd]', :immediately
end

service 'httpd' do
  action %i(enable start)
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
  mode '0644'
  variables(
    ipaddress: node['ipaddress'],
    author: node['apache']['author']
  )
end
