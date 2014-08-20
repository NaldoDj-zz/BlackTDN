/*
	Header : dbinfo.ch
	Copyright (c) 1997-2003, Microsiga Software SA
	All rights reserved.
*/

#ifndef _DBINFO_CH_
#define _DBINFO_CH_

/* codes for DBRECORDINFO() */
#define DBRI_DELETED       1
#define DBRI_LOCKED        2
#define DBRI_RECSIZE       3
#define DBRI_RECNO         4
#define DBRI_UPDATED       5


/* codes for Order management */
/* DBOI_* are defined in ORD.CH */


/* codes for DBINFO() */
#define DBI_ISDBF           1  /* Logical: RDD support data file format? */
#define DBI_CANPUTREC       2  /* Logical: RDD support Putting Records? */
#define DBI_GETHEADERSIZE   3  /* Numeric: Get header size of the file  */
#define DBI_LASTUPDATE      4  /* Date:    Last date RDD file updated   */
#define DBI_GETDELIMITER    5  /* String:  Get default delimiter        */
#define DBI_SETDELIMITER    6  /* String:  Set default delimiter        */
#define DBI_GETRECSIZE      7  /* Numeric: Get record size of the file  */
#define DBI_GETLOCKARRAY    8  /* Array: Get an array of locked records */
#define DBI_TABLEEXT        9  /* String:  Get table file extension     */
#define DBI_FULLPATH       10  /* String: Full path name of opened file */

#define DBI_ISFLOCK        20  /* Get file lock status             */

#define DBI_CHILDCOUNT     22  /* Number of opened relations       */
#define DBI_FILEHANDLE     23  /* Handle of opened file            */

#define DBI_BOF            26  /* BOF flag - alternate to bof()    */
#define DBI_EOF            27  /* EOF flag - alternate to eof()    */
#define DBI_DBFILTER       28  /* Filter expression                */
#define DBI_FOUND          29  /* FOUND flag - alternate to found  */
#define DBI_FCOUNT         30  /* Number of fields                 */
#define DBI_LOCKCOUNT      31  /* Get record size of the file      */
#define DBI_VALIDBUFFER    32  /* Is the current buffer valid      */
#define DBI_ALIAS          33  /* Alias name of workarea           */
#define DBI_GETSCOPE       34  /* Locate codeblock                 */
#define DBI_LOCKOFFSET     35  /* New locking offset               */
#define DBI_SHARED         36  /* Gets/Sets the shared flag        */
#define DBI_MEMOEXT        37  /* Gets/Sets the shared flag        */
#define DBI_MEMOHANDLE     38  /* Dos handle for memo file         */
#define DBI_MEMOBLOCKSIZE  39  /* Blocksize in memo files          */

#define DBI_DB_VERSION    101  /* HOST driver Version              */
#define DBI_RDD_VERSION   102  /* RDD version (current RDD)        */

#define DBI_USER         1000  /* Start of user defineable values  */


// These are for internal use by BLOB.CH

#define DBI_BLOB_DIRECT_EXPORT  201
#define DBI_BLOB_DIRECT_GET     202
#define DBI_BLOB_DIRECT_IMPORT  203
#define DBI_BLOB_DIRECT_PUT     204
#define DBI_BLOB_ROOT_GET       205
#define DBI_BLOB_ROOT_PUT       206
#define DBI_BLOB_ROOT_LOCK      207
#define DBI_BLOB_ROOT_UNLOCK    208

#define DBS_BLOB_GET            201

// These are for public use

#define DBI_BLOB_DIRECT_LEN     209
#define DBI_BLOB_DIRECT_TYPE    210
#define DBI_BLOB_INTEGRITY      211
#define DBI_BLOB_OFFSET         212
#define DBI_BLOB_RECOVER        213

#define DBS_BLOB_LEN            202
#define DBS_BLOB_OFFSET         203
#define DBS_BLOB_POINTER        204
#define DBS_BLOB_TYPE           205

#define BLOB_EXPORT_APPEND      1
#define BLOB_EXPORT_OVERWRITE   0

#define FILEGET_APPEND          1
#define FILEGET_OVERWRITE       0

#define ERDD_OPEN_MEMO     1002
#define ERDD_CREATE_MEMO   1005
#define ERDD_OUTOFMEMORY   1104
#define ERDD_READ          1010
#define ERDD_WRITE         1011
#define ERDD_DATATYPE      1020
#define ERDD_UNLOCKED      1022
#define ERDD_OPEN_FILE     1101
#define ERDD_CREATE_FILE   1102

#endif

