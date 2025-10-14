# Conda Setup and Basic Usage Instructions

The following instructions show how to install and use **Miniconda**, a lightweight and easy-to-use virtual environment (VENV) manager that seamlessly integrates with VS Code and other IDEs.

Utilizing VENVs is a particularly convenient way to have multiple isolated development environments installed on the same VM, avoiding any conflicts among them. Each VENV can be set up with a different version of the main interpreter (e.g., different Python versions), different libraries, and/or different versions of the same libraries.

Compared to a container image, a VENV typically lacks flexibility and traceability, as a container image can be easily recreated on any system by relying solely on a _Dockerfile_ (or a _docker-compose_ set of instructions, if multiple interoperating containers are needed). Moreover, a container image also embeds a specific operating system, which can differ from the one installed on the VM. Conversely, a VENV totally relies on the operating system installed on the VM for its execution.

## Conda Setup

### Installing on Ubuntu (via the Official Installer)
You can visit the [Miniconda website](https://www.anaconda.com/docs/getting-started/miniconda/install#linux-terminal-installer) for the complete and up-to-date Linux installation instructions. Nevertheless, the steps listed below should suffice in most common cases.

1. **Download the Miniconda Installer**:
   - Move to the _Downloads_ folder of your home with `cd ~/Downloads`
   - Download the Linux installer script. The following command should work (check the official website above for the updated link):
     ```bash
     wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
     ```

3. **Run the Installer**:
   - Make the installer executable:
     ```bash
     chmod +x Miniconda3-latest-Linux-x86_64.sh
     ```
   - Execute the installer script:
     ```bash
     ./Miniconda3-latest-Linux-x86_64.sh
     ```
     **NB:** _sudo_ should **never** be used when **installing or using Miniconda** to avoid any permission issues: it and all its environments should always be set up in the user's home directory to minimize the risk of data loss. **Installing and using Miniconda without _sudo_ ensures that the correct permissions are always set.** 
   - Follow the prompts:
     - Accept the license agreement.
     - Choose the installation location (keep the suggested default in the home folder, which should be similar to `~/miniconda3`).
     - Select to automatically initialize Conda for your user.
     - Close and reopen your terminal, as suggested at the end of the installation. 

4. **Initialize Conda (if you didn't ask the installer to do so for you)**:
   - After installation, run:
     ```bash
     conda init
     ```
   - Restart your terminal

5. **Verify Installation**:
   ```bash
   conda --version
   ```

---

### Installing on Fedora (via `dnf` Package Manager)
If your VM's operating system is Fedora or another RPM-based distribution, a packaged version of Miniconda should be readily available in the official repositories. Installing this version instead of the one from the official website facilitates Miniconda updates.

1. **Install Miniconda**:
   - Use the system package manager.

     **NB:** In this case, we must prepend _sudo_ for the installation because the package manager requires superuser rights.
     ```bash
     sudo dnf install conda
     ```

2. **Initialize Conda**:
   - Run the following command to initialize Miniconda _base_ environment and set up your shell.

     **NB: From now on, DO NOT PREPEND _sudo_ to ensure Conda and its environments are initialized in the user's home directory** and avoid overwriting the _/usr_ directory (which contains system files)!
     ```bash
     conda init
     ```
   - Restart your terminal.

3. **Verify Installation**:
   ```bash
   conda --version
   ```

---

## Basic Conda Usage
### Create and prepare a new Conda environment
1. **Create a Conda Environment**:

   **NB:** Specifying a Python version is always recommended. The available versions are visible on the [official Python project website](https://www.python.org/downloads/). Note that very recent versions (i.e., within a month) may not be available for installation on Conda.
   ```bash
   conda create -n <environment_name> python=<version>
   ```
   Example:
   ```bash
   conda create -n myenv python=3.11
   ```

3. **Activate an Environment**:
   ```bash
   conda activate <environment_name>
   ```

4. **Install Python libraries we need on the activated environment**:
    - One by one:
      ```bash
      pip install <package_name>
      ```
    - Through a requirements.txt file previously created with `pip freeze > requirements.txt`:
      ```bash
      pip install -r requirements.txt
      ```

5. **Install the Nvidia CUDA Toolkit on the activated environment**:

   **Conda is the recommended way to install the Nvidia CUDA Toolkit (NVCT) on your VM**, as it's much easier to set up and update it in a virtual environment rather than installing it directly on the guest OS. Also, note that the _Nvidia CUDA Toolkit_ is different from the more generic _CUDA libraries_, which are most commonly needed by Python applications and already included in the installed compute-oriented (i.e., _gpgpu_) Nvidia drivers. Indeed, the former are usually not required to train/apply models on frameworks as TensorFlow or PyTorch with GPU support, and they are typically requested only by applications requiring low-level access to Nvidia GPU functions. So, the advice is to install the NVCT in your Conda environment only if your application throws an error suggesting this specific package is missing. For additional details and information on how to install only certain components of the NVCT, refer to [this page](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/#conda-installation).
   ```bash
   #NB: You can add the Nvidia CUDA Toolkit to the active Conda environment only if Python has already been installed in it (see steps above).
   conda install cuda -c nvidia
   ```

### Manage existing Conda environments
1. **List the available environments**:
   ```bash
   conda env list
   ```

2. **Deactivate an Environment**:
   ```bash
   conda deactivate
   ```

3. **Remove an Environment**:
   ```bash
   conda env remove -n <environment_name>
   ```
