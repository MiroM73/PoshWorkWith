$list = New-Object Collections.Generic.LinkedList[Hashtable]

For ($i = 1; $i -lt 10; $i++)
{
   $list.AddLast(@{ID = $i; X = 100 + $i; Y = 100 + $i })
}

$current = $list.First

while (-not ($null -eq $current))
{
   If ($current.Value.X -eq 105)
   {
      $list.AddAfter($current, @{ID = 128; X = 128; Y = 128 })
      Break
   }

   $current = $current.Next
}

ForEach ($item In $list)
{
   Write-Host "ID:"$item.ID", X:"$item.x", Y:"$item.y", TYPE:" $item.GetType()
}