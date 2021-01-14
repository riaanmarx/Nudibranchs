@echo off
@SET PATH=%PATH%;C:\Program Files\IIS\Microsoft Web Deploy V3

MSDEPLOY.exe -verb:sync -source:contentPath="C:\Project files\Nudibranchs\websites\Nudibranchs\js" -dest:contentPath="nudibranchs/js",ComputerName="https://nudibranchs.scm.azurewebsites.net:443/msdeploy.axd?site=Nudibranchs",authType="Basic",userName="$Nudibranchs",password="scarprfmAomg4JYr6DTz2Mp9u2wrQlDGvXj9Piqk72utSJcH0xpDmiegxSnL"
rem MSDEPLOY.exe -verb:dump
		
rem authType=Basic,userName=Nudibranchs\$Nudibranchs,password=scarprfmAomg4JYr6DTz2Mp9u2wrQlDGvXj9Piqk72utSJcH0xpDmiegxSnL -whatif 

pause