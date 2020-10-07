# docker-ansible

Docker image with Ansible inside.  
For consistent running of ansible inside your local machine or CI/CD system.  

## Getting Started

### Prerequisites

 | Software                                      | Version |
 | --------------------------------------------- | ------- |
 | [docker](https://docs.docker.com/get-docker/) |         |
 | [git](https://git-scm.com/downloads)          |         |

### Basic verification of requirements

```{bash}
docker --version
git --version
docker pull mcr.microsoft.com/mcr/hello-world
```

### Installing and running

Build

```{bash}
git clone https://github.com/gehorak/docker-ansible.git
cd ./docker-ansible
docker build -t gehorak/ansible .
```

## Usage

### Run container

```{bash}
docker run -it -d --name ansible -v c:/tmp/ansible:/ansible:rw gehorak/ansible
```

### Use Ansible in container

```{bash}
docker exec -it ansible ansible --version
```

### Use Ansible Galaxy in container

Create Ansible role template

```{bash}
docker exec -it ansible ansible-galaxy role init role_name
```

### Help

```{bash}
docker run --rm -it ansible ansible --help
docker run --rm -it ansible ansible-playbook --help
docker run --rm -it ansible ansible-galaxy --help
```

## Reference

### Official Docker images

| Docker Image                                         | Utilization |
| ---------------------------------------------------- | ----------- |
| [python:3.8-alpine](https://hub.docker.com/_/python) | base image  |

### Software

| Software                                     | Version | Language | Official source of code                     | Utilization |
| -------------------------------------------- | ------- | -------- | ------------------------------------------- | ----------- |
| [ansible](https://www.ansible.com)           | 2.10.0  | Python   | <https://github.com/ansible/ansible>        |             |
| [ansible-playbook](https://www.ansible.com)  | 2.10.0  | Python   | <https://github.com/ansible/ansible>        |             |
| [ansible-galaxy](https://galaxy.ansible.com) | 2.10.0  | Python   | <https://github.com/ansible/galaxy>         |             |
| [ansible-runner](https://galaxy.ansible.com) | 2.10.0  | Python   | <https://github.com/ansible/ansible-runner> |             |

### Resources

[Ansible](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html)
[Ansible Playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)  
[Ansible Galaxy](https://galaxy.ansible.com/docs/)  
[Ansible Runner](https://github.com/ansible/ansible-runner)  

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details  
