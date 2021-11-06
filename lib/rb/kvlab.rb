class KvLab

    def initialize
        puts "********** #{green(KVMSG)} **********"
  
        checkmark = "\u2713"
        puts checkmark.force_encoding('utf-8').green.bold.blink
  
        puts "---- Provisioned with k8s #{yellow(KUBE_VERSION)}".blue
        puts "---- Container runtime is: #{yellow(CONTAINER_RUNTIME)}"
        puts "---- CNI Provider is: #{yellow(CNI_PROVIDER)}"
        puts "---- #{MASTER_COUNT} Masters Nodes"
        puts "---- #{WORKER_COUNT} Worker(s) Node(s)" unless MASTER_COUNT == 5
    end
  
    def defineIp(type,i,kvln)
        case type
        when "master" 
          return kvln.split('.')[0..-2].join('.') + ".#{i + 10}"
        when "worker"
          return kvln.split('.')[0..-2].join('.') + ".#{i + 20}"
        when "scaler"
          return kvln.split('.')[0..-2].join('.') + ".#{i + 50}"
        end
    end
    
    def createScaler(config)
  
      i = 0
      scalerIp = self.defineIp("scaler",i,KV_LAB_NETWORK)
  
       # if MASTER_COUNT == 1
       #   p "This is a Single Master Cluster with:"
       #   p "---- #{MASTER_COUNT} Master Node"
       #   p "---- #{WORKER_COUNT} Worker(s) Node(s)"
       #  p "---- Provisioned with Kubernetes v#{KUBE_VERSION}"
       #  return
       # end
  
        if MASTER_COUNT != 1
          puts "---- 1 Scaler Node"
          puts "The Scaler #{i} Ip is #{scalerIp}"
        end
  
        masterIps = Array[]
  
        (0..MASTER_COUNT-1).each do |m|
          masterIps.push(self.defineIp("master",m,KV_LAB_NETWORK))
        end
  
        # p masterIps.length
        # masterIps.each {|s| p s}
  
        config.vm.define "kv-scaler-#{i}" do |scaler|    
          scaler.vm.box = BOX_IMAGE
          scaler.vm.hostname = "kv-scaler-#{i}"
          scaler.vm.network :private_network, ip: scalerIp, nic_type: "virtio"
          scaler.vm.network "forwarded_port", guest: 6443, host: 6443
  
          scaler.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--cpus", 2, "--nictype1", "virtio"]
            vb.memory = SCALER_MEMORY
          end
  
          if !BOX_IMAGE.include? "kuberverse"
            scaler.vm.provider "vmware_desktop" do |v|
              v.vmx["memsize"] = SCALER_MEMORY
              v.vmx["numvcpus"] = "2"
            end
          end
         
          $script = <<-SCRIPT
  
            echo "# Added by Kuberverse" > /vagrant/hosts.out
            echo "#{scalerIp} kv-scaler.lab.local kv-scaler.local kv-master" >> /vagrant/hosts.out
  
            mkdir -p /home/vagrant/.kv
            wget -q #{SCALER_SCRIPT_URL} -O /home/vagrant/.kv/scaler.sh
            chmod +x /home/vagrant/.kv/scaler.sh
            /home/vagrant/.kv/scaler.sh "#{KVMSG}" #{scalerIp} #{BOX_IMAGE} "#{masterIps}"
          SCRIPT
          scaler.vm.provision "shell", inline: $script, keep_color: true
        end
    end
  
    def createMaster(config)
     
      (0..MASTER_COUNT-1).each do |i|
        masterIp = self.defineIp("master",i,KV_LAB_NETWORK)
  
        puts "The Master #{i} Ip is #{masterIp}"
        config.vm.define "kv-master-#{i}" do |master|
          master.vm.box = BOX_IMAGE
          master.vm.hostname = "kv-master-#{i}"
          master.vm.network :private_network, ip: masterIp, nic_type: "virtio"
          
          $script = ""
  
          if MASTER_COUNT == 1
            master.vm.network "forwarded_port", guest: 6443, host: 6443
            $script = <<-SCRIPT
              echo "# Added by Kuberverse" > /vagrant/hosts.out
              echo "#{masterIp} kv-master.lab.local kv-master.local kv-master kv-scaler.lab.local" >> /vagrant/hosts.out
            SCRIPT
          end
  
          master.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--cpus", 2, "--nictype1", "virtio"]
            vb.memory = MASTER_MEMORY
          end
  
          if !BOX_IMAGE.include? "kuberverse"
            master.vm.provider "vmware_desktop" do |v|
              v.vmx["memsize"] = MASTER_MEMORY
              v.vmx["numvcpus"] = "2"
            end
          end
  
          $script = $script + <<-SCRIPT
  
            mkdir -p /home/vagrant/.kv
            
            wget -q #{COMMON_SCRIPT_URL} -O /home/vagrant/.kv/common.sh
            chmod +x /home/vagrant/.kv/common.sh
            /home/vagrant/.kv/common.sh "#{KVMSG}" #{BOX_IMAGE} #{KUBE_VERSION} #{CONTAINER_RUNTIME}
    
            wget -q #{MASTER_SCRIPT_URL} -O /home/vagrant/.kv/master.sh
            chmod +x /home/vagrant/.kv/master.sh
            /home/vagrant/.kv/master.sh "#{KVMSG}" #{i} #{POD_CIDR} #{masterIp} #{CNI_PROVIDER} #{MASTER_COUNT == 1 ? "single" : "multi"}
          SCRIPT
          master.vm.provision "shell", inline: $script, keep_color: true
        end
      end   
    end
  
    def createWorker(config)
      (0..WORKER_COUNT-1).each do |i|
        workerIp = self.defineIp("worker",i,KV_LAB_NETWORK)
  
        puts "The Worker #{i} Ip is #{workerIp}"
        config.vm.define "kv-worker-#{i}" do |worker|
          worker.vm.box = BOX_IMAGE
          worker.vm.hostname = "kv-worker-#{i}"
          worker.vm.network :private_network, ip: workerIp, nic_type: "virtio"
          worker.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--cpus", 2, "--nictype1", "virtio"]
            vb.memory = WORKER_MEMORY
          end
  
          if !BOX_IMAGE.include? "kuberverse"
            worker.vm.provider "vmware_desktop" do |v|
              v.vmx["memsize"] = WORKER_MEMORY
              v.vmx["numvcpus"] = "2"
            end
          end
    
          $script = <<-SCRIPT
  
            mkdir -p /home/vagrant/.kv
    
            wget -q #{COMMON_SCRIPT_URL} -O /home/vagrant/.kv/common.sh
            chmod +x /home/vagrant/.kv/common.sh
            /home/vagrant/.kv/common.sh "#{KVMSG}" #{BOX_IMAGE} #{KUBE_VERSION} #{CONTAINER_RUNTIME}
    
            wget -q #{WORKER_SCRIPT_URL} -O /home/vagrant/.kv/worker.sh
            chmod +x /home/vagrant/.kv/worker.sh
            /home/vagrant/.kv/worker.sh "#{KVMSG}" #{i} #{workerIp} #{MASTER_COUNT == 1 ? "single" : "multi"}
          SCRIPT
          worker.vm.provision "shell", inline: $script, keep_color: true
        end
      end
    end
  end