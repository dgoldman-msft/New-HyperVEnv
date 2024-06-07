# New-HyperVEnv
Create a testing lab that can be used for EDR/XDR Testing

## Getting Started with New-HyperVEnv

This module will create a small Hyper-V environment that can be used for testing.

### DESCRIPTION

You have a choice of selecting 'All' which will create 3 Hyper-V machines for a domain controller, windows server and a windows 11 client as well as a Kali Linux machine, just the 3 windows machines or just the 1 kali linux machine.

### Examples

- EXAMPLE PS C:\NewEnv -All

        This will create a new environment using the alias 'NewEnv' and create 3 Windows machines and 1 kali linux machine with 4gb of ram and 2 processors (Default is 2)

- EXAMPLE PS C:\New-HyperVEnv -LabImageDirectory "C:\<Your Directory Name>\vhdfile.vhd" -Memory 4096 -DefaultProcessorCount 4

        This will create a new environment in a directory you specify instead of the default for 3 Windows machines and 1 kali linux machine with 4gb of ram and 4 processors (Default is 2)

- EXAMPLE PS c:\New-HyperVEnv -ImageType Kali

        This will create a new environment for 1 kali linux machine with the default settings

### NOTE ON EDR/EXR Testing

This lab can also be used for EDR/XDR testing if you have a Microsoft tenant with a valid E3 or E5 license. For full EDR/XDR testing you will need to download your tenants onboarding package from http://security.microsoft.com and onboarding your Windows 11 client. This will allow you to test penetration testing from the Kali linux host against all the Windows machines on an internal private network for the purposes of learning how the Microsoft Defender products work.