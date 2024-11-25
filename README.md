# 365SKUTranslator

## Overview

Have you experienced difficulty translating Microsoft's 4500+ SKU codes for M365 products into license names you know and understand?  The 365SKUTranslator script helps administrators retrieve and map Microsoft 365 subscription SKUs to their corresponding product display names. This script uses the Microsoft Graph API to fetch subscription details from a tenant and matches them with Microsoft's published CSV file of all SKUs (https://learn.microsoft.com/en-us/entra/identity/users/licensing-service-plan-reference).

Use the 365SKUTranslator to audit all product license types and license counts in your tenant. 

---

## Features

- Retrieves subscribed SKUs using the Microsoft Graph API.
- Maps SKUs to product display names based Microsoft's published list of SKUs
- Expands service plans associated with SKUs for granular product information.
- Outputs results in a user-friendly CSVfile for further use.

---

## Requirements

- **PowerShell** 5.1 or higher
- The **Microsoft.Graph** PowerShell module installed.
- API permissions:
  - `Directory.Read.All`
  - `Organization.Read.All`

---
## Usage
```
.\365SKUTranslator.ps1
```

---
## Example Output

| ProductDisplayName                    | SkuPartNumber              | CapabilityStatus | AppliesTo | ConsumedUnits | ServicePlans                                                                                             |
|---------------------------------------|----------------------------|------------------|-----------|---------------|----------------------------------------------------------------------------------------------------------|
| Power BI Pro                          | POWER_BI_PRO               | Enabled          | User      | 58            | BI_AZURE_P2; EXCHANGE_S_FOUNDATION; PURVIEW_DISCOVERY                                                   |
| Microsoft 365 Business Premium        | SPB                        | Enabled          | User      | 51            | AAD_PREMIUM; AAD_SMB; ADALLOM_S_DISCOVERY; ATP_ENTERPRISE; Bing_Chat_Enterp...                            |
| Exchange Online (Plan 1)              | EXCHANGESTANDARD           | Enabled          | User      | 21            | BPOS_S_TODO_1; EXCHANGE_S_STANDARD; INTUNE_O365; M365_LIGHTHOUSE_CUSTOMER_P...                          |
| Microsoft Power Apps Plan 2 Trial     | POWERAPPS_VIRAL            | Enabled          | User      | 17            | DYN365_CDS_VIRAL; EXCHANGE_S_FOUNDATION; FLOW_P2_VIRAL; FLOW_P2_VIRAL_REAL;...                           |
| Microsoft Power Automate Free         | FLOW_FREE                  | Enabled          | User      | 14            | DYN365_CDS_VIRAL; EXCHANGE_S_FOUNDATION; FLOW_P2_VIRAL                                                  |
| Microsoft 365 E3                      | SPE_E3                     | Enabled          | User      | 8             | AAD_PREMIUM; ADALLOM_S_DISCOVERY; Bing_Chat_Enterprise; BPOS_S_TODO_2; CDS_...                           |
| Microsoft 365 Business Standard       | O365_BUSINESS_PREMIUM      | Enabled          | User      | 1             | Bing_Chat_Enterprise; BPOS_S_TODO_1; CDS_O365_P2; CLIPCHAMP; Deskless; DYN3...                          |

