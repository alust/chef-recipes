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
  command 'ssh-keygen -y -f id_rsa > authorized_keys'
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

  execute 'app1' do
    cwd '/root/app'
    command '/root/app/app.py 5001 APP1 > /tmp/app1 &'
  end  

  execute 'app2' do
    cwd '/root/app'
    command '/root/app/app.py 5002 APP2 > /tmp/app2 &'
  end

end

if server_type == 'web'
  package 'nginx'

  directory '/tmp/nginx/cache' do
    mode 700
    owner 'www-data'
    recursive true
  end

  app_ip=File.open('/usr/local/app_ip').read

  file "/etc/nginx/sites-available/default" do
    content "proxy_cache_path /tmp/nginx/cache levels=1:2 keys_zone=cache:30m max_size=1G;
proxy_temp_path /tmp/nginx/proxy 1 2;
proxy_ignore_headers Expires Cache-Control;
proxy_cache_use_stale error timeout invalid_header http_502;
server {
        listen 80 default_server;
        root /var/www/html;
        server_name _;
        location /app1 {
                proxy_cache cache;
                proxy_cache_valid 10m;
                proxy_cache_valid 404 1m;
                proxy_pass http://#{app_ip}:5001/;
        }
        location /app2 {
                proxy_cache cache;
                proxy_cache_valid 10m;
                proxy_cache_valid 404 1m;
                proxy_pass http://#{app_ip}:5002/;
        }
}"
  end

  service 'nginx' do
    action :restart
  end
end
