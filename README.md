# hellominikube


A simple Python 3 Flask app with code to run the app in a container in minikube with load balancing

## Initial checkout and setup of codebase

* Open terminal and move to a suitable directory on your machine
* Run ``git clone git@github.com:lambodoug/hellominikube.git``
* Run ``cd hellominikube``

### Installation

To install the project locally you need to run ``make install``. You can also pass ``VENV`` and ``PYTHON_EXE`` keyword arguments
to the make file to configure the installation e.g

* ``make install`` - Installs dependencies with defaults
* ``make install VENV=foo`` - Installs into a virtualenv named ``foo``
* ``make install PYTHON_EXE=python3.7`` - Installs with a specific python interpreter, example values might be ``python`` or ``python3.6``. This defaults to ``python3``.

Please ensure that you have ``kubectl`` and ``minikube`` installed on your system and that they are both on the system path.

### Deploying the app to minikube

Once the steps above have been run, you should have a virtualenv setup with ansible and test dependencies installed. Your local
instance of ``minikube`` will have also been, cleaned, reset and started ready to accept our deployment. The next step is to run
The make command which will execute ansible to run configuration management on the cluster. This includes installing our kubernetes namespace and our
kubernetes deployment and service. We are just going to use ansible to do everything. Let's run the commands below.

* ``make run_ansible``

Once that is complete, we'll check out setup with a few quick commands
* ``kubectl get ns`` - shows our new namespace
* ``kubectl get pods -n hellominikube`` - shows our helloworld app pods
* ``kubectl get services -n hellominikube`` - shows our load balancing service

Once all of our pods are ready, our deployment is complete. You can check for the deployment being ready using the command below:

    kubectl get deployments -n hellominikube

Once this command shows ``4`` under the ``AVAILABLE`` column, we are ready to view our deployed app. To see our app running under
our load balancer enter the below command in to your terminal. This will cause a new browser window to open and our app to load.

    minikube service helloworld --namespace hellominikube

You should now see the hello world homepage along with the current pod's IP, name and namespace. If you refresh this page over and over,
you will see the IP address of the POD change showing the load balancer in action.

### Running tests

To run the tests for the project locally you need to run ``make test``. This will run pytest with coverage.
Please note that if you have not followed the previous Installation steps above and run ``make install``, this will not work.


## Project Docker Hub Builds

To build the image that will be deployed to our minikube instance, we use [Docker Hub's](https://hub.docker.com/r/lambodoug/hellominikube)
GitHub integration. This integration allows Docker Hub to automatically detect changes to the project's ``Dockerfile`` and build and tag relevant
versions of the build to store in their registry. Obviously for private projects, images would not be hosted on a public docker hub. However, for this
open source example project it will be fine.
