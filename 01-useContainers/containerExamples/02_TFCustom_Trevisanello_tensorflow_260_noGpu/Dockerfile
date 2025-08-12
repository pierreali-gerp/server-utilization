# Starting public container image from which we'll develop our custom version
#FROM tensorflow/tensorflow:latest-gpu
#FROM tensorflow/tensorflow:2.6.0-gpu
FROM tensorflow/tensorflow:2.6.0

# Set the Working directory for all the subsequent operations in this DockerFile.
# PS: By doing so, "/tf" will become a sort of "home" folder for our container. Thus, after creating the container
#     image and running the container, we might decide to mount on "/tf" the directory containing our Python scripts
#     to be executed within the container.
WORKDIR /tf

# Set desired Python version (environment variable)
# NB: It is better to set the same version of Python used in the container pulled at the beginning.
#     For example, the container "tensorflow/tensorflow:2.6.0" runs Python 3.6
ENV python_version 3.6

# Install desired Python version (the current TF image is based on Ubuntu)
RUN apt-get install -y python${python_version}

# The following command sets the default Python version, so you won't need to call it in its extended form
# (e.g., python3.6) when executing scripts in the container.
# Set default version for root user - modified version of this solution: https://jcutrer.com/linux/upgrade-python37-ubuntu1810
RUN update-alternatives --install /usr/local/bin/python python /usr/bin/python${python_version} 1

# Update pip: https://packaging.python.org/tutorials/installing-packages/#ensure-pip-setuptools-and-wheel-are-up-to-date
RUN python -m pip install --upgrade pip==20.2.4 setuptools wheel

# By copying over requirements first, we make sure that Docker will "cache"
# our installed requirements in a dedicated FS layer rather than reinstall
# them on every build. Furthermore, the "requirements" file will be copied to the containers' working directory,
# allowing for using it directly from there with the next command.
# ------ OPT1: Python libraries without versions (the most recent will be installed)
# COPY requirements.txt requirements.txt
# ------ OPT2: Python libraries with the specific versions used in the original environment (recommended approach if you want
#			   to replicate an already-tested environment)
COPY requirements_conVersioni.txt requirements.txt
# ------

# Install the requirements
RUN python -m pip install -r requirements.txt

