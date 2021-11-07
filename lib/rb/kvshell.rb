# kuberverse kubernetes cluster lab
# version: 0.5.0
# description: this Vagrantfile creates a cluster with masters and workers
# created by Artur Scheiner - artur.scheiner@gmail.com

class KvShell
    def env(node,ip,hostname,sIPs,mIPs,wIPs)
        <<-SCRIPT
        export KV_KVMSG='#{KVMSG}'
        export KV_BOX_IMAGE=#{BOX_IMAGE}
        export KV_KUBE_VERSION=#{KUBE_VERSION}
        export KV_CONTAINER_RUNTIME=#{CONTAINER_RUNTIME}
        export KV_CNI_PROVIDER=#{CNI_PROVIDER}
        export kV_MASTER_COUNT=#{MASTER_COUNT}
        export KV_WORKER_COUNT=#{WORKER_COUNT}
        export KV_POD_CIDR=#{POD_CIDR}  
        export KV_MASTER_TYPE=#{MASTER_COUNT == 1 ? "single" : "multi"}
        export KV_THIS_IP=#{ip}
        export KV_THIS_NODE=#{node}
        export KV_THIS_HOSTNAME=#{hostname}
        export KV_SCALER_IPS_ARRAY="#{sIPs}"
        export KV_MASTER_IPS_ARRAY="#{mIPs}"
        export KV_WORKER_IPS_ARRAY="#{wIPs}"
        SCRIPT
    end
    
    def scaler()
        <<-SCRIPT
        printenv | grep -E '^KV_' | sed 's/^/export /' >> ~/.bash_profile
        mkdir -p /home/vagrant/.kv       

        /bin/bash -c '/vagrant/lib/sh/scaler.sh'
        SCRIPT
    end
    
    def worker()
        <<-SCRIPT
        printenv | grep -E '^KV_' | sed 's/^/export /' >> ~/.bash_profile
        mkdir -p /home/vagrant/.kv

        /bin/bash -c '/vagrant/lib/sh/common.sh'
        /bin/bash -c '/vagrant/lib/sh/worker.sh'
        SCRIPT
    end

    def master()
        <<-SCRIPT
        printenv | grep -E '^KV_' | sed 's/^/export /' >> ~/.bash_profile

        mkdir -p /home/vagrant/.kv

        /bin/bash -c '/vagrant/lib/sh/common.sh'
        /bin/bash -c '/vagrant/lib/sh/master.sh'              
        SCRIPT
    end

end