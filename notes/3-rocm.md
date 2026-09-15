# ROCm

Rocm is the AMD's equivalent of CUDA. It is a software stack that allows you to run PyTorch on AMD GPUs.

```
./scripts/rocm-container.sh
  Name:                    AMD Ryzen 5 7600X 6-Core Processor
  Marketing Name:          AMD Ryzen 5 7600X 6-Core Processor
  Vendor Name:             CPU
  Name:                    gfx1100
  Marketing Name:          AMD Radeon RX 7900 GRE
  Vendor Name:             AMD
      Name:                    amdgcn-amd-amdhsa--gfx1100
      Name:                    amdgcn-amd-amdhsa--gfx11-generic
  Name:                    gfx1036
  Marketing Name:          AMD Ryzen 5 7600X 6-Core Processor
  Vendor Name:             AMD
      Name:                    amdgcn-amd-amdhsa--gfx1036
      Name:                    amdgcn-amd-amdhsa--gfx10-3-generic
PyTorch: 2.9.1+gitff65f5b
HIP: 7.2.53211-e1a6bc5663
Accelerator available: True
Device count: 2
0 AMD Radeon RX 7900 GRE 15.98 GiB
1 AMD Ryzen 5 7600X 6-Core Processor 15.24 GiB
```

Confirms the device 0 is the AMD Radeon RX 7900 GRE, and device 1 is the AMD Ryzen 5 7600X integrated GPU.

These programs are very sensitive to versions. The image I tested is:

```
rocm/vllm-dev:rocm7.2.1_navi_ubuntu24.04_py3.12_pytorch_2.9_vllm_0.16.0
```

it is a 60gb huge image.
