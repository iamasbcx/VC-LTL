//
// Copyright (c) Microsoft Corporation. All Rights reserved.
//

#pragma once

#include <ptd_downlevel.h>

#if defined(_M_X64) || defined(_M_ARM_NT) || defined(_M_ARM64) || defined(_CHPE_X86_ARM64_EH_)

#if _CRT_NTDDI_MIN >= NTDDI_WIN6
#define _pForeignExcept   (*((EHExceptionRecord **)&(__acrt_getptd()->VistaOrLater_msvcrt._pForeignException)))
#else
#define _pForeignExcept   (*(EHExceptionRecord**)(__LTL_GetOsMinVersion() < 0x00060000 ? &(__LTL_get_ptd_downlevel()->_pForeignException) : &(__acrt_getptd()->VistaOrLater_msvcrt._pForeignException)))
#endif

#endif

#if _CRT_NTDDI_MIN >= NTDDI_WIN6
#define pFrameInfoChain   (*((FRAMEINFO **)    &(__acrt_getptd()->VistaOrLater_msvcrt._pFrameInfoChain)))
#else
#define pFrameInfoChain   (*((FRAMEINFO **)  (__LTL_GetOsMinVersion() < 0x00060000 ? &(__acrt_getptd()->XP_msvcrt._pFrameInfoChain) : \
          &(__acrt_getptd()->VistaOrLater_msvcrt._pFrameInfoChain))))
#endif

// Pre-V4 managed exception code
#define MANAGED_EXCEPTION_CODE  0XE0434F4D

// V4 and later managed exception code
#define MANAGED_EXCEPTION_CODE_V4  0XE0434352

extern "C" void
__except_validate_context_record(
    _In_ PCONTEXT ContextRecord
    );

extern "C" _VCRTIMP void * __AdjustPointer(
    void *,
    const PMD&
);

extern "C" _VCRTIMP void * __GetPlatformExceptionInfo(
    int *
);

extern "C" _VCRTIMP int __cdecl __FrameUnwindFilter(
    EXCEPTION_POINTERS *
);

extern PGETWINRT_OOM_EXCEPTION __WinRTOutOfMemoryExceptionCallback;

extern "C" _VCRTIMP void __cdecl __DestructExceptionObject(
    EHExceptionRecord *,
    BOOLEAN
);

extern "C" _VCRTIMP void __cdecl RENAME_EH_EXTERN(__BuildCatchObject)(
    EHExceptionRecord *,
    void *,
    HandlerType *,
    CatchableType *
);

extern "C" _VCRTIMP int __cdecl RENAME_EH_EXTERN(__TypeMatch4)(
    HandlerType4 *,
    CatchableType *,
    ThrowInfo *
    );

extern "C" _VCRTIMP int __cdecl RENAME_EH_EXTERN(__TypeMatch)(
    HandlerType *,
    CatchableType *,
    ThrowInfo *
);

//
// Prototype for the internal handler
//

template<class T>
EXCEPTION_DISPOSITION __InternalCxxFrameHandler(
    EHExceptionRecord    *pExcept,
    EHRegistrationNode   *pRN,
    CONTEXT              *pContext,
    DispatcherContext    *pDC,
    typename T::FuncInfo *pFuncInfo,
    int                  CatchDepth,
    EHRegistrationNode   *pMarkerRN,
    BOOLEAN              recursive);

#if _EH_RELATIVE_TYPEINFO

#undef THROW_COUNT
#define THROW_COUNT(ti)         THROW_COUNT_IB(ti, _GetThrowImageBase())
#undef THROW_CTLIST
#define THROW_CTLIST(ti)        THROW_CTLIST_IB(ti, _GetThrowImageBase())

#endif // _EH_RELATIVE_TYPEINFO
