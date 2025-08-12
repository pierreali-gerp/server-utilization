# Run a container with Podman or Docker

Below are some common examples of commands to launch containers.

But, first, a few notes regarding these commands:

- The `-it` flags are used to launch an interactive session of the container, which, after startup, will remain open awaiting input from the user.
- The `--rm` flag ensures that the container is automatically removed after it is stopped. Generally, it's a good practice to use it, but you can remove it if it’s necessary to reuse the same container in subsequent sessions (thus preserving the RAM occupied by the container, any workspaces, etc.). **Note:** While the _container_ will be removed using this flag, the _container image_ will not and can be used to launch new containers based on the same image!

## Run a container with GPU support

Here's the general command to execute a container that utilizes the GPU and reads/writes to the host folder with the host user's name (i.e., not root). This should be used to start the container on which the GPU implementation of TensorFlow or PyTorch and all useful Nvidia and Python libraries are installed.
```bash
# With Podman (no need to specify uid and gid because the user executing Podman is taken by default)
podman run -v <host_path>:<mount_point_in_container> -it --rm --device nvidia.com/gpu=all <domain_name>/<container_name>:<optional_tag>
# With Docker (specifying the uid and gid of the current user, automatically obtained with the "id" command)
docker run -u $(id -u):$(id -g) -v <host_path>:<mount_point_in_container> -it --rm --gpus all <domain_name>/<container_name>:<optional_tag>
```

Example:
```bash
# With Podman
podman run -v /home/utentetest/Documents/tesi:/tf/tesi -it --rm --device nvidia.com/gpu=all tensorflow/tensorflow:2.12.0-gpu
# With Docker
docker run -u $(id -u):$(id -g) -v /home/utentetest/Documents/tesi:/tf/tesi -it --rm --gpus all tensorflow/tensorflow:2.12.0-gpu
```

> ⚠️ If `podman run` fails with an error related to the CDI manifest, this is likely because Nvidia drivers have been updated, but not the CDI manifest. To do so, launch `sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml`, which will overwrite the previous _nvidia.yaml_ configuration file with an updated version. After this, try to restart the container with the same command: it should work nicely (with no need to reboot).

## Run a container with CPU support only

Here's the general command to run a container that leverages only the CPU and reads/writes to a host's folder using the host's user (i.e., not root). Typically, this does not work with TensorFlow containers with GPU libraries installed, but only with those with CPU-only libraries (i.e., those without the "gpu" tag).
```bash
# With Podman (no need to specify uid and gid because the user's uid and gid are used by default)
podman run -v <host_path>:<mount_point_in_container> -it --rm <domain_name>/<container_name>:<optional_tag>
# With Docker (it's necessary to specify the uid and gid of the current user, automatically obtained with the "id" command)
docker run -u $(id -u):$(id -g) -v <host_path>:<mount_point_in_container> -it --rm <domain_name>/<container_name>:<optional_tag>
```

Examples:
```bash
# With Podman:
podman run -v /home/utentetest/Documents/tesi:/tf/tesi -it --rm tensorflow/tensorflow:2.12.0
# With Docker:
docker run -u $(id -u):$(id -g) -v /home/utentetest/Documents/tesi:/tf/tesi -it --rm tensorflow/tensorflow:2.12.0
```

## Run a container with a specific amount of resources with Docker (usually not needed)

With Docker, it's also possible to start a container limiting its access to the host's resources. For example (_ubuntu_ is the name of the container image we are starting):

```bash
# Run a container on Docker using all available GPUs on the VM:
docker run --rm --gpus all ubuntu nvidia-smi
# Run a container on Docker using a specific GPU available on the VM (numbering starts from 0):
docker run --rm --gpus device=0 ubuntu nvidia-smi
# Run a container without seizing all resources present on a machine (especially useful when the machine is shared among multiple users):
docker run -it --rm --memory 32g --cpus 10 --gpus device=0 ubuntu #This uses a maximum of 32 GB of RAM, 10 CPU cores, and the 1st graphics card (with "device=1", it will select the 2nd).
```
	
----
	
# And once we are on the container?

Once the container is started, you'll be able to execute code by launching (inside the container):

```bash
python <path_to_script>
```

Alternatively, to use a specific version of Python if there are multiple installed, and you want to use one different from the default (remember that libraries installed with `pip` will only be present for the Python version for which they were installed during the container creation phase!):

```bash
python3.8 <path_to_script>
```

If this doesn't work (e.g., script not found error), make sure you are in the folder where the script of interest is located. Some useful commands in that sense (to be executed inside the container):

```bash
pwd        #shows the current working directory
ls         #shows the files and folders located inside the directory
cd <path>  #allows you to enter the requested path (absolute or relative)
cd ..      #allows you to go up one folder from the current path
```
