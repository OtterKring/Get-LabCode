<#
.SYNOPSIS
Parse code sections from (MS Lab) websites

.DESCRIPTION
Download a website and return all code sectons and their headers (if they start with "Task x:").
If requested, headers are returned as VSCode #regions.

.PARAMETER Uri
Uri of the website to parse

.PARAMETER UseRegions
Switch to choose returning headers as VSCode #regions

.EXAMPLE
.\Get-LabCode.ps1 -Uri 'https://microsoftlearning.github.io/AZ-104-MicrosoftAzureAdministrator/Instructions/Labs/LAB_08-Manage_Virtual_Machines.html' -UseRegions

.NOTES
2023-02-08 ... initial version by Maximilian Otter
#>
[CmdletBinding()]
param (

    # Uri of the website to parse
    [Parameter(Mandatory)]
    [uri]
    $Uri,

    # have the task headers returned as vscode #regions
    [Parameter()]
    [switch]
    $UseRegions
)

# prepare html parts as regex
$codein = '<code class=".+?">'
$codeout = [regex]::Escape('</code>')
$task = 'Task \d+:'

# download website
$html = ( Invoke-WebRequest -Uri $uri -UseBasicParsing ).Content
# parse the lines we need from the website content
$RawData = [regex]::Matches( $html , "$task.*(?=<.+?>)|(?<=$codein\ *)(\n|.)*?(?=$codeout)").Value

# return only the Tasks with included code
# if requested, use the Task headers as #region tags for VSCode
$previousline = ''
$previousregion = ''
foreach ( $line in $RawData ) {

    if ( $line -notmatch "^$task" ) {
        if ( $previousline -match "^$task" ) {
            if ( $UseRegions ) {
                if ( $previousregion ) {
                    "#endregion $previousregion"
                    ''
                }
                "#region $previousline"
                $previousregion = $previousline
            } else {
                $previousline
            }
            ''
        }
        $line
    }
    
    $previousline = $line

}

if ( $previousregion ) {
    "#endregion $previousregion"
}