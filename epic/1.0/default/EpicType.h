#ifndef VENDOR_SAMSUNG_SLSI_HARDWARE_EPIC_V1_0_EPICTYPE_H
#define VENDOR_SAMSUNG_SLSI_HARDWARE_EPIC_V1_0_EPICTYPE_H

typedef long handleType;
typedef void (*init_t)();
typedef void (*term_t)();
typedef handleType (*alloc_request_t)(int);
typedef handleType (*alloc_multi_request_t)(const int[], int);
typedef void (*update_handle_t)(handleType, const char *);
typedef void (*free_request_t)(handleType);
typedef bool (*acquire_t)(handleType);
typedef bool (*release_t)(handleType);
typedef bool (*acquire_option_t)(handleType, unsigned int, unsigned int);
typedef bool (*acquire_multi_option_t)(handleType, const unsigned int [], const unsigned int [], int len);
typedef bool (*acquire_conditional_t)(handleType, const char *, ssize_t);
typedef bool (*release_conditional_t)(handleType, const char *, ssize_t);
typedef bool (*hint_t)(handleType, const char *, ssize_t);
typedef bool (*hint_release_t)(handleType, const char *, ssize_t);
typedef bool (*dump_t)(handleType, const char *, ssize_t);

#endif
