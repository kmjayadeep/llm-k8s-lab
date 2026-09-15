# Running a LLM in Docker Compose

Compose files are in [compose/](compose/) directory.

Important bits:
* kfd and dri devices are passed through to the container
* added group_add `video`
* HIP_VISIBLE_DEVICES=0 to use the AMD GPU
* huggingface cache
* --max-model-len is the context window limit (input+output)
* --enforce-eager: for better compatibility, lower performance (tune later)

With 0.75 gpu memory utilization, `nvtop` shows exactly 75% allocated to vllm

1. Qwen 2.5-0.5b-instruct

```
docker compose -f compose/1-qwen2.5-0.5b-instruct/compose.yaml up -d

dc -f compose/1-qwen2.5-0.5b-instruct/compose.yaml logs -f
```

0.5b params * 16bits (fp16 dtype) ~ 1GB vram

from logs,

```
[default_loader.py:293] Loading weights took 1.56 seconds
[gpu_model_runner.py:4221] Model loading took 0.99 GiB memory and 2.717201 seconds
[gpu_worker.py:373] Available KV cache memory: 9.25 GiB
[kv_cache_utils.py:1307] GPU KV cache size: 808,192 tokens
[kv_cache_utils.py:1312] Maximum concurrency for 2,048 tokens per request: 394.62x
[kernel_warmup.py:44] Skipping FlashInfer autotune because it is disabled.
[core.py:278] init engine (profile, create kv cache, warmup model) took 3.19 seconds
```


## Testing

```
curl -s http://127.0.0.1:8000/v1/models | jq
```

```json
{
  "object": "list",
  "data": [
    {
      "id": "Qwen/Qwen2.5-0.5B-Instruct",
      "object": "model",
      "created": 1789482322,
      "owned_by": "vllm",
      "root": "Qwen/Qwen2.5-0.5B-Instruct",
      "parent": null,
      "max_model_len": 2048,
      "permission": [
        {
          "id": "modelperm-b9a472a2a6773cfc",
          "object": "model_permission",
          "created": 1789482322,
          "allow_create_engine": false,
          "allow_sampling": true,
          "allow_logprobs": true,
          "allow_search_indices": false,
          "allow_view": true,
          "allow_fine_tuning": false,
          "organization": "*",
          "group": null,
          "is_blocking": false
        }
      ]
    }
  ]
}
```

2. Qwen 3.5-2b

using a more recent rocm container


2b params * 16bits (fp16 dtype) ~ 4GB vram

additionally i had to set max-num-seqs to 32

supports reasoning, added `--reasoning-parser qwen3`

chosen only llm, and skipped image and vision
