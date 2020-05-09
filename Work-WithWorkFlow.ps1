#Requires -PSEdition Desktop
workflow hello
{
    param (
    )
    'Hello World!'
}

workflow Invoke-ParallelForEach
{
    foreach -parallel ($i in 1..10)
    {
        InlineScript {
            "foo: $using:i"
        }
        $count = Get-Process -Name powershell* |
            Measure-Object |
                Select-Object -ExpandProperty count
        "Number of powershell processes = $count"
    }
}
$startcount = Get-Process -Name powershell* |
    Measure-Object |
        Select-Object -ExpandProperty Count
"Number of starting powershell processes = $startcount"
Invoke-ParallelForEach

workflow p1
{
    param (
        $max = 4
    )
    foreach ($i in 1..$max) { $i }
    foreach ($j in $max..1) { $j }
}
p1

workflow p2
{
    param (
        $max = 4
    )
    parallel
    {
        foreach ($i in 1..$max) { $i }
        foreach ($j in $max..1) { $j }
    }
}
p2

Measure-Command -Expression { p1 100 } | Select-Object -ExpandProperty TotalMilliseconds
Measure-Command -Expression { p2 100 } | Select-Object -ExpandProperty TotalMilliseconds

workflow ps1
{
    param (
    )
    parallel
    {
        foreach ($i in 1..4) { $i }
        sequence
        {
            foreach ($k in 65..68) { [char][byte]$k }
            foreach ($k in 87..90) { [char][byte]$k }
        }
        foreach ($j in 4..1) { $j }
    }
}
ps1
"$(ps1)"

workflow is1
{
    param (
    )
    parallel
    {
        'Boot time from parallel: '
        Get-CimInstance -ClassName Win32_OperatingSystem |
            Select-Object -ExpandProperty lastbootuptime

        InlineScript {
            $os = Get-WmiObject -Class Win32_OperatingSystem
            'Boot time from inlinescript: '
            $($os.converttodatetime($os.lastbootuptime))
        }
    }
}
is1

workflow fe
{
    param (
    )
    'Do loop'
    $i = 1
    $j = @()
    do
    {
        $j += $i
        $i++
    } while ($i -le 10)
    "$j"

    'While loop'
    $i = 1
    $j = @()
    while ($i -le 10)
    {
        $j += $i
        $i++
    }
    "$j"

    'For loop'
    $j = @()
    for ($i = 1; $i -le 10; $i++)
    {
        $j += $i
    }
    "$j"

    'Foreach loop'
    $j = @()
    foreach ($i in 1..10)
    {
        $j += $i
    }
    "$j"
}
fe

workflow fep
{
    param (
    )
    foreach -parallel ($i in 1..10)
    {
        $i
    }
}
"$(fep)"


