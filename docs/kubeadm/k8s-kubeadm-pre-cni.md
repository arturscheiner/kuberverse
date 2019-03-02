This is a pre-cni (Networking Interface) template created for those kubers who want to learn more about kubernetes and wish to setup a "home lab"

Tiny URL for this file:

http://bit.ly/kv-lab-k8s-kapc-vf

If you wish to create your kubernetes lab, using the kubeadm method of deployment, I suggest you start with this template!

Before you start using this lab you should have previously installed:

- Vagrant by Hashcorp (www.vagrantup.com)
- Virtualbox by Oracle (virtualbox.org)

After installing both of the apps described, you can start using this lab just by executing the following steps:

1 - Create a directory ****

make -p kuberverse/kv-base

2 - Import the Vagrantfile file to this directory ****

cd kuberverse/kv-base
wget http://bit.ly/kv-lab-k8s-kapc-vf -O Vagrantfile

3 - Execute the vagrant command to startup the multi-machine environment
vagrant up

4 - Your lab environment will be automatically provisioned and you would be able to get the list of the machines using the command
vagrant status

4 - Your lab environment will be automatically provisioned and you would be able to access the shell of any of the machines using the command
vagrant ssh #machine-name

ex: vagrant ssh kv-master-0