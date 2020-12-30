# Below is a Custom Function that writes a log for a specified path based on Parameters.
# The only required parameter is the message, if you do not specify a log file path it will output the results in the terminal.
# Example using Proper Syntax = Write-Log -level INFO -message "This is a test" -logfile C:\Temp\test.txt
# Add this to Powershell Script to use this function.

Function Write-Log {
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$False)]
    [ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
    [String]
    $Level = "INFO",

    [Parameter(Mandatory=$True)]
    [string]
    $Message,

    [Parameter(Mandatory=$False)]
    [string]
    $logfile
    )

    $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    $Line = "$Stamp $Level $Message"
    If($logfile) {
        Add-Content $logfile -Value $Line
    }
    Else {
        Write-Output $Line
    }
}