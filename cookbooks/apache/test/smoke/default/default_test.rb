# # encoding: utf-8

# Inspec test for recipe apache::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

instance_json = command('ls /tmp/kitchen/nodes').stdout.strip
node = json("/tmp/kitchen/nodes/#{instance_json}").params

['java-1.6.0-openjdk', 'httpd'].each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe service('httpd') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/var/www/html/index.html') do
  it { should exist }
  it { should be_file }
  its('content') { should match(/Hello world!/) }
  its('content') { should match(/Authored by Jane Doe/) }
end

describe command("curl http://localhost:#{node['default']['apache']['port']}") do
  its('stdout') { should match(/Hello world!/) }
  its('stdout') { should match(/Authored by Jane Doe/) }
  its('stdout') { should match(/My IP Address is /) }
end
