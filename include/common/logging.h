// Description: logging

#pragma once

#include <cstdio>
#include <cstring>
#include <ctime>
#include <sys/syscall.h>
#include <unistd.h>


inline char * curr_time()
{
    time_t raw_time = time(nullptr);
    tm * time_info = localtime(&raw_time);
    static char now_time[64];
    now_time[strftime(now_time, sizeof(now_time), "%Y-%m-%d %H:%M:%S", time_info)] = '\0';
    return now_time;
}

inline int get_pid()
{
    static int pid = getpid();
    return pid;
}

inline long int get_tid()
{
    thread_local long int tid = syscall(SYS_gettid);
    return tid;
}

#define FAI_LOG_TAG "FAI"
#define FAI_LOG_FILE(x) (strrchr(x, '/') ? (strrchr(x, '/') + 1) : x)
#define FLOG(format, ...)                                                                                       \
    do {                                                                                                        \
        fprintf(stderr, "[%s %s %d:%ld %s:%d %s] " format "\n", FAI_LOG_TAG, curr_time(), get_pid(), get_tid(), \
                FAI_LOG_FILE(__FILE__), __LINE__, __FUNCTION__, ##__VA_ARGS__);                                 \
    } while (0)
