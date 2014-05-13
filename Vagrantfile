# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # -*- mode: ruby -*-
  # vi: set ft=ruby :
  config.vm.box = 'puppetlabs/ubuntu-12.04-32-puppet'

  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provision :shell do |shell|
    shell.inline = "chsh -s /bin/bash vagrant;
                    mkdir -p /etc/puppet/modules;
                    puppet module install puppetlabs/postgresql;
                    puppet module install alup-rbenv;
                    puppet module install saz-memcached"
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
  end

end
