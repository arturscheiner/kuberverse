# kuberverse x
This is the kuberverse youtube channel repos

Here you will find the files used in our labs. Please, be free to try it out!

At this moment we have 3 labs available for you to test out:

- k8s-kubeadm-base
  this is the base lab from those who wants to install a cluster using the kubeadm method, from the base OS image (ubuntu 16.04)
  Follow the directory to get directions about how to use this template
  Use it if you're new to kubernetes and wish to start your first cluster running all the commands needed to create your environment.

- k8s-kubeadm-pre-cni
  this is the pre-cni lab from those who wants to install a cluster using the kubeadm method, but wish optimize time because this template 
  installs automatically docker, kubernetes and the their dependencies. No kubernetes configuration is done here.
  Use it if you're creating a second cluster or have used "vagrant destroy -f" on the directory of your previous lab. This templates goes
  up to the point where you need to rum "kubeadm init" on the master and after "kubeadm join" on the workers.

- k8s-kubeadm-calico-full-cluster-bootstrap
  this is the full cluster build that I have created to optimize your study time. Use this if you with to bootstrap a new cluster from zero
  but do not to run all the commands to bring the cluster up. The end result here is a full-cluster up and running so that you can continue
  your studies. Useful for those that have decided to "vagrant destroy -f" the previous cluster.



