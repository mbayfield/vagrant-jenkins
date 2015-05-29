Vagrant.configure("2") do |config|

	# set base box
	# https://atlas.hashicorp.com/ubuntu/boxes/trusty64
	config.vm.box = "ubuntu/trusty64"
	config.vm.hostname = "jenkins"

	# setup network
	config.vm.network :private_network, ip: "192.168.1.200"

	# setup virtualbox
	config.vm.provider "virtualbox" do |v|
	    v.name = "jenkinsCI"
	end

	# virtualbox performance tweaks - set cpu and memory
	# https://stefanwrobel.com/how-to-make-vagrant-performance-not-suck
	config.vm.provider "virtualbox" do |v|
		host = RbConfig::CONFIG['host_os']

		# Give VM 1/4 system memory & access to all cpu cores on the host
		if host =~ /darwin/
			cpus = `sysctl -n hw.ncpu`.to_i
			# sysctl returns Bytes and we need to convert to MB
			mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
		elsif host =~ /linux/
			cpus = `nproc`.to_i
			# meminfo shows KB and we need to convert to MB
			mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
		else # sorry Windows folks, I can't help you
			cpus = 2
			mem = 1024
		end

		v.customize ["modifyvm", :id, "--memory", mem]
		v.customize ["modifyvm", :id, "--cpus", cpus]

		# use hosts dns
		# http://alexbilbie.com/2014/11/vagrant-dns/
		v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	end

	# provisioning

	# workaround logging issues
	# default: stdin: is not a tty
	# https://github.com/mitchellh/vagrant/issues/1673
	config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

	config.vm.provision "shell" do |s|
	    s.path = "provision/setup.sh"
	end

	config.vm.provision "shell", run: "always" do |s|
	    s.path = "provision/start-services.sh"
	end

end
