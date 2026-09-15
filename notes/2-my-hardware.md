# My hardware

```
 lspci -nnk 2>/dev/null | grep -EA3 'VGA|3D|Display' || true

03:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 31 [Radeon RX 7900 XT/7900 XTX/7900 GRE/7900M] [1002:744c] (rev ce)
	Subsystem: ASUSTeK Computer Inc. Device [1043:050c]
	Kernel driver in use: amdgpu
	Kernel modules: amdgpu
--
12:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Raphael [1002:164e] (rev c7)
	Subsystem: Micro-Star International Co., Ltd. [MSI] Device [1462:7d75]
	Kernel driver in use: amdgpu
	Kernel modules: amdgpu
```

AMD 7900 GRE, 16GB VRAM

view usage and such
```
nix-shell -p nvtopPackages.amd

nvtop
```


Devices
```
ls -l /dev/kfd /dev/dri/renderD* 2>/dev/null 
crw-rw-rw-   242,0 root  4 Sep 20:43 /dev/kfd
crw-rw-rw- 226,128 root  4 Sep 20:43 /dev/dri/renderD128
crw-rw-rw- 226,129 root  4 Sep 20:43 /dev/dri/renderD129
```

kfd is the kernel fusion device driver for AMD GPUs, and /dev/dri/renderD* are the render nodes for the GPUs. one for integrated and one for GRE

My mappings (can change)
- /dev/dri/renderD128 → AMD Radeon RX 7900 GRE (dedicated GPU)                                     
- /dev/dri/renderD129 → AMD Raphael integrated GPU


PCI mappings
- 0000:03:00.0 → RX 7900 GRE                                                                       
- 0000:12:00.0 → Raphael iGPU

User also needs to be in `render` or `video` group to access the render nodes.
