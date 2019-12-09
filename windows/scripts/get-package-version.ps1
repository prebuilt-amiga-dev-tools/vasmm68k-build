<#
.SYNOPSIS
    Converts a VASM version number, like "1.8f" to a Windows version number, like "1.8.6".

    Conversion rules:

    "1.8" -> "1.8.0"
    "1.8a" -> "1.8.1"
    "1.8b" -> "1.8.2"
    etc
#>

Param (
    [Parameter(Mandatory=$True)][string]$VASM_VERSION
)

$VASM_VERSION -Match "(\d+).(\d+)(\w)?" | Out-Null
$Version1 = $Matches.1
$Version2 = $Matches.2
$Version3 = if ($null -eq $Matches.3) { 0 } else { [int][char]($Matches.3).ToUpper() - [int][char]"A" + 1 }

$VASM_PACKAGE_VERSION = "$($Version1).$($Version2).$($Version3)"

return $VASM_PACKAGE_VERSION