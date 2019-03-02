# The kubeadm Empty Lab

This is the **empty lab** created for those who wants to install a k8s cluster using the kubeadm method but wish to do almost all the work manually, running the commands necessary to bring the cluster up on a step-by-step way. This template will create the boxes MASTER and WORKERS, with the base recomended OS image (ubuntu 16.04).

## Use Considerations ##

### Use it if: ###

- you're new to kubernetes and wish to start your first cluster running all the commands needed to create your study cluster environment;
- you like to do stuffs manually ir order to have a deeper understanting of what is happening;

## Getting Started ##

To run the labs you will need to have pre-installed on your computer the latest version of the following softwares:

- [Vagrant](www.vagrantup.com) by Hashicorp
- [Virtualbox](virtualbox.org) by Oracle

### Tiny URL ###

http://bit.ly/kv-lab-k8s-kab-vf

### Steps To Run ###

1. Create a directory
```bash
make -p kuberverse/kv-empty
```

2. Import the Vagrantfile file to this directory

```bash
cd kuberverse/kv-empty
wget http://bit.ly/kv-lab-k8s-kab-vf -O Vagrantfile
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