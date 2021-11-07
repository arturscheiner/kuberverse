# kuberverse kubernetes cluster lab
# version: 0.5.0
# description: this Vagrantfile creates a cluster with masters and workers
# created by Artur Scheiner - artur.scheiner@gmail.com

require_relative 'kvlab.conf.rb'
require_relative 'lib/rb/kvlab.rb'

Vagrant.configure("2") do |config|

  kvlab = KvLab.new()

    if MASTER_COUNT >= 2
      kvlab.createScaler(config)
    end

    kvlab.createMaster(config)
    kvlab.createWorker(config)

    config.vm.provision "shell",
     run: "always",
     inline: "swapoff -a"  
end
