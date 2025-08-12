# Windows host with unprivileged users

**NB:** If you have access to a Windows user with administrative rights, you don't need to set up a Linux VM to allow incoming SSH connections to the VS Code server. In that case, it suffices to install the _SSH service_ on Windows (from the official _Additional components_) and enable it at startup. Of course, VS Code must be installed too (the VS Code server will be automatically set up the first time an SSH connection is established).

## Basic functioning and initial setup (user side)
You will connect through SSH to a Fedora VM with pre-installed Visual Studio Code. For simplicity, this VM is made reachable through a Tailscale connection, which I will share with your team soon (see instructions in the email I sent). You are administrators of the VM, meaning you can install whatever software you need on the OS yourselves, including the required Python environment. Being the operating system Fedora, you can install applications on the OS using the **dnf** package manager (`sudo dnf install ...`).

For the development of Python-based applications, the suggestion is always to rely on virtual environments (e.g., _venv_ or _conda_). Note that _venv_ requires the desired Python version to be installed <ins>before</ins> creating the virtual environment. Besides, _venv_ does not work on Virtualbox VMs when creating the virtual environment in a folder shared between the host and the VM, due to a security vulnerability that would be introduced by _venv_ creating symlinks for the functioning of a virtual environment. Conversely, _conda_ is suggested as a better alternative to _venv_ in VMs and, more generally, in Linux systems. It is easy to install and perfectly supported by Visual Studio Code, which makes running scripts in _conda_ environments extremely simple.

### Preparation of a virtual environment with _conda_
To prepare the development environment on the VM using _conda_, we can run the instructions that follow (on a terminal session opened in the VM's virtual screen or after connecting through SSH to the VM).

**Conda** is contained in the default repositories of many distributions. **gcc** is sometimes needed to install (compile) Python packages correctly when installing them with "pip".
```
sudo dnf install conda gcc
sudo conda init
```

Log out and log in with your user to apply changes made by `conda init`.

Creating a new virtual environment and installing the Python version of interest (THERE'S NO NEED TO USE sudo WITH CONDA!).
```
cd ~   #Moving to the home directory shouldn't be needed, but it ensures the virtual environment is created in the default location
conda create -n <environment_name> python=<version_number>   #Example: conda create -n myenv python=3.13.2
conda activate -n <environment_name>
pip install -r requirements.txt
```

If you did something wrong and want to restart from the beginning, delete the created environment (see below) and reinstall it following the instructions above.
```
conda-env remove -n <environment_name>
```

The _requirements.txt_ file can be created through a `pip freeze > requirements.txt` command launched from the environment we want to copy. If the installation of the requirements produces errors, it is sufficient to comment (#) in the requirements file all packages showing incompatibilities with the others, one by one. This is pretty common when reproducing environments created on different OSs or with different approaches (e.g., using _venv_ instead of _conda_).

Once prepared, the conda environment will be automatically detected by VS Code and become directly selectable for running code and notebooks, even when connecting to the host through SSH. To execute code using a specific conda environment, choose the "Kernel select" button on the top-right corner of the editor (after having the project folder and the script of interest opened).

# Establish the connection
The VM allows for multiple simultaneous SSH connections from the outside, meaning that members of the same team can work simultaneously using the same connection. However, remember that **each team member should work on different scripts and data to avoid writing conflicts. Thus, organize your work accordingly!**

An easy way to connect is by downloading the "Remote SSH" extension onto your local VS Code installation. This will start up the VS Code Server installed on the VM and enable the usage of its resources to run scripts stored locally on the VM. **The credentials to log in to the VM with SSH are the same as those used for the Windows host.**

The VM is hosted on the same PC you can access with Windows' Remote Desktop Protocol (RDP), implying the data and scripts you access and modify are the same with either method. In the VM, the data are mounted on the following path, which is also the one you probably want to open with VS Code (this or one of its subfolders, as you need): */media/sf_<original_folder_name_in_Windows>*
