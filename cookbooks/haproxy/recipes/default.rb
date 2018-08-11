#
# Cookbook:: haproxy
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Install HAProxy
package 'haproxy' do
  action :upgrade
end

# Enable / Start HAProxy
service 'haproxy' do
  action :enable
end

# Configure HA Proxy
webservers = search(:node, 'role:webserver', filter_result: { 'ip' => ['ipaddress'], 'name' => ['fqdn'] })
template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy.cfg.erb'
  variables(webservers: webservers)
  notifies :restart, 'service[haproxy]', :immediately
end
