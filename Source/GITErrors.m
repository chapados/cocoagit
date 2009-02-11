//
//  GITError.m
//  CocoaGit
//
//  Created by Geoffrey Garside on 09/11/2008.
//  Copyright 2008 ManicPanda.com. All rights reserved.
//

#import "GITErrors.h"
#define __git_error(code, val) const NSInteger code = val
#define __git_error_domain(dom, str) NSString * dom = str

__git_error_domain(GITErrorDomain, @"com.manicpanda.GIT.ErrorDomain");

#pragma mark Object Loading Errors
__git_error(GITErrorObjectSizeMismatch,             -1);
__git_error(GITErrorObjectNotFound,                 -2);
__git_error(GITErrorObjectTypeMismatch,             -3);
__git_error(GITErrorObjectParsingFailed,            -4);

#pragma mark File Reading Errors
__git_error(GITErrorFileNotFound,                   -5);

#pragma mark Store Error Codes
__git_error(GITErrorObjectStoreNotAccessible,       -6);

#pragma mark PACK and Index Error Codes
__git_error(GITErrorPackIndexUnsupportedVersion,    -7);
__git_error(GITErrorPackIndexCorrupted,             -8);
__git_error(GITErrorPackIndexChecksumMismatch,      -9);
__git_error(GITErrorPackFileInvalid,                -10);
__git_error(GITErrorPackFileNotSupported,           -11);
__git_error(GITErrorPackFileChecksumMismatch,       -12);

#undef __git_error