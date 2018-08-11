#
# Cookbook:: haproxy
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Install HAProxy
package 'haproxy' do
  action :upgrade
end

# Configure HA Proxy
webservers = search(:node, 'role:webserver', filter_result: { 'ip' => ['ipaddress'], 'name' => ['id'] })
template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy.cfg.erb'
  variables(webservers: webservers)
  notifies :start, 'service[haproxy]', :immediately
end

# Enable / Start HAProxy
service 'haproxy' do
  action [:enable, :start]
end
