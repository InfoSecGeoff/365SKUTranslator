function Get-SubscribedSkusWithMapping {
    param (
        [string]$ProductsFilePath,
        [string]$OutputFilePath
    )

    Write-Output "Fetching subscribed SKUs from tenant and mapping product names..."

    $products = Import-Csv -Path $ProductsFilePath
    $results = Get-MgSubscribedSku | Select-Object SkuPartNumber, CapabilityStatus, AppliesTo, ConsumedUnits, ServicePlans
    $mappedResults = foreach ($sku in $results) {
        $match = $products | Where-Object { $_.String_Id -eq $sku.SkuPartNumber }
        $expandedServicePlans = if ($sku.ServicePlans) {
            ($sku.ServicePlans | ForEach-Object { 
                $_.ServicePlanName -as [string] 
            } | Where-Object { $_ } | Sort-Object -Unique) -join "; "
        } else {
            "None"
        }

        [PSCustomObject]@{
            ProductDisplayName = if ($match) {
                                       ($match.Product_Display_Name | Sort-Object -Unique) -join "; "
                                   } else { 
                                       "No match found" 
                                   }
            SkuPartNumber       = $sku.SkuPartNumber
            CapabilityStatus    = $sku.CapabilityStatus
            AppliesTo           = $sku.AppliesTo
            ConsumedUnits       = $sku.ConsumedUnits
            ServicePlans        = $expandedServicePlans
        }
    }

    $mappedResults | Export-Csv -Path $OutputFilePath -NoTypeInformation -Encoding UTF8
    Write-Output "Results exported to $OutputFilePath." 

    return $mappedResults
}

if (Get-Module -ListAvailable -Name "Microsoft.Graph") {
    Write-Output "Microsoft.Graph module is installed."
} else {
    Write-Output "Microsoft.Graph module is not installed. Installing..."
    Install-Module Microsoft.Graph
}

Write-Output "Connecting to Graph with Directory.Read.All and Organization.Read.All permissions..."
try {
    Connect-MgGraph -Scopes 'Directory.Read.All','Organization.Read.All' -NoWelcome
} catch {
    Write-Output "Failed to connect to Microsoft Graph. Please check your permissions and network connectivity."
    Write-Output "Error details: $($_.Exception.Message)"
    Write-Output "Script cannot continue without a successful connection to Microsoft Graph. Exiting..."
    Exit
}

$defaultDomain = Get-MgDomain | Where-Object { $_.IsDefault -eq $true }
$domainId = $defaultDomain.Id
$domainName = $defaultDomain.Id -split '\.' | Select-Object -First 1
$outputFilePath = ".\$domainName-ProductLicenses.csv"
$productsFilePath = ".\365Products.csv"

$finalResults = Get-SubscribedSkusWithMapping -ProductsFilePath $productsFilePath -OutputFilePath $outputFilePath
$finalResults | Sort-Object -Property ConsumedUnits -Descending | Format-Table -AutoSize