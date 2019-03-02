# The kubeadm Half Lab

This is the **half lab** created for those who wants to install a k8s cluster using the kubeadm method but wish to optimize time. This template installs automatically all the packages upgrades to the base recomended OS image (ubuntu 16.04). This template also installs the packages for docker, kubernetes and all their dependencies. No kubernetes configuration is done here.

## Use Considerations ##

### Use it if: ###

- you have played already with the first template and have "destroyed" your previous cluster using the _vagrant destroy -f_ command;
- you want just to configure kubernetes but do not want to install the packages manually on each MASTER and WORKER of your setup;
- you want to play with _kubeadm init_ on the masters and _kubeadm join_ on the workers;
- you want to choose your networking settings (calico, flannel, etc)

## Getting Started ##

To run the labs you will need to have pre-installed on your computer the latest version of the following softwares:

- [Vagrant](www.vagrantup.com) by Hashicorp
- [Virtualbox](virtualbox.org) by Oracle

### Tiny URL ###

http://bit.ly/kv-lab-k8s-kapc-vf

### Steps To Run ###

1. Create a directory
```bash
make -p kuberverse/kv-half
```

2. Import the Vagrantfile file to this directory

```bash
cd kuberverse/kv-half
wget http://bit.ly/kv-lab-k8s-kapc-vf -O Vagrantfile
```

3. Execute the vagrant command to startup the multi-machine environment

```bash
vagrant up
````

4. Your lab environment will be automatically provisioned and you would be able to get the list of the machines using the command

```bash
vagrant status
````

5. Your lab environment will be automatically provisioned and you would be able to access the shell of any of the machines using the command

```bash
vagrant ssh **_machine-name_**
```

ex: _vagrant ssh kv-master-0_

## Next Steps ##

After provisioning this environment you will need to follow the steps describe on _kuberverse youtube_ or _kubeverse blog_ 