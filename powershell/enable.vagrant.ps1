
$_before=$pwd

mkdir C:\Users\appveyor\.vagrant.d | Out-Null
mkdir C:\downloads | Out-Null

cd C:\downloads
Start-FileDownload "https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.msi"
Start-FileDownload "https://download.virtualbox.org/virtualbox/6.0.22/VirtualBox-6.0.22-137980-Win.exe"

Start-Process -FilePath "msiexec.exe" -ArgumentList "/a vagrant_2.2.4_x86_64.msi /qb TARGETDIR=C:\Vagrant" -Wait
Start-Process -FilePath "VirtualBox-6.0.22-137980-Win.exe" -ArgumentList "-silent -logging -msiparams INSTALLDIR=C:\VBox" -Wait

cd $_before.Path

$ENV:Path="C:\Vagrant\HashiCorp\Vagrant\bin;C:\VBox;"+$ENV:Path

