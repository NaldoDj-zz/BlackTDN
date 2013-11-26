#http://gallery.technet.microsoft.com/scriptcenter/Resize-Image-File-f6dd4a56
Function Set-ImageSize
{
    <#
	.SYNOPSIS
	    Resize image file.

	.DESCRIPTION
	    The Set-ImageSize cmdlet to set new size of image file.
		
	.PARAMETER Image
	    Specifies an image file. 

	.PARAMETER Destination
	    Specifies a destination of resized file. Default is current location (Get-Location).
	
	.PARAMETER WidthPx
	    Specifies a width of image in px. 
		
	.PARAMETER HeightPx
	    Specifies a height of image in px.		
	
	.PARAMETER DPIWidth
	    Specifies a vertical resolution. 
		
	.PARAMETER DPIHeight
	    Specifies a horizontal resolution.	
		
	.PARAMETER Overwrite
	    Specifies a destination exist then overwrite it without prompt. 
		
	.PARAMETER FixedSize
	    Set fixed size and do not try to scale the aspect ratio. 

	.PARAMETER RemoveSource
	    Remove source file after conversion. 
		
	.EXAMPLE
		PS C:\> Get-ChildItem 'P:\test\*.jpg' | Set-ImageSize -Destination "p:\test2" -WidthPx 300 -HeightPx 375 -Verbose
		VERBOSE: Image 'P:\test\00001.jpg' was resize from 236x295 to 300x375 and save in 'p:\test2\00001.jpg'
		VERBOSE: Image 'P:\test\00002.jpg' was resize from 236x295 to 300x375 and save in 'p:\test2\00002.jpg'
		VERBOSE: Image 'P:\test\00003.jpg' was resize from 236x295 to 300x375 and save in 'p:\test2\00003.jpg'
		
	.NOTES
		Author: Michal Gajda
		Blog  : http://commandlinegeeks.com/
	#>
	[CmdletBinding(
    	SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]		
	Param
	(
		[parameter(Mandatory=$true,
			ValueFromPipeline=$true,
			ValueFromPipelineByPropertyName=$true)]
		[Alias("Image")]	
		[String[]]$FullName,
		[String]$Destination = $(Get-Location),
		[Switch]$Overwrite,
		[Int]$WidthPx,
		[Int]$HeightPx,
		[Int]$DPIWidth,
		[Int]$DPIHeight,
		[Switch]$FixedSize,
		[Switch]$RemoveSource
	)

	Begin
	{
		[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
		#[void][reflection.assembly]::loadfile( "C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Drawing.dll")
	}
	
	Process
	{

		Foreach($ImageFile in $FullName)
		{
			If(Test-Path $ImageFile)
			{
				$OldImage = new-object System.Drawing.Bitmap $ImageFile
				$OldWidth = $OldImage.Width
				$OldHeight = $OldImage.Height
				
				if($WidthPx -eq $Null)
				{
					$WidthPx = $OldWidth
				}
				if($HeightPx -eq $Null)
				{
					$HeightPx = $OldHeight
				}
				
				if($FixedSize)
				{
					$NewWidth = $WidthPx
					$NewHeight = $HeightPx
				}
				else
				{
					if($OldWidth -lt $OldHeight)
					{
						$NewWidth = $WidthPx
						[int]$NewHeight = [Math]::Round(($NewWidth*$OldHeight)/$OldWidth)
						
						if($NewHeight -gt $HeightPx)
						{
							$NewHeight = $HeightPx
							[int]$NewWidth = [Math]::Round(($NewHeight*$OldWidth)/$OldHeight)
						}
					}
					else
					{
						$NewHeight = $HeightPx
						[int]$NewWidth = [Math]::Round(($NewHeight*$OldWidth)/$OldHeight)
						
						if($NewWidth -gt $WidthPx)
						{
							$NewWidth = $WidthPx
							[int]$NewHeight = [Math]::Round(($NewWidth*$OldHeight)/$OldWidth)
						}						
					}
				}

				$ImageProperty = Get-ItemProperty $ImageFile				
				$SaveLocation = Join-Path -Path $Destination -ChildPath ($ImageProperty.Name)

				If(!$Overwrite)
				{
					If(Test-Path $SaveLocation)
					{
						$Title = "A file already exists: $SaveLocation"
							
						$ChoiceOverwrite = New-Object System.Management.Automation.Host.ChoiceDescription "&Overwrite"
						$ChoiceCancel = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel"
						$Options = [System.Management.Automation.Host.ChoiceDescription[]]($ChoiceCancel, $ChoiceOverwrite)		
						If(($host.ui.PromptForChoice($Title, $null, $Options, 1)) -eq 0)
						{
							Write-Verbose "Image '$ImageFile' exist in destination location - skiped"
							Continue
						} #End If ($host.ui.PromptForChoice($Title, $null, $Options, 1)) -eq 0
					} #End If Test-Path $SaveLocation
				} #End If !$Overwrite	
				
				$NewImage = new-object System.Drawing.Bitmap $NewWidth,$NewHeight

				$Graphics = [System.Drawing.Graphics]::FromImage($NewImage)
				$Graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
				$Graphics.DrawImage($OldImage, 0, 0, $NewWidth, $NewHeight) 

				$ImageFormat = $OldImage.RawFormat
				$OldImage.Dispose()
				if($DPIWidth -and $DPIHeight)
				{
					$NewImage.SetResolution($DPIWidth,$DPIHeight)
				} #End If $DPIWidth -and $DPIHeight
				
				$NewImage.Save($SaveLocation,$ImageFormat)
				$NewImage.Dispose()
				Write-Verbose "Image '$ImageFile' was resize from $($OldWidth)x$($OldHeight) to $($NewWidth)x$($NewHeight) and save in '$SaveLocation'"
				
				If($RemoveSource)
				{
					Remove-Item $Image -Force
					Write-Verbose "Image source '$ImageFile' was removed"
				} #End If $RemoveSource
			}
		}

	} #End Process
	
	End{}
}
