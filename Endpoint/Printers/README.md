# Printers

## Why?
At my workplace, we've found a need to deploy printers via Intune/MEM without using Azure Universal Print. The job count for Azure Universal Print is severly restrictive unless you pay a reasonable sum per month to be able to print. This should not be the case. This also becomes harder if you're not using Microsoft 365 Business Premium licenses as there's no print allocation provided. Maybe you want to use Intune, or maybe you want to include printer deployment into an onboarding process - you should have options!

## Setup

To achieve a 'free' Deployment, Detection & Removal of TCP/IP Printers, we need three things:

-  A name for our printer
-  Port Information, e.g. TCP/IP Address
-  Driver INF, Catalog and INI files packaged into a ZIP File

1. ***Obtain the driver*** required and figure out its INF File name - you might need to manually install the driver to see this. (Print Management is your friend)
2. ***Add the Driver folder to a Zip*** file with the format: Driver\MB5100P6.INF (Example)
3. ***Update the variables*** across the Deployment, Detection and Uninstall scripts.
4. ***Package & Update Intune/MEM*** to deploy with the following options:

***Install Command:***
powershell.exe -ExecutionPolicy bypass -file Deploy_Printer_COMPANY_BRAND_MODEL_SUBMODEL.ps1

***Uninstall Command:***
powershell.exe -ExecutionPolicy bypass -file Uninstall_Printer_COMPANY_BRAND_MODEL_SUBMODEL.ps1

***Install Context:***
System

***Detection Script:***
Detect_Printer_COMPANY_BRAND_MODEL_SUBMODEL.ps1

***Run script as 32-bit process on 64-bit clients:***
No

***Enforce Script Signature Check and Run script silently:***
No

## What this does
Upon installation, the script unzips & installs the driver, creates a named printer TCP/IP Port and finally, a print queue. The detection script is uploaded to MEM and you can call the uninstall script for printer removal. This allows complete printer management without a centralised print server.

Unfortunately, you cannot deploy secure print/printer defaults to the printer, however some driver vendors allow you to remove colour from the driver by repackaging e.g. Ricoh. Typically, this will require a managed print service.

## Credits
Thanks to ***Madhu Perera*** for 90% of the development of this - check him out here:

https://github.com/madhuperera/
