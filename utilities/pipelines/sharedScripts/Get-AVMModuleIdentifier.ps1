<#
.SYNOPSIS
This function gets the module identifier for a bicep module.

.DESCRIPTION
This function idnetifies module identifier from metadata property "moduleIdentifier".
If the metadata does not exist, it will fallback to use the path to identify the name of the module.

.PARAMETER ModuleFolderPath
Mandatory. Path to the Bicep/ARM module that is being identified

.EXAMPLE

Get-AVMModuleIdentifier -ModuleFolderPath .\avm\res\storage\storage-account

#>
function Get-AVMModuleIdentifier {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string] $ModuleFolderPath
    )

    begin {

    }

    process {

        if ($moduleArmTemplateFilePath = Join-Path $ModuleFolderPath 'main.json') {

            # Get content of the main.json file.
            $moduleArmTemplateContent = Get-Content -Path $moduleArmTemplateFilePath -Raw
            $moduleData = $moduleArmTemplateContent | ConvertFrom-Json

            # Try to find the module identifier from metadata. Fall back to path based if non-existing.
            if ($moduleIdentifier = $moduleData.metadata.moduleIdentifier) {
                # Return value based on module metadata
                return $moduleIdentifier
            } else {
                # Return Module Identified based in path

                # some/path/modules/res/storage/storage-account -> modules/res/storage/storage-account
                # some/path/avm/res/storage/storage-account -> avm/res/storage/storage-account
                # some/path/avm/res/storage/storage-account/blob-service/container -> avm/res/storage/storage-account/blob-service/container
                # some/path/whatever/ptn/some/thing -> whatever/ptn/some/thing

                Write-Verbose -Message "Module Folder Path: $moduleFolderPath"
                # $folderPathNormalized = $ModuleFolderPath.Replace('\', '/')
                $extractPattern = '([a-zA-Z-_0-9]+)[\/|\\](res|ptn|utl)[\/|\\](\w+)[\/|\\]([a-zA-Z-_0-9]+)'

                if ($moduleFolderPath -match $extractPattern) {
                    $moduleIdentifier = $matches[0]
                    return $moduleIdentifier
                } else {
                    Write-Error 'Not able to extract name from path. Verify that point to a valid resource, pattern or utility module'
                }
            }
        } else {
            Write-Error "Unable to locate 'main.json' file."
        }

    }

    end {

    }
}

