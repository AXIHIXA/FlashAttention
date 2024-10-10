cmake_minimum_required(VERSION 3.20)
project(FlashAttention CUDA CXX)
set(CMAKE_CUDA_ARCHITECTURES 75)
set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CXX_STANDARD 17)


# External dependencies
find_program(CCACHE_FOUND ccache)

if (CCACHE_FOUND)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
endif ()

find_package(gflags REQUIRED)
find_package(OpenMP REQUIRED)


# Compile cutlass sources as CUDA files...
# Note that CMake file(GLOB...) command should NOT be used for target sources!
# That's because CMake re-generates build system iff. CMakeLists.txt gets modified.
# Such a command will have CMakeLists.txt untouched when source files are added/removed.
# See https://cmake.org/cmake/help/latest/command/file.html#filesystem.
set(CUTLASS_INCLUDE_DIR cutlass/include)
file(GLOB_RECURSE CUTLASS_SOURCE_FILES ${CUTLASS_INCLUDE_DIR}/*/*.h*)
set_source_files_properties(${CUTLASS_SOURCE_FILES} PROPERTIES LANGUAGE CUDA)


# Executable
set(FAI fai)
add_executable(${FAI}
        include/common/common.cuh
        include/common/cuda_timer.cuh
        include/common/logging.h
        include/common/tensor.cuh
        include/common/tester.cuh
        include/common/util.cuh
        include/kernel/flash_attn_v2/alibi.cuh
        include/kernel/flash_attn_v2/block_info.cuh
        include/kernel/flash_attn_v2/flash.cuh
        include/kernel/flash_attn_v2/flash_fwd_kernel.cuh
        include/kernel/flash_attn_v2/flash_fwd_launch_template.cuh
        include/kernel/flash_attn_v2/kernel_traits.cuh
        include/kernel/flash_attn_v2/kernel_traits_sm90.cuh
        include/kernel/flash_attn_v2/softmax.cuh
        include/kernel/flash_attn_v2/static_switch.cuh
        include/kernel/flash_attn_v2/utils.cuh
        include/ops/flash_attn_v2.cuh
        src/kernel/flash_attn_v2/flash_fwd_hdim32_fp16_sm80.cu
        src/kernel/flash_attn_v2/flash_fwd_hdim64_fp16_sm80.cu
        src/kernel/flash_attn_v2/flash_fwd_hdim96_fp16_sm80.cu
        src/kernel/flash_attn_v2/flash_fwd_hdim128_fp16_sm80.cu
        src/kernel/flash_attn_v2/flash_fwd_hdim160_fp16_sm80.cu
        src/kernel/flash_attn_v2/flash_fwd_hdim192_fp16_sm80.cu
        src/kernel/flash_attn_v2/flash_fwd_hdim224_fp16_sm80.cu
        src/kernel/flash_attn_v2/flash_fwd_hdim256_fp16_sm80.cu
        src/ops/flash_attn_v2.cu
        src/main.cu
)
target_compile_definitions(${FAI} PUBLIC

)
target_compile_options(${FAI} PUBLIC
        $<$<AND:$<CONFIG:DEBUG>,$<COMPILE_LANGUAGE:CUDA>>:-G>
        $<$<AND:$<CONFIG:DEBUG>,$<COMPILE_LANGUAGE:CUDA>>:-Xptxas=-v>
        $<$<COMPILE_LANGUAGE:CUDA>:--expt-relaxed-constexpr>
        -Xcompiler -fopenmp
)
target_include_directories(${FAI} PUBLIC
        ${CUTLASS_INCLUDE_DIR}
        include
)
target_link_libraries(${FAI} PUBLIC
        ${GFLAGS_LIBRARIES}
        cudart
        OpenMP::OpenMP_CXX
)
