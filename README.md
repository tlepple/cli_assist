# cli_assist



---

---

## Notes:
*  This was built and tested on Docker Version 19.03.8
*  This assumes you already have Docker installed.
*  All steps below are run from a terminal window

---

### Docker Setup Steps:

---

```
# Pull docker image centos 7
docker pull centos:7

# Create a docker volume to persist data
docker volume create cli-assist-vol1

# inspect volume
docker volume inspect cli-assist-vol1

# list volumes
docker volume ls



# run a new docker container with this volume from centos image

 docker run -it \
  --name centos_cli_assist \
  --mount source=cli-assist-vol1,target=/app \
  centos:7 bash

```

---

### Pull git repo into this new container to setup CDP Pre-Reqs

```
# install git 
yum install -y git
cd /app
git clone https://github.com/tlepple/cli_assist.git
cd /app/cli_assist
```

---



---

# Install cli tool into this docker container

```
cd /app/cli_assist

# run the build
. provider/aws/aws_setup.sh

```


---
# Test that it is working for cli items

```
# python
python --version

# aws
aws --version

# CDP
cdp --version
```

---

# Usefull docker command reference:

---

```
# list all containers on host
---------------------------------------------
docker ps -a

#  start an existing container
---------------------------------------------
docker start centos_cli_assist

# connect to command line of this container
---------------------------------------------
docker exec -it centos_cli_assist bash

#list running container
---------------------------------------------
docker container ls -all

# stop a running container
---------------------------------------------
docker container stop centos_cli_assist

# remove a docker container
---------------------------------------------
docker container rm centos_cli_assist

# list docker volumes
---------------------------------------------
docker volume ls

# remove a docker volume
---------------------------------------------
docker volume rm cli-assist-vol1


```
