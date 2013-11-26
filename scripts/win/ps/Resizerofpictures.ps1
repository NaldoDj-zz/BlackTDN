#http://poshcode.org/621
[reflection.assembly]::LoadWithPartialName("System.Drawing")

$SizeLimit=1280          # required size of picture's long side
$logfile="resizelog.txt" # log file for errors
$toresize=$args[0]       # list of directories to find and resize images. can be empty

if ([string]$toresize -eq &#8220;&#8221;) {  # if script startup parameter empty, use some default values
  $toresize=@("n:\path1", "n:\path2\", "s:\path3")
}

echo $toresize           # visual control
#Write-Host -NoNewLine ("Press any key.")   # Optional "Press any key"
#$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
#Write-Host ""

$error.clear()

# first part. find and resize jpgs

Get-ChildItem -recurse $toresize -include *.jpg  | foreach {
  $OldBitmap = new-object System.Drawing.Bitmap $_.FullName # open found jpg
  if ($error.count -ne 0) {                                 # error handling
    $error | out-file $logfile -append -encoding default
    $error[($error.count-1)].TargetObject | out-file $logfile -append -encoding default
    echo $_>>$logfile
    $error.clear()
  }
  $LongSide=$OldBitmap.Width                                # locating long side of picture
  if ($OldBitmap.Width -lt $OldBitmap.Height) { $LongSide=$OldBitmap.Height }
  if ($LongSide -gt $SizeLimit) {                           # if long side is greater than our limit, process jpg
    if ($OldBitmap.Width -lt $OldBitmap.Height) {           # calculate dimensions of picture resize to
      $newH=$SizeLimit
      $newW=[int]($OldBitmap.Width*$SizeLimit/$OldBitmap.Height)
    } else {
      $newW=$SizeLimit
      $newH=[int]($OldBitmap.Height*$newW/$OldBitmap.Width)
    }
    $NewBitmap = new-object System.Drawing.Bitmap $newW,$newH # create new bitmap
    $g=[System.Drawing.Graphics]::FromImage($NewBitmap)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic # use high quality resize algorythm
    $g.DrawImage($OldBitmap, 0, 0, $newW, $newH)              # resize our picture

    $name=$_.DirectoryName+"\"+$_.name+".new"                 # generating name for new picture
    $NewBitmap.Save($name, ([system.drawing.imaging.imageformat]::jpeg)) # save newly created resized jpg
    $NewBitmap.Dispose()                                      # cleaning up our mess
    $OldBitmap.Dispose()
    $n=get-childitem $name
    if ($n.length -ge $_.length) {                            # if resized jpg has greater size than original
      Write-host -NoNewLine "+"                               # draw "+"
      $n.delete()                                             # and delete it
    } else {                                                  # if resized jpg is smaller than original
      if ($n.Exists -and $_.Exists) {
        $name=$_.FullName
        $_.Delete()                                           # delete original
        $n.MoveTo($name)                                      # rename new file to original name (replace old file with new)
        echo ($Name + " " + $LongSide)                        # write its name for visual control
      }
    }
    
  } else {                                                    # if long side is smaller than limit, draw dot for visual
    Write-host -NoNewLine "."
    $OldBitmap.Dispose()
  }
}


#second part. process other than jpgs bitmaps

Get-ChildItem -recurse $toresize -include *.bmp, *.tif, *.gif | foreach {
  $OldBitmap = new-object System.Drawing.Bitmap $_.FullName # open picture
  if ($error.count -ne 0) {                                 # handle errors if any
    $error | out-file $logfile -append -encoding default
    $error[($error.count-1)].TargetObject | out-file $logfile -append -encoding default
    $error.clear()
  }
  $LongSide=$OldBitmap.Width                                # find picture's long side
  if ($OldBitmap.Width -lt $OldBitmap.Height) { $LongSide=$OldBitmap.Height }
  
  if ($LongSide -gt $SizeLimit) {                           # if long side is greater than our limit, process picture
    if ($OldBitmap.Width -lt $OldBitmap.Height) {           # calculating new dimensions
      $newH=$SizeLimit
      $newW=[int]($OldBitmap.Width*$SizeLimit/$OldBitmap.Height)
    } else {
      $newW=$SizeLimit
      $newH=[int]($OldBitmap.Height*$newW/$OldBitmap.Width)
    }
    $NewBitmap = new-object System.Drawing.Bitmap $newW,$newH # create new bitmap
    $g=[System.Drawing.Graphics]::FromImage($NewBitmap)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($OldBitmap, 0, 0, $newW, $newH)              # copy resized image to it

    $name=$_.DirectoryName+"\"+$_.name.substring(0, $_.name.indexof($_.extension))+".jpg" # generating new name, jpg extension
    $NewBitmap.Save($name, ([system.drawing.imaging.imageformat]::jpeg)) # save new file
    $NewBitmap.Dispose()
    $OldBitmap.Dispose()
    $n=get-childitem $name
    if ($n.length -ge $_.length) {                             # if new file is longer than original,
      $n.delete()                                              # delete new file
      Write-host -NoNewLine "+"                                # and draw "+" for beauty
    } else {                                                   # if new file is shorter than original (as we expect)
      echo ($Name + " " + $LongSide)                           # draw its name
      $_.Delete()                                              # delete oroginal
    }
  } else {                                                     # if long side is less than our limit, try to recompress it to jpg
    $name=$_.DirectoryName+"\"+$_.name.substring(0, $_.name.indexof($_.extension))+".jpg"
    $OldBitmap.Save($name, ([system.drawing.imaging.imageformat]::jpeg))
    $OldBitmap.Dispose()
    $n=get-childitem $name
    if ($n.length -ge $_.length) {                              # if new jpg is greater than original
      $n.delete()                                               # delete new jpg
      Write-host -NoNewLine "-"                                 # draw "-" for visual control
    } else {
      echo ($Name + " " + $LongSide)                            # draw new file name
      $_.Delete()                                               # delete original
    }
  }
}