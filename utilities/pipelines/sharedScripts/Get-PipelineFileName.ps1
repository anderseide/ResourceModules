<#
.SYNOPSIS
Find the correct yml pipeline naming for a given resource identifier.

.DESCRIPTION
Find the correct yml pipeline naming for a given resource identifier.
If a child resource type is provided, the corresponding yml pipeline name is the one of its parent resource type

.PARAMETER ResourceIdentifier
Mandatory. The resource identifier to search for, i.e. the relative module file path starting from the resource provider folder.

.EXAMPLE
Get-PipelineFileName -ResourceIdentifier 'modules/res/storage/storage-account/blob-service/container/immutability-policy'.

Returns 'modules.storage.storageaccounts.yml'.

.EXAMPLE
Get-PipelineFileName -ResourceIdentifier 'modules/res/storage/storage-account'.

Returns 'modules.storage.storageaccounts.yml'.
#>
function Get-PipelineFileName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceIdentifier
    )

    $prefix, $type, $provider, $parentType, $childTypeString = $ResourceIdentifier -split '[\/|\\]', 5
    $parentResourceIdentifier = $provider, $parentType -join '/'
    $pipelineFileName = ('{0}.{1}.{2}.yml' -f $prefix, $type, ($parentResourceIdentifier -replace '\/', '.')).ToLower()
    return $pipelineFileName
}
