/* memory.h
 *
 * Copyright (C) 2006-2016 wolfSSL Inc.
 *
 * This file is part of wolfSSL.
 *
 * wolfSSL is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * wolfSSL is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335, USA
 */


/* submitted by eof */


#ifndef WOLFSSL_MEMORY_H
#define WOLFSSL_MEMORY_H

#include <stdlib.h>
#include <wolfssl/wolfcrypt/types.h>

#ifdef __cplusplus
    extern "C" {
#endif

#ifdef WOLFSSL_DEBUG_MEMORY
    typedef void *(*wolfSSL_Malloc_cb)(size_t size, const char* func, unsigned int line);
    typedef void (*wolfSSL_Free_cb)(void *ptr, const char* func, unsigned int line);
    typedef void *(*wolfSSL_Realloc_cb)(void *ptr, size_t size, const char* func, unsigned int line);

    /* Public in case user app wants to use XMALLOC/XFREE */
    WOLFSSL_API void* wolfSSL_Malloc(size_t size, const char* func, unsigned int line);
    WOLFSSL_API void  wolfSSL_Free(void *ptr, const char* func, unsigned int line);
    WOLFSSL_API void* wolfSSL_Realloc(void *ptr, size_t size, const char* func, unsigned int line);
#else
    typedef void *(*wolfSSL_Malloc_cb)(size_t size);
    typedef void (*wolfSSL_Free_cb)(void *ptr);
    typedef void *(*wolfSSL_Realloc_cb)(void *ptr, size_t size);

    /* Public in case user app wants to use XMALLOC/XFREE */
    WOLFSSL_API void* wolfSSL_Malloc(size_t size);
    WOLFSSL_API void  wolfSSL_Free(void *ptr);
    WOLFSSL_API void* wolfSSL_Realloc(void *ptr, size_t size);
#endif

/* Public set function */
WOLFSSL_API int wolfSSL_SetAllocators(wolfSSL_Malloc_cb  malloc_function,
                                    wolfSSL_Free_cb    free_function,
                                    wolfSSL_Realloc_cb realloc_function);

#ifdef WOLFSSL_STATIC_MEMORY
    #define WOLFSSL_STATIC_TIMEOUT 1
    #define WC_STATIC_ALIGN 64

    WOLFSSL_API int wolfSSL_load_static_memory(byte* buffer, word32 sz);
    WOLFSSL_API int wolfSSL_unload_static_memory(byte* buffer, word32 sz,
                                                                   word32* amt);
    WOLFSSL_API int wolfSSL_use_static_memory(byte flag);
    WOLFSSL_API word32 wolfSSL_static_memory_inUse(void);
    WOLFSSL_LOCAL void* wolfSSL_Malloc_Static(size_t size);
    WOLFSSL_LOCAL void  wolfSSL_Free_Static(void *ptr);
    WOLFSSL_LOCAL void* wolfSSL_Realloc_Static(void *ptr, size_t size);
#endif /* WOLFSSL_STATIC_MEMORY */

#ifdef __cplusplus
    }  /* extern "C" */
#endif

#endif /* WOLFSSL_MEMORY_H */

