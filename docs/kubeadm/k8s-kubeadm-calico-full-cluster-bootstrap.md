# The kubeadm Full Lab with Calico Flavor

This is the **full lab** created for those who wants to install a k8s cluster using the kubeadm method but wish to optimize even more the time. This template installs and bootstraps automatically a full cluster with the **calico** networking interface. This is the full cluster build that I have created to optimize your study time.

## Use Considerations ##

### Use it if: ###

- you want a very, very, very easy way to bring a cluster up and running in a couple of minutes;
- you have studied a lot, the steps involved in the k8s cluster configuration using the kubeadm method;
- you´re curious and wish to put your hands on a cluster without being involved in the configuration steps but wants to play with _kubectl_;
- you´re tired to install and configure all the components necessary to bring a cluster up;
- you wish to get a coffe while the hard work is done automatically for you;

## Getting Started ##

To run the labs you will need to have pre-installed on your computer the latest version of the following softwares:

- [Vagrant](www.vagrantup.com) by Hashicorp
- [Virtualbox](virtualbox.org) by Oracle

### Tiny URL ###

http://bit.ly/kv-lab-k8s-ka-cal-fcb-vf


### Steps To Run ###

1. Create a directory
```bash
mkdir -p kuberverse/kv-full
```

2. Import the Vagrantfile file to this directory

```bash
cd kuberverse/kv-full
wget http://bit.ly/kv-lab-k8s-ka-cal-fcb-vf -O Vagrantfile
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
