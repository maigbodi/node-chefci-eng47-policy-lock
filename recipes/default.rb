#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
include_recipe "nodejs"
include_recipe "apt"
package "nginx"
service "nginx" do
  action [:enable,:start]
end
apt_update 'update_sources' do
  action :update
end


template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables proxy_port: node['nginx']['proxy_port']
  notifies :restart, 'service[nginx]'
end
link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :restart, 'service[nginx]'
end
nodejs_npm 'pm2'
