# kuberverse

Hello kubers, welcome to kuberverse repo! This is the place where we publish the files used on our Youtube recording labs!

## Getting Started

Here, you will find instructions on how to get ready with our labs. The labs where written with easy in mind, to help you build and play **kubernetes clusters**. Please, fell free to try them out!

## System Requirements

### Software

To run the labs you will need to have pre-installed on your computer the latest version of the following softwares:

- [Vagrant](www.vagrantup.com) by Hashicorp
- [Virtualbox](virtualbox.org) by Oracle

### Hardware

The gold rule here is **more is better**. As we will create clusters using virtual machines running on your desk computer or notebook, resources will be needed in the proportion of your use. To be used for study, and using my computer (an old macbook pro late 2012 retina, with a Intel Core i5 processor with 8Gb of memory) as the basis for this labs, I can assure you can run a k8s cluster with 1 master with 2Gb of memory and 2 workers with 1Gb each. This configuration fits almost all of the 6 scenarios of the CKA and the 4 scenarios of CKAD certification exams.  

## Available Labs

At this moment we have 3 labs available for you to play with:

### The kv-k8s-kubeadm labs

As anounced in *december 03, 2018* by the **kubernetes release team** in the [Kubernetes 1.13 Announcement Blog Post](https://kubernetes.io/blog/2018/12/03/kubernetes-1-13-release-announcement/), **kubeadm** is officialy GA. That means a unified and simplified method to deploy k8s clusters without the need to go manually over the steps of configuring individually each component. The scope of **kubeadm** is to be a toolbox for both admins and automated, higher-level system. 

The templates presented here are focused on _local environments_ to be used in a way to help you build k8s clusters with **kubeadm**. Let´s go through the available labs for this scenario.

#### k8s-kubeadm-empty

This is the **empty lab** created for those who wants to install a k8s cluster using the kubeadm method but wish to do almost all the work manually, running the commands necessary to bring the cluster up on a step-by-step way. This template will create the boxes MASTER and WORKERS, with the base recomended OS image (ubuntu 16.04).

##### Use it if: #####

- you're new to kubernetes and wish to start your first cluster running all the commands needed to create your study cluster environment;
- you like to do stuffs manually ir order to have a deeper understanting of what is happening;


#### k8s-kubeadm-half

This is the **half lab** created for those who wants to install a k8s cluster using the kubeadm method but wish to optimize time. This template installs automatically all the packages upgrades to the base recomended OS image (ubuntu 16.04). This template also installs the packages for docker, kubernetes and all their dependencies. No kubernetes configuration is done here.

##### Use it if: #####

- you have played already with the first template and have "destroyed" your previous cluster using the _vagrant destroy -f_ command;
- you want just to configure kubernetes but do not want to install the packages manually on each MASTER and WORKER of your setup;
- you want to play with _kubeadm init_ on the masters and _kubeadm join_ on the workers;
- you want to use choose your networking settings (calico, flannel, etc) and


#### k8s-kubeadm-full

This is the **full lab** created for those who wants to install a k8s cluster using the kubeadm method but wish to optimize even more the time. This template installs and bootstraps automatically a full cluster with the **calico** networking interface. This is the full cluster build that I have created to optimize your study time.

##### Use it if: #####

- you want a very, very, very easy way to bring a cluster up and running in a couple of minutes;
- you have studied a lot, the steps involved in the k8s cluster configuration using the kubeadm method;
- you´re curious and wish to put your hands on a cluster without being involved in the configuration steps but wants to play with _kubectl_;
- you´re tired to install and configure all the components necessary to bring a cluster up;
- you wish to get a coffe while the hard work is done automatically for you;
