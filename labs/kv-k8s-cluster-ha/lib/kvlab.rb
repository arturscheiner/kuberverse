class KvLab

    def initialize
        puts "teste"
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
    
    def createScaler(i,config)
        p "Starting Scaler"
        scalerIp = defineIp("scaler",i,KV_LAB_NETWORK)
        config.vm.define "kv-scaler-#{i}" do |ha|    
          ha.vm.box = BOX_IMAGE
          ha.vm.hostname = "kv-scaler-#{i}"
          ha.vm.network :private_network, ip: scalerIp
          ha.vm.network "forwarded_port", guest: 6443, host: 6443
          ha.vm.provision "shell" do |s|
            s.inline = <<-SCRIPT
              mkdir -p /home/vagrant/.kv
              wget -q #{SCALER_SCRIPT_URL} -O /home/vagrant/.kv/scaler.sh
              chmod +x /home/vagrant/.kv/scaler.sh
              /home/vagrant/.kv/scaler.sh #{KVMSG} #{MASTER_COUNT} #{scalerIp}
            SCRIPT
          end
        end
    end

end