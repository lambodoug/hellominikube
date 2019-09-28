VENV ?= ./.hellominikube
PYTHON_EXE ?= python3
PYTHON_OK := $(shell type -P ${PYTHON_EXE})
KUBECTL_OK := $(shell type -P kubectl)
MINIKUBE_OK := $(shell type -P minikube)

check_kubectl:
	@echo '*********** Checking for kubectl installation **********'
    ifeq ('$(KUBECTL_OK)','')
	    $(error package 'kubectl' not found!)
    else
	    @echo Found kubectl!
    endif

check_minikube:
	@echo '*********** Checking for minkube installation **********'
    ifeq ('$(MINIKUBE_OK)','')
	    $(error package 'minikube' not found!)
    else
	    @echo Found minikube!
    endif

check_python:
	@echo '*********** Checking for Python installation ***********'
    ifeq ('$(PYTHON_OK)','')
	    $(error python interpreter: '${PYTHON_EXE}' not found!)
    else
	    @echo Found Python
    endif

setup_venv: check_python
	@echo '****** Creating virtualenv and installing Ansible ******'
	${PYTHON_EXE} -m venv $(VENV)
	${VENV}/bin/pip install --upgrade pip
	${VENV}/bin/pip install -r requirements-dev.txt
	@echo '*************** Installation Complete ******************'

setup_minikube: check_minikube
	@echo '****** Setting up Minikube ******'
	minikube stop
	minikube delete
	minikube start

install: setup_venv setup_minikube

test: check_python
	find . -type f -name '*.pyc' -delete
	${VENV}/bin/pytest -s --cov=./helloworld --no-cov-on-fail --cov-config=.coveragerc ./helloworld

run_ansible: check_kubectl check_minikube
	minikube start
	${VENV}/bin/ansible-playbook -i inventory.cfg helloworld.yml

clean: check_minikube check_python
	minikube stop
	minikube delete
	rm -rf ${VENV}
