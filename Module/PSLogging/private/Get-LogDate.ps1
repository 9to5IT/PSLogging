function Get-LogDate {
    <#
    .SYNOPSIS
    Creates a Date and Timestamp to be used in log file creation
    .DESCRIPTION
    Creates a nicely formatted timestamp for use in log creation
    .PARAMETER Format
    Displays the date and time in the Microsoft .NET Framework format indicated by the format specifier.
    Enter a format specifier. For a list of available format specifiers, see DateTimeFormatInfo Class http://msdn.microsoft.com/library/system.globalization.datetimeformatinfo.aspx (http://msdn.microsoft.com/library/system.globalization.datetimeformatinfo.aspx) in MSDN.
    .EXAMPLE
    Get-LogDate
    .EXAMPLE
    Get-LogDate -Format 'yyyy-MM-dd HH:mm:ss'
    .EXAMPLE
    Get-LogDate
    .NOTES
    Default formatting if no formatting provided: 'yyyy-MM-dd HH:mm:ss'
    #>
    Param(
        [Parameter(Position=0)]
        [String]$Format = 'MM-dd-yyyy HH:mm:ss.ffffff'
    )

    Get-Date -Format ("{0}" -f $Format)
}