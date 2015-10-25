server_type = File.open('/usr/local/server_type').read

execute 'root_private_key' do
  command 'cp /root/chef-recipes/keys/id_rsa /root/.ssh'
end

file "/root/.ssh/id_rsa" do
  action :create
  content File.open('/root/chef-recipes/keys/id_rsa').read
  mode '600'
end

execute 'root_public_key' do
  cwd '/root/.ssh'
  command 'ssh-keygen -y -f id_rsa >> authorized_keys'
end

if server_type == 'bastion'
  execute 'enable_forwarding' do
    command 'echo 1 > /proc/sys/net/ipv4/ip_forward'
  end

  execute 'nat' do
    command 'iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE'
  end
end

if server_type == 'app'
  package 'mysql-server' do
    response_file_variables 'mysql-server/root_password_again' => 'abc12345', 'mysql-server/root_password' => 'abc12345'
  end

  package 'python-flask'

  directory '/root/app'

  file "/root/app/app.py" do
    mode 755
    content '#!/usr/bin/python

import sys
from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return sys.argv[2]

app.run(host="0.0.0.0", port=int(sys.argv[1]))'
  end

  execute 'app1'
    cwd '/root/app'
    command '/root/app/app.py 5001 APP1 > /tmp/app1 &'
  end  

  execute 'app2'
    cwd '/root/app'
    command '/root/app/app.py 5002 APP2 > /tmp/app2 &'
  end  
end
