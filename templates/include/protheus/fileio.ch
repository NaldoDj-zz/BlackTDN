/*
	Header : fileio.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _FILEIO_CH_
#define _FILEIO_CH_

// Error value (all functions)

#define F_ERROR      (-1)

// FSEEK() modes

#define FS_SET       0     // Seek from beginning of file
#define FS_RELATIVE  1     // Seek from current file position
#define FS_END       2     // Seek from end of file


// FOPEN() access modes

#define FO_READ      0     // Open for reading (default)
#define FO_WRITE     1     // Open for writing
#define FO_READWRITE 2     // Open for reading or writing


// FOPEN() sharing modes (combine with open mode using +)

#define FO_COMPAT    0     // Compatibility mode (default)
#define FO_EXCLUSIVE 16    // Exclusive use (other processes have no access)
#define FO_DENYWRITE 32    // Prevent other processes from writing
#define FO_DENYREAD  48    // Prevent other processes from reading
#define FO_DENYNONE  64    // Allow other processes to read or write
#define FO_SHARED    64    // Same as FO_DENYNONE


// FCREATE() file attribute modes
// NOTE:  FCREATE() always opens with (FO_READWRITE + FO_COMPAT)

#define FC_NORMAL    0     // Create normal read/write file (default)
#define FC_READONLY  1     // Create read-only file
#define FC_HIDDEN    2     // Create hidden file
#define FC_SYSTEM    4     // Create system file


// FSETDEVMODE() device modes

#define FD_RAW       1
#define FD_BINARY    1
#define FD_COOKED    2
#define FD_TEXT      2
#define FD_ASCII     2

#endif


