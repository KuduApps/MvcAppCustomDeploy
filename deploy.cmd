@echo off
SETLOCAL
:: Specify project file
IF "%PROJECT%" == "" (
   SET PROJECT=MvcAppCustomDeploy\MvcAppCustomDeploy.csproj
)

IF "%PROJECT%" == "PROJECTFILEGOESHERE" goto MissingProject

:: Specify project configuration
SET CONFIG=Release
IF "%CONFIG%" == "" (
  SET CONFIG = Release
)

SET ARTIFACTS=%~dp0%artifacts

IF NOT DEFINED DEPLOYMENT_TARGET (
  SET DEPLOYMENT_TARGET=%ARTIFACTS%\wwwroot
)

IF NOT DEFINED DEPLOYMENT_SOURCE (
  SET DEPLOYMENT_SOURCE=%~dp0%
)

IF NOT DEFINED DEPLOYMENT_TEMP (
  SET DEPLOYMENT_TEMP=%ARTIFACTS%\temp
)

:: Copy the project artifacts into temp
echo Building %PROJECT%...
%WINDIR%\Microsoft.NET\Framework\v4.0.30319\MSBuild %PROJECT% /v:minimal /nologo /t:pipelinePreDeployCopyAllFilesToOneFolder /p:Configuration=%CONFIG% /p:SolutionDir=%DEPLOYMENT_SOURCE% /p:_PackageTempDir="%DEPLOYMENT_TEMP%" /p:AutoParameterizationWebConfigConnectionStrings=false
if ERRORLEVEL 1 exit /b 1

:: Copy the artifacts to the target
echo Copying files to from '%DEPLOYMENT_TEMP%' to '%DEPLOYMENT_TARGET%'
xcopy "%DEPLOYMENT_TEMP%" "%DEPLOYMENT_TARGET%" /Y /Q /E /I
exit /b 0

:MissingProject
echo The target project (PROJECT) was not specifed
exit /b 1