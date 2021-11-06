# kuberverse kubernetes cluster lab
# version: 0.2.0
# description: this Vagrantfile creates a cluster with masters and workers
# created by Artur Scheiner - artur.scheiner@gmail.com
# dependencies: https://raw.githubusercontent.com/arturscheiner/kuberverse/master/labs/kv-k8s-cluster-ha/common.sh
#               https://raw.githubusercontent.com/arturscheiner/kuberverse/master/labs/kv-k8s-cluster-ha/scaler.sh
#               https://raw.githubusercontent.com/arturscheiner/kuberverse/master/labs/kv-k8s-cluster-ha/master.sh
#               https://raw.githubusercontent.com/arturscheiner/kuberverse/master/labs/kv-k8s-cluster-ha/worker.sh

require_relative 'lib/rb/kvlab.rb'

# Is not recommended, but you can change the base box.
# This means that all the VMs will use the same image.
# For vmware_desktop provider use
#BOX_IMAGE = "bento/ubuntu-18.04"
# For virtualbox provider you can choose to use
# bento or kuberverse images. The difference is
# that kuberverse images are pre-loaded with
# the packages needed to create the cluster
# that means less time to build the cluster.
BOX_IMAGE = "kuberverse/ubuntu-18.04"

# Define the k8s version to be used on this lab.
KUBE_VERSION = "1.22.3"

# Define the container runtime that will be used on
# your lab. From k8s v1.22 the default runtime is containerd.
# You can choose between containerd|docker
CONTAINER_RUNTIME = "containerd"

# Define CNI Provider
# Choose between calico|weave|flannel
CNI_PROVIDER = "weave"

# Change these values if you wish to play with the 
# cluster size. Do this before starting your cluster
# provisioning.
MASTER_COUNT = 1
WORKER_COUNT = 1

# Change these values if you wish to play with the 
# VMs memory resources.
# Kubernetes pre-flight for the MASTER_NODES now requires 1700+ of memory.
SCALER_MEMORY = 512
MASTER_MEMORY = 2048
WORKER_MEMORY = 1024

# Change these values if you wish to play with the
# networking settings of your cluster 
KV_LAB_NETWORK = "10.8.8.0"

# This value changes the intra-pod network
POD_CIDR = "172.18.0.0/16"


KVMSG = "Kuberverse Kubernetes Cluster Lab"

COMMON_SCRIPT_URL = "https://raw.githubusercontent.com/arturscheiner/kuberverse/master/labs/kv-k8s-cluster-ha/common.sh"
SCALER_SCRIPT_URL = "https://raw.githubusercontent.com/arturscheiner/kuberverse/master/labs/kv-k8s-cluster-ha/scaler.sh"
MASTER_SCRIPT_URL = "https://raw.githubusercontent.com/arturscheiner/kuberverse/master/labs/kv-k8s-cluster-ha/master.sh"
WORKER_SCRIPT_URL = "https://raw.githubusercontent.com/arturscheiner/kuberverse/master/labs/kv-k8s-cluster-ha/worker.sh"

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
 end

def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end
def yellow(text); colorize(text, 33); end
def blue(text); colorize(text, 34); end

class String
  def black; "\e[30m#{self}\e[0m" end
  def red; "\e[31m#{self}\e[0m" end
  def green; "\e[32m#{self}\e[0m" end
  def brown; "\e[33m#{self}\e[0m" end
  def blue; "\e[34m#{self}\e[0m" end
  def magenta; "\e[35m#{self}\e[0m" end
  def cyan; "\e[36m#{self}\e[0m" end
  def gray; "\e[37m#{self}\e[0m" end
 
  def bg_black; "\e[40m#{self}\e[0m" end
  def bg_red; "\e[41m#{self}\e[0m" end
  def bg_green; "\e[42m#{self}\e[0m" end
  def bg_brown; "\e[43m#{self}\e[0m" end
  def bg_blue; "\e[44m#{self}\e[0m" end
  def bg_magenta; "\e[45m#{self}\e[0m" end
  def bg_cyan; "\e[46m#{self}\e[0m" end
  def bg_gray; "\e[47m#{self}\e[0m" end
 
  def bold; "\e[1m#{self}\e[22m" end
  def italic; "\e[3m#{self}\e[23m" end
  def underline; "\e[4m#{self}\e[24m" end
  def blink; "\e[5m#{self}\e[25m" end
  def reverse_color; "\e[7m#{self}\e[27m" end
end



Vagrant.configure("2") do |config|

  kvlab = KvLab.new()

  if ARGV[0] == "up" or ARGV[0] == "status" or ARGV[0] == "destroy" or ARGV[0] == "ssh"
    
    if MASTER_COUNT >= 2
      kvlab.createScaler(config)
    end

    kvlab.createMaster(config)
    kvlab.createWorker(config)


    config.vm.provision "shell",
     run: "always",
     inline: "swapoff -a"
  end
  
end
