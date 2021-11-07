# kuberverse kubernetes cluster lab
# version: 0.5.0
# description: this Vagrantfile creates a cluster with masters and workers
# created by Artur Scheiner - artur.scheiner@gmail.com

require_relative 'kvshell.rb'
require_relative 'kvtools.rb'

class KvLab

    def initialize
        @kvshell = KvShell.new()
        @kvtools = KvTools.new()


        if MASTER_COUNT >= 2
          $sIPs = @kvtools.iPSa("scaler",1)
        else
          $sIPs = []
        end

        $mIPs = @kvtools.iPSa("master",MASTER_COUNT)
        $wIPs = @kvtools.iPSa("worker",WORKER_COUNT)

        puts "********** #{KVMSG.green}**********"
  
        checkmark = "\u2713"
        puts checkmark.force_encoding('utf-8').green.bold.blink
  
        puts "---- Provisioned with k8s #{KUBE_VERSION.yellow}".blue
        puts "---- Container runtime is: #{CONTAINER_RUNTIME.yellow}"
        puts "---- CNI Provider is: #{CNI_PROVIDER.yellow}"
        puts "---- #{MASTER_COUNT} Masters Nodes"
        puts "---- #{WORKER_COUNT} Worker(s) Node(s)" unless MASTER_COUNT == 5
    end

    def createScaler(config)
  
      node = 0
      ip = @kvtools.defineIp("scaler",node,KV_LAB_NETWORK)
  
        if MASTER_COUNT != 1
          puts "---- 1 Scaler Node"
          puts "The Scaler #{node} Ip is #{ip}"
        end
  
        config.vm.define "kv-scaler-#{node}" do |scaler|    
          scaler.vm.box = BOX_IMAGE
          scaler.vm.hostname = "kv-scaler-#{node}"
          scaler.vm.network :private_network, ip: ip, nic_type: "virtio"
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
          if ARGV[0] == "destroy"
            puts "Deleting .kv directory"
            @kvtools.cleanKvDir()     
          else
            @kvtools.addToHosts(ip,scaler.vm.hostname)
          end
          $s_script = @kvshell.env(node,ip,scaler.vm.hostname,$sIPs,$mIPs,$wIPs) + @kvshell.scaler()
          scaler.vm.provision "shell", inline: $s_script, keep_color: true
        end
    end
  
    def createMaster(config)
     
      (0..MASTER_COUNT-1).each do |node|
        ip = @kvtools.defineIp("master",node,KV_LAB_NETWORK)
  
        puts "The Master #{node} Ip is #{ip}"
        config.vm.define "kv-master-#{node}" do |master|
          master.vm.box = BOX_IMAGE
          master.vm.hostname = "kv-master-#{node}"
          master.vm.network :private_network, ip: ip, nic_type: "virtio"
          
  
          if MASTER_COUNT == 1
            master.vm.network "forwarded_port", guest: 6443, host: 6443
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
          if ARGV[0] == "destroy"
            puts "Deleting .kv directory"
            @kvtools.cleanKvDir()     
          else
            @kvtools.addToHosts(ip,master.vm.hostname)
          end
          $m_script = @kvshell.env(node,ip,master.vm.hostname,$sIPs,$mIPs,$wIPs) + @kvshell.master()

          master.vm.provision "shell", inline: $m_script, keep_color: true
        end
      end   
    end
  
    def createWorker(config)
      (0..WORKER_COUNT-1).each do |node|
        ip = @kvtools.defineIp("worker",node,KV_LAB_NETWORK)
  
        puts "The Worker #{node} Ip is #{ip}"
        config.vm.define "kv-worker-#{node}" do |worker|
          worker.vm.box = BOX_IMAGE
          worker.vm.hostname = "kv-worker-#{node}"
          worker.vm.network :private_network, ip: ip, nic_type: "virtio"
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
          if ARGV[0] == "destroy"
            puts "Deleting .kv directory"
            @kvtools.cleanKvDir()     
          else
            @kvtools.addToHosts(ip,worker.vm.hostname)
          end
          $w_script = @kvshell.env(node,ip,worker.vm.hostname,$sIPs,$mIPs,$wIPs) + @kvshell.worker()
          worker.vm.provision "shell", inline: $w_script, keep_color: true
        end
      end
    end
    
  end