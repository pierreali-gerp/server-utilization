
**TO DO:**

Add setup and usage instructions for "Ollama" with "open-webui" (including definition of a specific "OLLAMA_MODELS" folder and SSH tunneling with "ssh -L"). Install the latter in a dedicated conda environment (avoid using containers, as on the internet it is suggested that it is more complicated).

While using open-webui from a container might be complicated (I haven't checked in the last two years if anything changed), ollama can be easily set up with Docker or podman (the latter is suggested), provided that Nvidia CDI manifest has been generated for the passed-through GPU and the currently installed version of the driver. You can find full instructions to run the Ollama container (with Docker) [here](https://ollama.com/blog/ollama-is-now-available-as-an-official-docker-image), but basically you need one command to pull the container from Docker's repo and start it (the `-v` option is to add persistent storage):
```bash
podman run -v <host_path>:/root/.ollama -d --device nvidia.com/gpu=all -p 11434:11434 --name ollama ollama/ollama
```

One command to test container access to the GPU(s):
```bash
podman exec -it ollama nvidia-smi
```

Finally, one command to pull an LLM and test it:
```bash
podman exec -it ollama ollama run gemma4:e2b
```

Now, you may set up open-webui and connect it to the 11434 port, which is mapped from ollama's running container to localhost.