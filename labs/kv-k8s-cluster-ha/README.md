#### k8s-kubeadm-calico-full-cluster-bootstrap - The kubeadm Full Lab with Calico Flavor

This is the **full lab** created for those who wants to install a k8s cluster using the kubeadm method but wish to optimize even more the time. This template installs and bootstraps automatically a full cluster with the **calico** networking interface. This is the full cluster build that I have created to optimize your study time.

### Latest Changes ###

This lab was recently updated to run the latest version of Kubernetes 1.16. The cluster runs over Ubuntu 16.04 and the container runtime chosen was Docker 18.09. All links and references where updated to reflect the actual changes. The overall experience was maintained from the previous version, but the script was divided into 4 different pieces:

- New Vagrantfile
- New common.sh
- New master.sh
- New worker.sh

##### Use it if: #####

- you want a very, very, very easy way to bring a cluster up and running in a couple of minutes;
- you have studied a lot, the steps involved in the k8s cluster configuration using the kubeadm method;
- you´re curious and wish to put your hands on a cluster without being involved in the configuration steps but wants to play with _kubectl_;
- you´re tired to install and configure all the components necessary to bring a cluster up;
- you wish to get a coffe while the hard work is done automatically for you;
