# CoreOS Vagrant

This repo provides a template Vagrantfile to create a CoreOS virtual machine using the VirtualBox software hypervisor.
After setup is complete you will have a single CoreOS virtual machine running on your local machine.

## Streamlined setup

1) Install dependencies

* [VirtualBox][virtualbox] 4.3.10 or greater.
* [Vagrant][vagrant] 1.6 or greater.

2) Clone this project and get it running!

```
git clone https://github.com/adomenech73/CoreOS.git
cd CoreOS/Vagrant
```

3) Startup and SSH

There are two "providers" for Vagrant with slightly different instructions.
Follow one of the following two options:

**VirtualBox Provider**

Firstefall get a new id for the CoreOS cluster we want to start in:

[New CoreOS key]: https://discovery.etcd.io/new

Modify the file user-data to insert the new key at the header.

The VirtualBox provider is the default Vagrant provider. Use this if you are unsure.

```
vagrant up
```

Then add the SSH keys of the Vagrant VM

```
vagrant ssh-config --host node-01 >> ~/.ssh/config
vagrant ssh-config --host node-01 | sed -n "s/IdentityFile//gp" | xargs ssh-add
```

Finally connect to the VM

```
vagrant ssh core-01 -- -A
```

(optional) Howto delete previous keys from old VM

```
ssh-keygen -f "/home/albert/.ssh/known_hosts" -R [127.0.0.1]:2222
ssh-keygen -f "/home/albert/.fleetctl/known_hosts" -R [127.0.0.1]:2222
```

#### Shared Folder Setup

There is optional shared folder setup.
Bya default is shared the fleetctl folder of the project.
You can try it out by adding a section to your Vagrantfile like this.

```
config.vm.network "private_network", ip: "172.17.8.150"
config.vm.synced_folder ".", "/home/core/share", id: "core", :nfs => true,  :mount_options   => ['nolock,vers=3,udp']
```

After a 'vagrant reload' you will be prompted for your local machine password.

#### Configuration

The Vagrantfile will parse a `config.rb` file containing a set of options used to configure your CoreOS cluster.

By default it will try to launch a 3 cores node of a single machine cluster, you can change this behaviour by modifiying the Vagrant file and config.rb file.

## Cluster Setup

Launching a CoreOS cluster on Vagrant is as simple as configuring `$num_instances` in a `config.rb` file to 3 (or more!) and running `vagrant up`.
Make sure you provide a fresh discovery URL in your `user-data` if you wish to bootstrap etcd in your cluster.

## New Box Versions

CoreOS is a rolling release distribution and versions that are out of date will automatically update.
If you want to start from the most up to date version you will need to make sure that you have the latest box file of CoreOS.
Simply remove the old box file and vagrant will download the latest one the next time you `vagrant up`.

```
vagrant box remove coreos --provider virtualbox
```

## Docker Forwarding

By setting the `$expose_docker_tcp` configuration value you can forward a local TCP port to docker on
each CoreOS machine that you launch. The first machine will be available on the port that you specify
and each additional machine will increment the port by 1.

Follow the [Enable Remote API instructions][coreos-enabling-port-forwarding] to get the CoreOS VM setup to work with port forwarding.

[coreos-enabling-port-forwarding]: https://coreos.com/docs/launching-containers/building/customizing-docker/#enable-the-remote-api-on-a-new-socket

Then you can then use the `docker` command from your local shell by setting `DOCKER_HOST`:

    export DOCKER_HOST=tcp://localhost:2375
