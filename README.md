# Sample Flash Attention Demo

A light-weight forward-pass-only Flash Attention V2. 
Removes backward-, training- and V1-related code in the vanilla implementation of Flash Attention. 
Tested on NVIDIA Geforce RTX 2080 Ti GPU, 8.167 TFLOPS for fp16 Flash MHA. 


Credits to: 
- [Dao-AILab/flash-attention](https://github.com/Dao-AILab/flash-attention) for the vanilla original implementation. 
- [Bruce-Lee-LY/flash_attention_inference](https://github.com/Bruce-Lee-LY/flash_attention_inference) for the frontend boilerplates. 


Dependencies:
```bash
sudo apt install libgflags-dev ccache
```
