#ifdef __cplusplus
extern "C" {
#endif

#if defined(FREEARC_WIN)
#include "ThreadsWin32.h"
#else
#include "ThreadsUnix.h"
#endif

#ifdef __cplusplus
}
#endif
