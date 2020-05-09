$source = @"
    public class BasicTest
    {
        public static int Add(int a, int b)
        {
            return (a + b);
        }

        public int Multiply(int a, int b)
        {
            return (a * b);
        }
    }
"@

Add-Type -TypeDefinition $source
[BasicTest]::Add(4, 3)
$basicTestObject = New-Object BasicTest
$basicTestObject.Multiply(5, 2)

# compile into DLL and run in powershell
namespace MyMathLib
{
    public class Methods
    {
        public Methods(x)
        {
        }

        public static int Sum(int a, int b)
        {
            return a + b;
        }

        public int Product(int a, int b)
        {
            return a * b;
        }
    }
}

[Reflection.Assembly]::LoadFile("c:\temp\MyMathLib.dll")
[MyMathLib.Methods]::Sum(10, 2)

$mathInstance = New-Object MyMathLib.Methods
$mathInstance.Product(10, 2)


# as previous but C# code is changed
# remuved namespace and public methods()
$mymathlib = @"
    public class MyMathLib
    {
        public static int Sum(int a, int b)
        {
            return a + b;
        }

        public int Product(int a, int b)
        {
            return a * b;
        }
    }
"@

Add-Type -TypeDefinition $mymathlib
[MyMathLib]::Sum(2, 3)
$mathInstance = New-Object MyMathLib
$mathInstance.Product(2, 3)

$dlpclient = [Reflection.Assembly]::LoadFrom("C:\Scripts\DotNET\DLPClient\bin\Debug\netcoreapp2.0\DLPClient.dll")
$dlpclient.GetExportedTypes()
Add-Type -Path "C:\Scripts\DotNET\DLPClient\bin\Debug\netcoreapp2.0\DLPClient.dll"
$Error[0].InnerException.LoaderExceptions

try
{
    Add-Type -Path "C:\Scripts\DotNET\DLPClient\bin\Debug\netcoreapp2.0\DLPClient.dll"
}
catch [System.Reflection.ReflectionTypeLoadException]
{
    Write-Host "Message: $($_.Exception.Message)"
    Write-Host "StackTrace: $($_.Exception.StackTrace)"
    Write-Host "LoaderExceptions: $($_.Exception.LoaderExceptions)"
}

[dlprestclient]::
[dlprestmain] | Get-Member
[dlprestclient] | Get-Member
$dlpclient | Get-Member -Static
$dlpclient | Get-Member -Static

[System.Console]::WriteLine([datetime]::Now)

[System.Convert]::ToByte(12)
[convert]::ToString(10, 2)

$x = [System.Linq.Enumerable]::Range(1, 100)
$x.GetType()
$x.Where( { $_ % 4 -eq 0 })
$x | Get-Member -Static

try
{
    [System.AppDomain]::CurrentDomain.GetAssemblies() | Sort-Object fullname |
        ForEach-Object {
            $_.fullname
        }
}
catch
{
    $_
}

[System.AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
    $_.getexportedtypes() |
        Where-Object { $_ -match '^system\.timers' } | Select-Object `
        @{N = 'Assembly'; E = { ($_.Assembly -split ',')[0] } }, IsPublic, IsSerial, FullName, BaseType |
            Format-Table
}

[System.Net.Dns]::GetHostName()
[System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()
([System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()).GetActiveTcpConnections()
$IPprop = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()
$IPActive = $IPprop.GetActiveTcpConnections()
$IPActive | Format-Table localendpoint, remoteendpoint, state -AutoSize
$IPActive.remoteendpoint | ForEach-Object { $_.address.ipaddresstostring }
$IPprop | Get-Member
$a = [System.Net.NetworkInformation.TcpConnectionInformation]
$a | Get-Member


$x = [datetime]::now
$m = [datetime]::Now - $x
$m.add([timespan]::new(0, 0, 0, 1) )

$date1 = Get-Date 12.10.1973
$date2 = Get-Date

($date2 - $date1).ToString()

$f = 'c:\powershell\teest.txt'
$a = @('riadok 1', 'riadok 2', 'riadok 3')
$a = 1..1000000
$b = "doplneny text"
Measure-Command -Expression {
    [System.IO.File]::WriteAllLines($f, $a, [System.Text.UnicodeEncoding]::ASCII)
}

Measure-Command -Expression {
    Set-Content -Value $a -Path $f -Encoding Unicode
}

[System.IO.File]::AppendAllLines([string]$f, [string[]]$b, [System.Text.UnicodeEncoding]::Unicode)


if (-not [System.IO.File]::Exists($f))
{
    try
    {
        [System.IO.File]::Create($f)
    }
    catch [System.UnauthorizedAccessException]
    {
        [Management.Automation.ErrorRecord]$e = $_
        $info = [PSCustomObject]@{
            Exception = $e.Exception.Message
            Reason    = $e.CategoryInfo.Reason
            Target    = $e.CategoryInfo.TargetName
            Script    = $e.InvocationInfo.ScriptName
            Line      = $e.InvocationInfo.ScriptLineNumber
            Column    = $e.InvocationInfo.OffsetInLine
        }
        $info
    }
}

[System.IO.File]::GetAttributes('c:\scripts\powershell\get-factorial.ps1')
$file = [System.IO.Directory]::GetFiles('c:\scripts\powershell', '*te*')
$file

[System.IO.FileInfo]::new("c:\scripts\powershell\test.txt")

