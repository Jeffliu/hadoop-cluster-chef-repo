# Copyright 2011, Outbrain, Inc.
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

package "mysql" do
  action :install
end

package "mysql-server" do
  action :install
end

service "mysqld" do
  action [ :enable, :start ]
  running true
  supports :status => true, :start => true, :stop => true, :restart => true
end

# OMG! This is awful!
bash "setupDatabase" do
  user "root"
  code <<-EOH
  service mysqld start
  mysqladmin -u root password 'p4ssw0rd'
  mysqladmin -u root -h $(hostname) password 'p4ssw0rd'
  mysql -h localhost -u root -pout4brain -e"CREATE USER 'hadoop'@'localhost' IDENTIFIED BY 'hadoop'; GRANT ALL PRIVILEGES ON *.* TO 'hadoop'@'localhost' WITH GRANT OPTION;"
  mysql -h localhost -u root -pout4brain -e"CREATE USER 'hadoop'@'$(hostname)' IDENTIFIED BY 'hadoop'; GRANT ALL PRIVILEGES ON *.* TO 'hadoop'@'$(hostname)' WITH GRANT OPTION;"
  exit 0
  EOH
end
