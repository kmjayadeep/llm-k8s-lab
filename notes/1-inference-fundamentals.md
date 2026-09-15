# AI Inference Fundamentals

## Request

Prompt -> tokenize -> prefill -> repeated decode -> stop

Prefill phase computes the first token by passing the token vectors through all layers. A KV cache is built at this stage to store the key and value vectors for each layer for each token. 

The repeated decode computes the next token repeatedly. It reuses the KV cache.

Prefill is compute heavy, and repeated decode is memory heavy. KV cache is used to avoid recomputing previously generated tokens in the decode phase.
