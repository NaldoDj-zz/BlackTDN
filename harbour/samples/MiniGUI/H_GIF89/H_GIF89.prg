//------------------------------------------------------------------------------------------------
    /*/
        H_GIF89.prg
        Author:P.Chornyj <myorg63@mail.ru>
        Adaptado para uso no Protheus por:Marinaldo de Jesus
    /*/
//------------------------------------------------------------------------------------------------
#include "totvs.ch"
#include "fileio.ch"

#define Alert(c)     APMsgAlert(c,"LoadGIF")
#define TRUE  .T.
#define FALSE .F.

static ohb_GIF89

CLASS hb_GIF89

    DATA cClassName
    
    METHOD NEW() CONSTRUCTOR
    METHOD ClassName()
    
    METHOD LoadGIF(cGIF,aGifInfo,aFrames,aImgInfo,cPath)
    METHOD ReadFromStream(cFile,cStream)
    METHOD GetFrameDelay(cImageInfo,nDelay)

ENDCLASS

User Function hbGIF89()
    DEFAULT ohb_GIF89:=hb_GIF89():New()
RETURN(ohb_GIF89)

METHOD NEW() CLASS hb_GIF89
    self:ClassName()
RETURN(self)

METHOD ClassName() CLASS hb_GIF89
    self:cClassName:="hb_GIF89"
RETURN(self:cClassName)

METHOD LoadGIF(cGIF,aGifInfo,aFrames,aImgInfo,cPath) CLASS hb_GIF89
RETURN(LoadGIF(@cGIF,@aGifInfo,@aFrames,@aImgInfo,@cPath))
STATIC FUNCTION LoadGIF(cGIF,aGifInfo,aFrames,aImgInfo,cPath)

    LOCAL cDir
    LOCAL cFile
    LOCAL cExt
    LOCAL cDriver

    LOCAL cStream
    LOCAL cPicBuf
    LOCAL cFileName
    LOCAL cImgHeader
    LOCAL cGifHeader

    LOCAL cGifEnd:=Chr(0)+Chr(33)+Chr(249)
    LOCAL nGifEnd:=Len(cGifEnd)

    LOCAL bLoadGif:=TRUE

    LOCAL i
    LOCAL j

    LOCAL nImgCount
    LOCAL nFileHandle

    //-1=sem remote/ 0=delphi/ 1=QT windows/ 2=QT Linux
    LOCAL nRmtType:=GetRemoteType()
    LOCAL cPathChr:=IF(nRmtType==2,"/","\")

    BEGIN SEQUENCE

        aGifInfo:=Array(3)
        aFrames:={}
        aImgInfo:={}
    
        DEFAULT cPath:=GetTempPath()
        IF !(SubStr(cPath,-1)==cPathChr)
            cPath+=cPathChr
        EndIF
    
        IF !File(cGIF)
            Alert("File "+cGIF+" is not found!")
            bLoadGif:=FALSE
            BREAK
        ENDIF
    
        IF !ReadFromStream(cGIF,@cStream)
            Alert("Error when reading file "+cGIF)
            bLoadGif:=FALSE
            BREAK
        ENDIF
    
        nImgCount:=0
        i:=1 
        j:=(AT(cGifEnd,cStream,i)+1)
    
        cGifHeader=Left(cStream,j)
    
        IF Left(cGifHeader,3)<>"GIF"  
            Alert("This file is not a cGIF file!")
            bLoadGif:=FALSE
            BREAK
        ENDIF
    
        aGifInfo[1]:=SubStr(cGifHeader,4,3)           //GifVersion
        aGifInfo[2]:=Bin2W(SubStr(cGifHeader,7,2))    //LogicalScreenWidth
        aGifInfo[3]:=Bin2W(SubStr(cGifHeader,9,2))    //LogicalScreenHeight
    
        SplitPath(cGIF,@cDriver,@cDir,@cFile,@cExt)
    
        i:=j+2
    
        /* Split cGIF Files at separate pictures and load them into ImageList */
        WHILE .T.  
    
            j:=AT(cGifEnd,cStream,i)+3
    
            IF (j>nGifEnd)

                ++nImgCount
    
                cFileName:=cPath+cFile+"_frame_"+StrZero(nImgCount,4)+".gif"
                nFileHandle:=fCreate(cFileName,FC_NORMAL)
                
                IF fError()<>0
                    Alert("Error while creatingg a temp file:"+Str(fError()))
                    bLoadGif:=FALSE
                    BREAK
                ENDIF
    
                cPicBuf:=cGifHeader+SubStr(cStream,i-1,j-i)
                cImgHeader:=Left(SubStr(cStream,i-1,j-i),16)
    
                IF fWrite(nFileHandle,cPicBuf)<>Len(cPicBuf)
                    Alert("Error while writing a file:"+Str(fError()))
                    bLoadGif:=FALSE
                    BREAK
                ENDIF
    
                IF .NOT. fClose(nFileHandle)
                    Alert("Error while closing a file:"+Str(fError()))
                    bLoadGif:=FALSE
                    BREAK
                ENDIF
    
                aSize(aFrames,nImgCount)
                aFrames[nImgCount]:=cFileName
    
                aSize(aImgInfo,nImgCount)
                aImgInfo[nImgCount]:=cImgHeader

            ENDIF
            
            IF (j==3)
                EXIT
            ELSE
                i:=j    
            ENDIF

        END WHILE
    
        IF (i<Len(cStream))

            ++nImgCount
    
            cFileName:=cPath+cFile+"_frame_"+StrZero(nImgCount,4)+".gif"
            nFileHandle:=fCreate(cFileName,FC_NORMAL)
            IF fError()<>0
                Alert("Error while creatingg a temp file:"+Str(fError()))
                bLoadGif:=FALSE
                BREAK
            ENDIF
    
            cPicBuf:=cGifHeader+SubStr(cStream,i-1,Len(cStream)-i)
            cImgHeader:=Left(SubStr(cStream,i-1,Len(cStream)-i),16)
    
            IF fWrite(nFileHandle,cPicBuf)<>Len(cPicBuf)
                Alert("Error while writing a file:"+Str(fError()))
                bLoadGif:=FALSE
                BREAK
            ENDIF
    
            IF .NOT. fClose(nFileHandle)
                Alert("Error while closing a file:"+Str(fError()))
                bLoadGif:=FALSE
                BREAK
            ENDIF
    
            aSize(aFrames,nImgCount)
            aFrames[nImgCount]:=cFileName
    
            aSize(aImgInfo,nImgCount)
            aImgInfo[nImgCount]:=cImgHeader
        
        ENDIF                

    END SEQUENCE        

RETURN(bLoadGif)

METHOD ReadFromStream(cFile,cStream) CLASS hb_GIF89
RETURN(ReadFromStream(@cFile,@cStream))
STATIC FUNCTION ReadFromStream(cFile,cStream)

    LOCAL nFileSize
    LOCAL nFileHandle:=fOpen(cFile)

    BEGIN SEQUENCE

        IF (fError()<>0)
            BREAK
        ENDIF

        nFileSize:=fSeek(nFileHandle,0,FS_END)
        fSeek(nFileHandle,0,FS_SET)

        cStream:=Space(nFileSize)
        fRead(nFileHandle,@cStream,nFileSize)

    END SEQUENCE

    fClose(nFileHandle)

RETURN(fError()==0 .AND. .NOT. Empty(cStream))

METHOD GetFrameDelay(cImageInfo,nDelay) CLASS hb_GIF89
RETURN(GetFrameDelay(@cImageInfo,@nDelay))
STATIC FUNCTION GetFrameDelay(cImageInfo,nDelay)
    DEFAULT nDelay:=10
RETURN(Bin2W(Substr(cImageInfo,4,2))*nDelay)
