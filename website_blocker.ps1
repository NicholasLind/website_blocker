Function Block-Website {
    Param($url)
    $hosts = 'C:\Windows\System32\drivers\etc\hosts'

    $is_blocked = Get-Content -Path $hosts |
    Select-String -Pattern ([regex]::Escape("127.0.0.1  $url"))

    If (-not $is_blocked) {
        Add-Content -Path $hosts -Value "127.0.0.1  $url"
    }

    # get chrome process
    $chrome = Get-Process chrome -ErrorAction SilentlyContinue
    if ($chrome) {
        # try gracefully first
        $chrome.CloseMainWindow()
        # kill after two seconds
        Sleep 2
        if (!$chrome.HasExited) {
            $chrome | Stop-Process -Force
        }
    }
    Remove-Variable chrome
    
    $Items = @('Cache\*')
    $Folder = "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default"
    $Items | % { 
        if (Test-Path "$Folder\$_") {
            Remove-Item "$Folder\$_" 
        }
    }
}


Function Unblock-Website {
    Param($url)
    $hosts = 'C:\Windows\System32\drivers\etc\hosts'

    $is_blocked = Get-Content -Path $hosts |
    Select-String -Pattern ([regex]::Escape($url))

    If ($is_blocked) {
        $newhosts = Get-Content -Path $hosts |
        Where-Object {
            $_ -notmatch ([regex]::Escape($url))
        }

        Set-Content -Path $hosts -Value $newhosts
    }
}