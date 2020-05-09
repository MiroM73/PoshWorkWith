$powershell = [powershell]::Create()
$RunspacePool = [runspacefactory]::CreateRunspacePool(1, [System.Environment]::ProcessorCount)
$powershell.RunspacePool = $RunspacePool
$RunspacePool.Open()

$script = {
    param(
        [int]$number
    )
    $result = 1
    for ($i = $number * 10 - 9; $i -le $number * 10; $i++)
    {
        $result *= $i
    }
}
$Runspaces = [System.Collections.ArrayList]::new()
foreach ($item in 1..10)
{
    $powershell = [powershell]::Create()
    $powershell.AddScript($script)
    $powershell.AddArgument($item)
    $powershell.RunspacePool = $RunspacePool
    $tmp = "" | Select-Object Powershell, StartTime, Runspace, Object
    $tmp.Powershell = $powershell
    $tmp.StartTime = [datetime]::Now
    $tmp.Runspace = $powershell.BeginInvoke()
    $tmp.Object = $item
    [void]$Runspaces.Add($tmp)
}

$RunspacePool.Dispose()
$RunspacePool.Close()


