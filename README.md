# kuberverse

![kuberverse logo](https://raw.githubusercontent.com/arturscheiner/kuberverse/master/logos/kuberverse-logo-h-4096x2304.png)
Hello kubers, welcome to kuberverse repo! This is the place where we publish the files used on our Youtube recording labs!

## Getting Started

Here, you will find instructions on how to get ready with our labs. The labs where written with easy in mind, to help you build and play **kubernetes clusters**. Please, fell free to try them out!!

## System Requirements

### Software

To run the labs you will need to have pre-installed on your computer the latest version of the following softwares:

- [Vagrant](www.vagrantup.com) by Hashicorp
- [Virtualbox](virtualbox.org) by Oracle

### Hardware

The gold rule here is **more is better**. As we will create clusters using virtual machines running on your desk computer or notebook, resources will be needed in the proportion of your use. To be used for study, and using my computer (an old macbook pro late 2012 retina, with a Intel Core i5 processor with 8Gb of memory) as the basis for this labs, I can assure you can run a k8s cluster with 1 master with 2Gb of memory and 2 workers with 1Gb each. This configuration fits almost all of the 6 scenarios of the CKA and the 4 scenarios of CKAD certification exams.

### How to use
Just clone this repository edit the kvlab.conf.rb to met your requirements and run 'vagrant up'. These kuberverse scripts will create the environment for you.