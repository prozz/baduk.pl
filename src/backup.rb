require 'net/ssh'
require 'net/scp'

# host = "check me"
# user = "check me"
# password = "check me"

date = Time.now.strftime("%d-%m-%Y--%H-%M")

remote_path = "/home/baduk"
file_name = "dump-#{date}.sql.gz"
file_path = "#{remote_path}/#{file_name}"

Net::SSH.start(host, user, :password => password) { |ssh|
	ssh.exec!("cd; pg_dump -a baduk | gzip > #{file_path}")
}

Net::SCP.start(host, user, :password => password) { |scp|
	scp.download!(file_path, ".")
}

