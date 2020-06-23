
$PACKER_JOBS=@(
  'ubuntu-bionic-amd64.json',
  'ubuntu-focal-amd64.json',
  'centos-7-x86_64.json',
  'centos-8-x86_64.json'
)

function Check_Job($packer_json, $builder) {
  (! (Test-Path "appveyor_cache\$packer_json.$builder")) `
  -Or ((Get-Item "appveyor_cache\$packer_json.$builder").LastWriteTime -lt [datetime]::today)
}

function Touch_File($path) {
  If (! (Test-Path $path)) {
    New-Item -ItemType:File -Path $path | Out-Null
  } Else {
    (Get-Item -Path $path).LastWriteTime=Get-Date
  }
}

New-Item -Path appveyor_cache -Type Directory -Force | Out-Null
New-Item -Path builds -Type Directory -Force | Out-Null

# TODO: Not sure why using break will end the script??
#
$LOOP_FLAG=1
$PACKER_JOBS | foreach {
  If ($LOOP_FLAG) {
    If (Check_Job $_ "hyperv" -And Check_Job $_ "virtualbox") {
      Write-Host "Building hyperv and virtualbox providers for $_`n" -ForegroundColor Green

      $Env:HYPERV_JOB=$_
      $Env:VIRTUALBOX_JOB=$_

      $LOOP_FLAG=0
    }
  }
}

$PACKER_JOBS | foreach {
  If ($LOOP_FLAG -And (Check_Job $_ "hyperv")) {
    Write-Host "Building hyperv providers for $_`n" -ForegroundColor Green

    $Env:HYPERV_JOB=$_
    $LOOP_FLAG=0
  }

  If ($LOOP_FLAG -And (Check_Job $_ "virtualbox")) {
    Write-Host "Building virtualbox providers for $_`n" -ForegroundColor DarkGreen

    $Env:VIRTUALBOX_JOB=$_
    $LOOP_FLAG=0
  }
}
