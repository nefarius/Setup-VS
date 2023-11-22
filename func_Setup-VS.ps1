function Invoke-CmdScript {
    param(
        [String] $scriptName
    )
    $cmdLine = """$scriptName"" $args & set"
    & $Env:SystemRoot\system32\cmd.exe /c $cmdLine |
    select-string '^([^=]*)=(.*)$' | foreach-object {
        $varName = $_.Matches[0].Groups[1].Value
        $varValue = $_.Matches[0].Groups[2].Value
        set-item Env:$varName $varValue
    }
}

function Register-VisualStudio {
    param(
        [Parameter(Mandatory = $false)][string]$Version,
        [Parameter(Mandatory = $false)][string]$Edition,
        [Parameter(Mandatory = $false)][string]$Platform
    )

    if (!($Version)) {
        $Version = '2022'
    }

    if (!($Edition)) {
        $Edition = 'Community'
    }

    if (!($Platform)) {
        $Platform = 'x64'
    }

    $x86template = "C:\Program Files (x86)\Microsoft Visual Studio\{0}\{1}\VC\Auxiliary\Build\vcvarsall.bat"
    $x64template = "C:\Program Files\Microsoft Visual Studio\{0}\{1}\VC\Auxiliary\Build\vcvarsall.bat"

    Invoke-CmdScript "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" $Platform
}
