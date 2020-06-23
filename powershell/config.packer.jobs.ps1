
$WORKING=$args[0]
$SCRIPT=$args[1]

cd $WORKING
packer build -only hyperv-iso -var hyperv_switch=vmnet8 $SCRIPT
