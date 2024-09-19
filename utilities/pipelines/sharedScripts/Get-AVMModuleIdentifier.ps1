function Get-AVMModuleIdentifier {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
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
            $moduleIdentifier = (Split-Path $moduleArmTemplateFilePath -Parent) -split '[\/|\\]modules[\/|\\](res|ptn|utl)[\/|\\]'
            return ('modules/{0}/{1}' -f $moduleIdentifier[1], $moduleIdentifier[2]) -replace '\\', '/'
        }

    }

    end {

    }
}
