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

        $moduleArmTemplateFilePath = Join-Path $ModuleFolderPath 'main.json'
        $moduleArmTemplateContent = Get-Content -Path $moduleArmTemplateFilePath -Raw

        $moduleData = $moduleArmTemplateContent | ConvertFrom-Json

        if ($moduleIdentifier = $moduleData.metadata.moduleIdentifier) {
            # Return value based on module metadata
            return $moduleIdentifier
        } else {
            # Return Module Identified based in path

            # some/path/modules/res/storage/storage-account -> modules/res/storage/storage-account
            # some/path/avm/res/storage/storage-account -> avm/res/storage/storage-account
            # some/path/avm/res/storage/storage-account/blob-service/container -> avm/res/storage/storage-account/blob-service/container
            # some/path/whatever/ptn/some/thing -> whatever/ptn/some/thing

            $folderPathNormalized = $ModuleFolderPath.Replace('\', '/')
            $extractPattern = '\b(\w+/(res|ptn|utl).*)'

            if ($folderPathNormalized -match $extractPattern) {
                $moduleIdentifier = $matches[1]
                return $moduleIdentifier
            } else {
                Write-Error 'Not able to extract name from given path'
            }
        }
    }

    end {

    }
}

