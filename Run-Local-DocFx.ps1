param 
(
    [Parameter(Mandatory = $true)]
    [ValidateLength(1,255)]
    [ValidateNotNull()]
    [string]
    $DocFXJson
)

docfx.exe $DocFXJson --serve
