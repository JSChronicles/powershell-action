param(
    [Switch]$Fail,
    [Switch]$ExitCode,
    $Parameter1
)

if ($Fail) {
    throw "This script fails!"
}

if ($ExitCode) {
    exit 5
}

Get-ChildItem

$thing = "string"
$thing

$Env:MyVariable
$Parameter1
$PSVersionTable