// Copyright (c) 2023, Tri Dao.

// Splitting the different head dimensions to different files to speed up compilation.

#include "kernel/flash_attn_v2/flash_fwd_launch_template.cuh"

template <>
void run_mha_fwd_<cutlass::half_t, 192>(Flash_fwd_params &params, cudaStream_t stream) {
    run_mha_fwd_hdim192<cutlass::half_t>(params, stream);
}