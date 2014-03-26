ansible-clusterconfig
=====================

Ansible playbook configure below list of Clusters

Zookeeper (on Multi node)
Cassandra (on Multi node)
Spark     (on Single node)


Requirements:

    Ansible 1.4.4 or later (pip install ansible)
    6 + 1 Ubuntu 12.04 LTS/13.04/13.10 - see ubuntu-netboot-tftp if you need automated server installation
    "clusterconfig" user in sudo group without sudo password prompt (see Bootstrapping section below)
    
Configure Ansible on Control Machine:

 Copy "initialSetup.sh" from git repo manually and execute on Control Machine to configure latest Ansible and clone "ansible-clusterconfig" automatically
    
TBD: 

-> Modify Spark Ansible script to suit for Multi-node environement.
	
Adding hosts:

Edit the hosts file and list hosts per group (see Inventory for more examples or refer below example):

[mesos]
192.168.2.24 ansible_connection=ssh ansible_ssh_user=username ansible_ssh_pass=password

Note: Make sure that the zookeepers and cassandra groups contain at least 3 hosts and have an odd number of hosts.


Installation:

Follow below steps, To configure Zookeeper, Cassandra, Spark Clusters

-> Navigate to the directory where "site.yml" file located. Execute below command to execute all roles.

./site.sh

    or 

ansible-playbook -i hosts site.yml



To e.g. just install ZooKeeper, add the zookeepers tag as argument (available tags: zookeepers, cassandras, java, mesos, hadoop , spark):

./site.sh zookeepers

       or

ansible-playbook -i hosts site.yml --tags zookeepers


Bootstrapping:

Paste your public SSH RSA key in bootstrap/ansible_rsa.pub and run bootstrap.sh to bootstrap the nodes specified in bootstrap/hosts. See bootstrap/bootstrap.yml for more information.

Note: Execute "bootstrap/bootstrap.sh" before executing "site.yml" with speicific roles, Since bootstrap.sh creates a new user account on remote node.
