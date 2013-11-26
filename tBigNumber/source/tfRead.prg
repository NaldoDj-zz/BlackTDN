#IFDEF PROTHEUS
	#DEFINE __PROTHEUS__
	#include "protheus.ch"
	#xtranslate hb_ntos( <n> ) => LTrim( Str( <n> ) )
#ELSE
	#IFDEF __HARBOUR__
		#include "hbclass.ch"
	#ENDIF
#ENDIF

#include "fileio.ch"

#define oF_CREATE_OBJECT      1
#define oF_OPEN_FILE          2
#define oF_READ_FILE          3
#define oF_CLOSE_FILE         4
#define oF_SEEK_FILE          5

#define oF_ERROR_MIN          1
#define oF_ERROR_MAX          5

#define oF_DEFAULT_READ_SIZE  4096

Static __cCHR13
Static __cCHR10

/*
 Original: $Id: fileread.prg,v 1.1 2005/10/13 12:01:10 lf_sfnet Exp $

 Harbour Project source code
 A class that reads a file one line at a time
 http://harbour-Project.org/
 Donated to the public domain on 2001-04-03 by David G. Holm <dholm@jsd-llc.com>
*/
CLASS tfRead

	DATA cFile		// The filename
	DATA nfHandle	// The open file handle
	DATA lEOF		// The end of file reached flag
	DATA nError		// The current file error code
	DATA nLastOp	// The last operation done (for error messages)
	DATA cBuffer	// The readahead buffer
	DATA nReadSize	// How much to add to the readahead buffer on each read from the file

	METHOD New(cFile,nSize)	CONSTRUCTOR	//Create a new class instance
	METHOD ClassName()					// Returns ClassName
	METHOD Open(cFile,nMode)			// Open the file for reading
	METHOD Seek(nOffset,nOrigin)		// sets the file pointer in the file
	METHOD Close(lFClear)				// Close the file when done
	METHOD ReadLine()					// Read a line from the file
	METHOD Name()						// Retunrs the file name
	METHOD IsOpen()						// Returns .T. if file is open
	METHOD MoreToRead()					// Returns .T. if more to be read
	METHOD Error()						// Returns .T. if error occurred
	METHOD ErrorNo()					// Returns current error code
	METHOD ErrorMsg( cText )			// Returns formatted error message

END CLASS

METHOD New( cFile, nSize ) CLASS tfRead

	__cCHR13	:= IF( __cCHR13 == NIL , CHR(13) , __cCHR13 )
	__cCHR10	:= IF( __cCHR10 == NIL , CHR(10) , __cCHR10 )

	IF nSize == NIL .OR. nSize < 1
		// The readahead size can be set to as little as 1 byte, or as much as
		// 65535 bytes, but venturing out of bounds forces the default size.
		nSize := oF_DEFAULT_READ_SIZE
	ENDIF

	IF cFile == NIL
		cFile := ""
	EndIF

	self:cFile     := cFile             // Save the file name
	self:nfHandle  := -1                // It's not open yet
	self:lEOF      := .T.               // So it must be at EOF
	self:nError    := 0                 // But there haven't been any errors
	self:nLastOp   := oF_CREATE_OBJECT  // Because we just created the class
	self:cBuffer   := ""                // and nothing has been read yet
	self:nReadSize := nSize             // But will be in this size chunks

RETURN Self

#IFDEF __PROTHEUS__
	User Function tfRead(cFile,nSize)
	Return( tfRead():New(@cFile,@nSize) )
#ENDIF

METHOD ClassName() CLASS tfRead
Return("TFREAD")

METHOD Open( cFile , nMode ) CLASS tfRead

	IF .NOT.( cFile == NIL )
		IF .NOT.( cFile == self:cFile )
			self:Close(.T.)
		EndIF
	EndIF

	IF self:nfHandle == -1
		IF Empty( self:cFile ) .and. .NOT.(Empty(cFile))
			self:cFile := cFile
		EndIF	
		// Only open the file if it isn't already open.
		IF nMode == NIL
			nMode := FO_READ + FO_SHARED   // Default to shared read-only mode
		ENDIF
		self:nLastOp 	:= oF_OPEN_FILE
		self:nfHandle	:= FOPEN( self:cFile, nMode )   // Try to open the file
		IF self:nfHandle == -1
			self:nError := FERROR()       // It didn't work
			self:lEOF   := .T.            // So force EOF
		ELSE
			self:nError := 0              // It worked
			self:lEOF   := .F.            // So clear EOF
		ENDIF
	ELSE
		// The file is already open, so rewind to the beginning.
		IF self:Seek( 0 ) == 0
			self:lEOF := .F.			// Definitely not at EOF
		ELSE
			self:nError := FERROR()		// Save error code if not at BOF
		ENDIF
	ENDIF

	self:cBuffer := ""               	// Clear the readahead buffer

RETURN Self

METHOD Seek(nOffset,nOrigin) CLASS tfRead

	Local nPosition := -1

	self:nLastOp	:= oF_SEEK_FILE
	self:cBuffer 	:= ""				// Clear the readahead buffer
	IF self:nfHandle == -1
		self:nError := -1                // Set unknown error if file not open
	Else
		nOffset 		:= IF(nOffset==NIL,FS_SET,nOffset)
		nOrigin 		:= IF(nOrigin==NIL,FS_RELATIVE,nOrigin)
		nPosition		:= FSEEK( self:nfHandle , nOffset , nOrigin )
		self:nError 	:= FERROR()
	EndIF
	
Return( nPosition )

METHOD ReadLine() CLASS tfRead

   LOCAL cLine := ""
   LOCAL nPos

   self:nLastOp := oF_READ_FILE

   IF self:nfHandle == -1
      self:nError := -1                // Set unknown error if file not open
   ELSE
      // Is there a whole line in the readahead buffer?
      nPos := f_EOL_pos( Self )
      WHILE ( nPos <= 0 .OR. nPos > LEN( self:cBuffer ) - 3 ) .AND. !self:lEOF
         // Either no or maybe, but there is possibly more to be read.
         // Maybe means that we found either a CR or an LF, but we don't
         // have enough characters to discriminate between the three types
         // of end of line conditions that the class recognizes (see below).
         cLine := FREADSTR( self:nfHandle, self:nReadSize )
         IF EMPTY( cLine )
            // There was nothing more to be read. Why? (Error or EOF.)
            self:nError := FERROR()
            IF self:nError == 0
               // Because the file is at EOF.
               self:lEOF := .T.
            ENDIF
         ELSE
            // Add what was read to the readahead buffer.
            self:cBuffer += cLine
         ENDIF
         // Is there a whole line in the readahead buffer yet?
         nPos := f_EOL_pos( Self )
      END WHILE
      // Is there a whole line in the readahead buffer?
      IF nPos <= 0
         // No, which means that there is nothing left in the file either, so
         // return the entire buffer contents as the last line in the file.
         cLine := self:cBuffer
         self:cBuffer := ""
      ELSE
         // Yes. Is there anything in the line?
         IF nPos > 1
            // Yes, so return the contents.
            cLine := LEFT( self:cBuffer, nPos - 1 )
         ELSE
            // No, so return an empty string.
            cLine := ""
         ENDIF
         // Deal with multiple possible end of line conditions.
         DO CASE
            CASE SUBSTR( self:cBuffer, nPos, 3 ) == __cCHR10 + __cCHR13 + __cCHR10
               nPos += 3
            CASE SUBSTR( self:cBuffer, nPos, 3 ) == __cCHR13 + __cCHR13 + __cCHR10
               // It's a messed up DOS newline (such as that created by a program
               // that uses "\r\n" as newline when writing to a text mode file,
               // which causes the '\n' to expand to "\r\n", giving "\r\r\n").
               nPos += 3
            CASE SUBSTR( self:cBuffer, nPos, 2 ) == __cCHR13 + __cCHR10
               // It's a standard DOS newline
               nPos += 2
            OTHERWISE
               // It's probably a Mac or Unix newline
               nPos++
         ENDCASE
         self:cBuffer := SUBSTR( self:cBuffer, nPos )
      ENDIF
   ENDIF

RETURN cLine

Static Function f_EOL_pos( oFile )

   LOCAL nCRpos, nLFpos, nPos

   // Look for both CR and LF in the file read buffer.
   nCRpos := AT( __cCHR13, oFile:cBuffer )
   nLFpos := AT( __cCHR10, oFile:cBuffer )
   DO CASE
      CASE nCRpos == 0
         // If there's no CR, use the LF position.
         nPos := nLFpos
      CASE nLFpos == 0
         // If there's no LF, use the CR position.
         nPos := nCRpos
      OTHERWISE
         // If there's both a CR and an LF, use the position of the first one.
         nPos := MIN( nCRpos, nLFpos )
   ENDCASE

RETURN nPos

METHOD Close(lFClear) CLASS tfRead

	self:nLastOp := oF_CLOSE_FILE
	self:lEOF := .T.
	// Is the file already closed.
	IF self:nfHandle == -1
		// Yes, so indicate an unknown error.
		self:nError := -1
	ELSE
		// No, so close it already!
		FCLOSE( self:nfHandle )
		self:nError 	:= FERROR()
		self:nfHandle	:= -1	// The file is no longer open
		self:lEOF   	:= .T.	// So force an EOF condition
	ENDIF

	IF IF( lFClear == NIL , .F. , lFClear )
		self:cFile := ""
	EndIF

	self:cBuffer := ""			// Clear the readahead buffer

RETURN Self

METHOD Name() CLASS tfRead
   // Returns the filename associated with this class instance.
RETURN self:cFile

METHOD IsOpen() CLASS tfRead
   // Returns .T. if the file is open.
RETURN self:nfHandle != -1

METHOD MoreToRead() CLASS tfRead
   // Returns .T. if there is more to be read from either the file or the
   // readahead buffer. Only when both are exhausted is there no more to read.
RETURN !self:lEOF .OR. !EMPTY( self:cBuffer )

METHOD Error() CLASS tfRead
   // Returns .T. if an error was recorded.
RETURN self:nError != 0

METHOD ErrorNo() CLASS tfRead
   // Returns the last error code that was recorded.
RETURN self:nError

METHOD ErrorMsg( cText ) CLASS tfRead

   STATIC s_cAction := {"on", "creating object for", "opening", "reading from", "closing" , "seeking"}

   LOCAL cMessage, nTemp

   // Has an error been recorded?
   IF self:nError == 0
      // No, so report that.
      cMessage := "No errors have been recorded for " + self:cFile
   ELSE
      // Yes, so format a nice error message, while avoiding a bounds error.
      IF self:nLastOp < oF_ERROR_MIN .OR. self:nLastOp > oF_ERROR_MAX
         nTemp := 1
      ELSE
         nTemp := self:nLastOp + 1
      ENDIF
      cMessage := IF( EMPTY( cText ), "", cText ) + "Error " + hb_ntos( self:nError ) + " " + s_cAction[ nTemp ] + " " + self:cFile
   ENDIF

RETURN cMessage