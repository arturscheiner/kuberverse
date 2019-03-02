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

#### k8s-kubeadm-base

This is the **base lab** created for those who wants to install a k8s cluster using the kubeadm method but wish to do almost all the work manually, running the commands necessary to bring the cluster up on a step-by-step way. This template will create the boxes necessarya from the base OS image (ubuntu 16.04), follow the directory to get directions about how to use this template
  Use it if you're new to kubernetes and wish to start your first cluster running all the commands needed to create your environment.

#### k8s-kubeadm-pre-cni
  this is the pre-cni lab from those who wants to install a cluster using the kubeadm method, but wish optimize time because this template 
  installs automatically docker, kubernetes and the their dependencies. No kubernetes configuration is done here.
  Use it if you're creating a second cluster or have used "vagrant destroy -f" on the directory of your previous lab. This templates goes
  up to the point where you need to rum "kubeadm init" on the master and after "kubeadm join" on the workers.

#### k8s-kubeadm-calico-full-cluster-bootstrap
  this is the full cluster build that I have created to optimize your study time. Use this if you with to bootstrap a new cluster from zero
  but do not to run all the commands to bring the cluster up. The end result here is a full-cluster up and running so that you can continue
  your studies. Useful for those that have decided to "vagrant destroy -f" the previous cluster.



