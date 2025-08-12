# Starting public container image from which we'll develop our custom version
#FROM tensorflow/tensorflow:2.12.0-gpu
FROM tensorflow/tensorflow:2.16.1-gpu

# Set the Working directory for all the subsequent operations in this DockerFile.
# PS: By doing so, "/tf" will become a sort of "home" folder for our container. Thus, after creating the container
#     image and running the container, we might decide to mount on "/tf" the directory containing our Python scripts
#     to be executed within the container.
WORKDIR /tf

# Set desired Python version (environment variable)
# NB: It is better to set the same version of Python used in the container pulled at the beginning.
#     For example, the container "tensorflow/tensorflow:2.16.1-gpu" runs Python 3.11
ENV python_version=3.11

# Install the desired Python version (the current TF image is be based on Ubuntu at the moment)
# and all the other needed Linux packages (e.g. libgl1-mesa-glx is required for the python package
# "opencv-python")
RUN apt-get update && apt-get install -y \
    python${python_version} \
    python3-pip \
    python${python_version}-distutils \
    graphviz \
    libgl1-mesa-glx

# The following command sets the default Python version, so you won't need to call it in its extended form
# (e.g., "python3.6") when executing scripts in the container.
# Set default version for root user - modified version of this solution: https://jcutrer.com/linux/upgrade-python37-ubuntu1810
RUN update-alternatives --install /usr/local/bin/python python /usr/bin/python${python_version} 1

# Pier: The following it's usually not necessary and that's why it's commented: we should've already
# 	    installed pip from the official Debian's report with the above "apt-get install ..."). However,
#       in some very specific cases, it might be needed, and that's why I've kept it here!
# # Ensure pip is installed for the specified Python version
# RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py

# Pier: Likewise, the following two lines are usually unnecessary and we can skip them (decomment
#       them in case issues arise)
# # Remove all potential problematic directories
# RUN rm -rf /root/.cache/pip/* \
#     && rm -rf /usr/local/lib/python${python_version}/dist-packages/cachecontrol

# Clean pip cache before updating pip
RUN python -m pip cache purge

# Update pip, setuptools, and wheel
# Source: https://packaging.python.org/tutorials/installing-packages/#ensure-pip-setuptools-and-wheel-are-up-to-date
RUN python -m pip install --upgrade pip setuptools wheel

# By copying over requirements first, we make sure that Docker will "cache"
# our installed requirements in a dedicated FS layer rather than reinstall
# them on every build. Furthermore, the "requirements" file will be copied to the containers' working directory,
# allowing for using it directly from there with the next command.
# ------ OPT1: Python libraries without versions (the most recent will be installed). In the absence of specific environment
#		       needs, it might be easier using this approach then the next one. However, in case of version-related issues
#              when installing the requirements or executing Python scripts inside the container, comment the following line
#			   starting with "COPY..." and decomment the one in OPT2 (remember to personalize the relevant "requirements_conVersioni.txt"
			   file) to specify which version of each library to install.
COPY requirements.txt requirements.txt
# ------ OPT2: Python libraries with the specific versions used in the original environment (recommended approach if you want
#			   to replicate an already-tested environment)
# COPY requirements_conVersioni.txt requirements.txt
# ------

# Install the requirements
RUN python -m pip install --no-cache-dir -r requirements.txt
