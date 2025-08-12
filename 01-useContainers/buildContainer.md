# Build a container image with Podman or Docker

## Podman vs. Docker
Note that Docker and Podman can be installed simultaneously on many Linux distributions. It's very likely that your system admin has already
installed and configured both tools on your VM, so that you could have the choice to use the tool you prefer.

In general, the usage of Podman is always recommended for two main reasons:
- It is open source (and there should be no need to add anything about the advantages of this!).
- As Podman executes containers in rootless mode by default, it automatically sets the expected permissions on all mounted volumes, ensuring you
  never access your filesystems as "root" by mistake.
- Podman syntax is often identical to Docker and their capabilities are really close (except for some very specific options that are only appliable
  to Docker or Podman).

Thus, the following general advice applies: **you should always prefer Podman over Docker whenever possible.**

## Why should I prefer containers instead of building my environments with Conda or alike?
In general, the advice is to use containers to train your models with GPUs. This is because installing all the libraries necessary to utilize Nvidia GPUs
isn't really _straightforward_. So, rather than configuring the development environment from scratch, the advice is to leverage the pre-made containers
offered by [TensorFlow](https://www.tensorflow.org/install/docker) or [PyTorch](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch),
which already contain, ready to use, all the necessary Nvidia libraries.

Another significant advantage of relying on containers instead of Python environments is the migrability to other VMs: to recreate your container image on
other systems, you just need to bring the DockerFile (which is, basically, a script) to the new system and execute the building command!

## Basics on how to build a custom container
So, the general advice is to build a container with all the Python libraries you need to execute your code. To simplify this process, you can start from one of the models contained in this repository.

Building a container for Python is very simple and requires two files: the **_Dockerfile_**, which contains the instructions that tell Docker/Podman how to create the container, and a **_requirements_** file (_requirements.txt_), which is called by the _Dockerfile_ during container creation and contains the list of Python libraries needed for your project.

The structure of both files is very intuitive, and you can easily understand it on your own by watching the examples provided in this repository. To begin, make a copy of the _Dockerfile_ and _requirements.txt_ files you want to start from and insert them into a folder in your home, which contains no other files besides these two. For example, open the terminal and create a new folder in your home dedicated to the container building environment (replace <username> with your actual username on the Linux system of the VM):

```bash
cd /home/<username>/Documents/
mkdir TFCustomContainer
```

Copy (or create) your _Dockerfile_ and _requirements.txt_ files in this folder. Modify them as you need for your own Python environment.

Afterwards, still from the terminal, we navigate to the folder where you've inserted these two files and run one of the following instructions:

```bash
# With Podman
podman build -t "customPier/tensorflow-gpu" ./
# With Docker
docker build -t "customPier/tensorflow-gpu" ./
```

The name of the new container generated at the end of the process will be: "customPier/tensorflow-gpu". Of course, you can choose the name you prefer for the container when you run this command, but always remember to enclose it in quotes, as above. Furthermore, it's good practice to always specify names for the domain, the container, and the tag, as in the following:

```bash
# With Podman
podman build -t "<domain_name>/<image_name>:<optional_tag>" ./
# With Docker
docker build -t "<domain_name>/<container_name>:<optional_tag>" ./
```

**Note:** The tag is used to distinguish different versions of the same image you are creating. If you don't specify anything, the tag "latest" will be assigned by default.

Once the container creation process is complete, if everything went correctly, it should be available in the list that can be viewed with:

```bash
# On Podman
podman images
# On Docker
docker images
```

At that point, you can run it and use it following the instructions contained in the dedicated markdown file in this repository.
