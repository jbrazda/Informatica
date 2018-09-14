# Install Rancher OS host for docker Host on Vmware Player

Download iso image from
https://releases.rancher.com/os/latest/rancheros.iso

Original Instructionss
http://rancher.com/docs/os/running-rancheros/server/install-to-disk/

1. Create new VM Type Liunx Kerner 3.x 64 bit
2. Set Max Vm HDD size to 10 GB (split files)
3. Set VN Memory to 2GB
4. Point vm to downloaded  iso image
5. Boot the VM, it will star logged in as rancher user with no password. Use `sudo passwd rancher` to set password so you can scp the config file for installation
6. Create cloud-config.yml file

    ```yml
    #cloud-config
    ssh_authorized_keys:
      + ssh-rsa <yourkey> rancher
    #optionally set the hostname and other vm params
    # hostname: rancheros_docker
    # rancher:
    #   console: ubuntu
    #   network:
    #     interfaces:
    #       eth1:
    #         address: 172.68.1.100/24
    #         gateway: 172.68.1.1
    #         mtu: 1500
    #         dhcp: false
    ```

7. Upload the created yaml file using `scp cloud-config.yml rancher@<ipof the VM after boot>` (use passord previously updated by sudo)

    ```text
    $ scp cloud-config.yml rancher@192.168.106.129:.
    The authenticity of host '192.168.106.129 (192.168.106.129)' can't be established.
    ECDSA key fingerprint is SHA256:Sm7KoyDt0qFJsKePWWQByK7PqnJhJORlVT5KZZy/awM.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '192.168.106.129' (ECDSA) to the list of known hosts.
    rancher@192.168.106.129's password:
    cloud-config.yml
    ```

8. Install rancherOS onto the VM /dev/sda using `sudo ros install -c cloud-config.yml -d /dev/sda`
9. After reboot login to isntalled RancherOS using your ssh keys `ssh rancher@<yourvmip>`

I prefer to use ubuntu as console, either enable ubuntu console right within isntallation on cloud-config.yml
or sitch the console later

```text
$ sudo ros console switch ubuntu
Switching consoles will
1. destroy the current console container
2. log you out
3. restart Docker
Continue [y/N]:y
Pulling console (rancher/os-ubuntuconsole:v0.5.0-3)...
v0.5.0-3: Pulling from rancher/os-ubuntuconsole
6d3a6d998241: Pull complete
606b08bdd0f3: Pull complete
1d99b95ffc1c: Pull complete
a3ed95caeb02: Pull complete
3fc2f42db623: Pull complete
2fb84911e8d2: Pull complete
fff5d987b31c: Pull complete
e7849ae8f782: Pull complete
de375d40ae05: Pull complete
8939c16614d1: Pull complete
Digest: sha256:37224c3964801d633ea8b9629137bc9d4a8db9d37f47901111b119d3e597d15b
Status: Downloaded newer image for rancher/os-ubuntuconsole:v0.5.0-3
switch-console_1 | time="2016-07-02T01:47:14Z" level=info msg="Project [os]: Starting project "
switch-console_1 | time="2016-07-02T01:47:14Z" level=info msg="[0/18] [console]: Starting "
switch-console_1 | time="2016-07-02T01:47:14Z" level=info msg="Recreating console"
Connection to 127.0.0.1 closed by remote host.
```

Install git

```shell
sudo apt-get update
sudo apt-get install git
```

## Enable Rancher server

Install and enable rancher server and and rancher-compose
This allows to run docker-compose configurations on rancher os

```shell
sudo ros service enable rancher-server
```

follow
http://rancher.com/docs/rancher/v1.6/en/cattle/rancher-compose/