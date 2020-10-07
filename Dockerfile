FROM python:3.8-alpine
LABEL Name=dockeransible Version=0.0.1

ENV ANSIBLE_VERSION 2.10.0

# Python:
# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#id9
# Acept Ansible requrements.txt

ENV BUILD_PACKAGES \
    python3  \
    py3-boto \
    py3-dateutil \
    py3-httplib2 \
    py3-jinja2 \
    py3-paramiko \
    py3-pip \
    py3-setuptools \
    py3-cryptography \
    py3-yaml 

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1
# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Base packages:
RUN set -x && \
    \
    echo "==> Base package install..."  && \
    apk add --update --no-cache \
    bash \
    ca-certificates \
    curl \
    git \
    openssh \
    sshpass \
    tar \ 
    unzip \
    wget \
    && \
    rm -rf /var/cache/* /var/tmp/* /tmp/* && \
    mkdir /var/cache/apk 

# Install Python packages ...
RUN set -x && \
    \
    echo "==> Python package install......"  && \
    apk add --update --no-cache ${BUILD_PACKAGES} && \
    rm -rf /var/cache/* /var/tmp/* /tmp/* && \
    mkdir /var/cache/apk 

# Install dev libraries for Python ...

RUN set -x && \
    \
    echo "==> Adding temperary Build-dependencies..." && \
    apk --update add --virtual build-dependencies \
    gcc \
    musl-dev \
    python3-dev \
    libffi \
    libffi-dev \
#    linux-headers \
    openssl-dev

# Install pip packages ...
RUN set -x && \
    \
    echo "==> Python pip package install......"  && \
    pip install --upgrade pip && \   
    pip install python-keyczar \
                docker-py  && \
    rm -rf /var/cache/* /var/tmp/* /tmp/* && \
    mkdir /var/cache/apk 

# Install Ansible with python pip packages ...
#RUN set -x && \
#    \
#    echo "==> Installing Ansible with python pip..."  && \
#    python -m pip install --user ansible && \
#    python -m pip install --user paramiko && \
#    pip install ansible==${ANSIBLE_VERSION}

# Install Ansible with python pip requrements.txt ...
ADD requirements.txt .
RUN set -x && \
    \
    echo "==> Installing Ansible with pip requirements.txt..."  && \
    pip install -r requirements.txt

# Makes the Ansible directories
RUN set -x && \
    echo "==> Makes the Ansible directories..."  && \
    mkdir -p /etc/ansible /ansible && \
    mkdir -p /ansible/playbooks && \
    mkdir ~/.ssh

# Download Ansible tar file (curl)
#RUN set -x && \
#    \
#    echo "==> Download Ansible tar file..."  && \
#    curl -fsSL https://releases.ansible.com/ansible/ansible-${ANSIBLE_VERSION}.tar.gz -o ansible.tar.gz
# Extracts Ansible from the tar file
#RUN set -x && \
#    \
#    echo "==> Extract Ansible tar file..."  && \
#   tar -xzf ansible.tar.gz -C /ansible --strip-components 1 && \
#   rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

# Adding localhosts for Ansible...
RUN set -x && \
    echo "==> Adding localhosts for Ansible..."  && \
    echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

# Over rides SSH Hosts Checking
RUN echo "host *" >> ~/.ssh/config &&\
    echo "StrictHostKeyChecking no" >> ~/.ssh/config

# Cleaning up Build-dependencies 
RUN set -x && \
    echo "==> Cleaning up Build-dependencies ..."  && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* 

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH
ENV ANSIBLE_LIBRARY /ansible/library


WORKDIR /ansible/playbooks

# Sets entry point (same as running ansible-playbook)
# ENTRYPOINT ["ansible-playbook"]

# Can also use ["ansible"] if wanting it to be an ad-hoc command version
# ENTRYPOINT ["ansible"]

CMD ["/sbin/init"]
