# How setup docker in Azure VM with Ubuntu

If we use the generic images provides from Canonical we get at minimun Ubuntu machine, without visual desktop environment or another packages as notepad++

## Prerequisites
Create an Azure VM with Ubuntu image. Setup it with user and password and add rules for SSH/HTTPS and RDP.

## Install and configure desktop environment

At first, we connect to the VM with a terminal using the password configured when we created the virtual machine in Azure using the following command:

```
ssh myUser@VirtualMachineIP
```

```
sudo apt-get update
sudo apt-get -y install xfce4
sudo apt install xfce4-session
```

## Install and configure remote desktop server

Now that we have a visual dektop environment installed we can configure a remote desktiop service to listen for connections. Execute the following commands

```
sudo apt-get -y install xrdp
sudo systemctl enable xrdp
echo xfce4-session >~/.xsession
sudo service xrdp restart
```

## Install docker

Update the packages list

```
sudo apt update
```
 
Next, install some prerequisite packages that allow apt to use packages over HTTPS:

```
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

Then add the GPG key for the official Docker repository on your system

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
 
Add the Docker repository to the APT sources

```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
```
 
Update docker packages from this repository

```
sudo apt update
 ```

Then install docker:

```
sudo apt install docker-ce
sudo systemctl status docker
```

At last install docker-compose:

```
sudo apt install docker-compose
```

## Docker Compose

```
version: "3"
services:
  chrome:
    image: selenium/node-chrome
    shm_size: 2gb
    restart: always
    depends_on:
      - selenium-hub
    environment:
      - SE_EVENT_BUS_HOST=selenium-hub
      - SE_EVENT_BUS_PUBLISH_PORT=4442
      - SE_EVENT_BUS_SUBSCRIBE_PORT=4443
      - SE_NODE_OVERRIDE_MAX_SESSIONS=true
      - SE_NODE_MAX_SESSIONS=4
  edge:
    image: selenium/node-edge
    shm_size: 2gb
    restart: always
    depends_on:
      - selenium-hub
    environment:
      - SE_EVENT_BUS_HOST=selenium-hub
      - SE_EVENT_BUS_PUBLISH_PORT=4442
      - SE_EVENT_BUS_SUBSCRIBE_PORT=4443
      - SE_NODE_OVERRIDE_MAX_SESSIONS=true
      - SE_NODE_MAX_SESSIONS=4
  selenium-hub:
    image: selenium/hub
    container_name: selenium-hub
    restart: always
    ports:
      - "4442:4442"
      - "4443:4443"
      - "4444:4444"
```

## Ok, all installed How I can run a docker-compose file?

Copy the docker-compose.yml in any destination, for example in desktop after create a new file with "sh" extension in the same destination and paste this lines:

```
#!/bin/bash

echo "Running docker compose"
sudo docker-compose -f docker-compose.yml up -d
```

Open a new terminal an run
```
chmod u+x docker-compose.sh
```

Now you can launch it with 
```
sh docker-compose.sh 
```

## Extra ball

Install Notepad++

```
sudo snap install notepad-plus-plus
```
