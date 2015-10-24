server_type = File.open('/usr/local/server_type').read

execute 'root_private_key' do
  command 'mv /root/chef-recipes/keys/id_rsa /root/.ssh'
end

file "/root/.ssh/id_rsa" do
  action :create
  content File.open('/root/chef-recipes/keys/id_rsa').read
  mode '600'
end

execute 'root_public_key' do
  cwd '/root/.ssh'
  command 'ssh-keygen -f id_rsa >> authorized_keys'
end
