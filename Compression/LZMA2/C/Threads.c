#if defined(FREEARC_WIN)
#include "ThreadsWin32.c"
#else
#include "ThreadsUnix.c"
#endif
