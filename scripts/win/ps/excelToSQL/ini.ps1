function Get-IniFile {
    <#
    .SYNOPSIS
    Read an ini file.
    
    .DESCRIPTION
    Reads an ini file into a hash table of sections with keys and values.
    
    .PARAMETER filePath
    The path to the INI file.
    
    .PARAMETER anonymous
    The section name to use for the anonymous section (keys that come before any section declaration).
    
    .PARAMETER comments
    Enables saving of comments to a comment section in the resulting hash table.
    The comments for each section will be stored in a section that has the same name as the section of its origin, but has the comment suffix appended.
    Comments will be keyed with the comment key prefix and a sequence number for the comment. The sequence number is reset for every section.
    
    .PARAMETER commentsSectionsSuffix
    The suffix for comment sections. The default value is an underscore ('_').

    .PARAMETER commentsKeyPrefix
    The prefix for comment keys. The default value is 'Comment'.
    
    .EXAMPLE
    Get-IniFile /path/to/my/inifile.ini
    
    .NOTES
    The resulting hash table has the form [sectionName->sectionContent], where sectionName is a string and sectionContent is a hash table of the form [key->value] where both are strings.

    This function is largely copied from https://stackoverflow.com/a/43697842/1031534. An improved version has since been pulished at https://gist.github.com/beruic/1be71ae570646bca40734280ea357e3c.
    #>
    
    param(
        [parameter(Mandatory = $true)] [string] $filePath,
        [string] $anonymous = 'NoSection',
        [switch] $comments,
        [string] $commentsSectionsSuffix = '_',
        [string] $commentsKeyPrefix = 'Comment'
    )

    $ini = @{}
    switch -regex -file ($filePath) {
        "^\[(.+)\]$" {
            # Section
            $section = $matches[1]
            $ini[$section] = @{}
            $CommentCount = 0
            if ($comments) {
                $commentsSection = $section + $commentsSectionsSuffix
                $ini[$commentsSection] = @{}
            }
            continue
        }

        "^(;.*)$" {
            # Comment
            if ($comments) {
                if (!($section)) {
                    $section = $anonymous
                    $ini[$section] = @{}
                }
                $value = $matches[1]
                $CommentCount = $CommentCount + 1
                $name = $commentsKeyPrefix + $CommentCount
                $commentsSection = $section + $commentsSectionsSuffix
                $ini[$commentsSection][$name] = $value
            }
            continue
        }

        "^(.+?)\s*=\s*(.*)$" {
            # Key
            if (!($section)) {
                $section = $anonymous
                $ini[$section] = @{}
            }
            $name, $value = $matches[1..2]
            $ini[$section][$name] = $value
            continue
        }
    }

    return $ini
}



function New-IniContent {
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipeline)] [hashtable] $data,
        [string] $anonymous = 'NoSection'
    )
    process {
        $iniData = $_

        if ($iniData.Contains($anonymous)) {
            $iniData[$anonymous].GetEnumerator() |  ForEach-Object {
                Write-Output "$($_.Name)=$($_.Value)"
            }
            Write-Output ''
        }

        $iniData.GetEnumerator() | ForEach-Object {
            $sectionData = $_
            if ($sectionData.Name -ne $anonymous) {
                Write-Output "[$($sectionData.Name)]"

                $iniData[$sectionData.Name].GetEnumerator() |  ForEach-Object {
                    Write-Output "$($_.Name)=$($_.Value)"
                }
            }
            Write-Output ''
        }
    }
}