# Litellm

I had litellm deployed in homelab at https://litellm.cosmos.cboxlab.com/

Added the model in it with the following config

Provider: vllm
api_base: "http://192.168.1.83:8000/v1"
api_key: dummy
model: qwen

Then go to <https://litellm.cosmos.cboxlab.com/ui/playground/> and test

Check <https://litellm.cosmos.cboxlab.com/ui/logs/> to inspect the logs
