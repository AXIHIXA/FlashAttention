// Description: cuda timer

#pragma once

#include "common/common.cuh"


class CudaTimer
{
public:
    FAI_DISALLOW_COPY_AND_ASSIGN(CudaTimer);

    explicit CudaTimer(cudaStream_t stream = nullptr) : m_stream(stream)
    {
        FAI_CHECK_CUDART_ERROR(cudaEventCreate(&m_start));
        FAI_CHECK(m_start);
        FAI_CHECK_CUDART_ERROR(cudaEventCreate(&m_end));
        FAI_CHECK(m_end);
    }

    ~CudaTimer()
    {
        if (m_start)
        {
            FAI_CHECK_CUDART_ERROR(cudaEventDestroy(m_start));
            m_start = nullptr;
        }

        if (m_end)
        {
            FAI_CHECK_CUDART_ERROR(cudaEventDestroy(m_end));
            m_end = nullptr;
        }
    }

    void start()
    {
        FAI_CHECK_CUDART_ERROR(cudaEventRecord(m_start, m_stream));
    }

    float end()
    {
        FAI_CHECK_CUDART_ERROR(cudaEventRecord(m_end, m_stream));
        FAI_CHECK_CUDART_ERROR(cudaEventSynchronize(m_end));
        FAI_CHECK_CUDART_ERROR(cudaEventElapsedTime(&m_elapsed_time, m_start, m_end));

        return m_elapsed_time;
    }

private:
    const cudaStream_t m_stream = nullptr;

    cudaEvent_t m_start = nullptr;
    cudaEvent_t m_end = nullptr;

    float m_elapsed_time = 0.0;
};
