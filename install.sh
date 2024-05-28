
echo "start download Virtual Box"

sudo apt update && apt upgrade -y

# sudo apt-get install virtualbox 

sudo apt-get install p7zip-full -y

# cp /home/terakey/VantageExpress17.20_Sles12_20230220064202.7z /opt/downloads/

7z x /home/terakey/ve.7z

# export VM_IMAGE_DIR=" /home/terakey/VantageExpress17.20_Sles12"
# DEFAULT_VM_NAME="vantage-express"
# VM_NAME="${VM_NAME:-$DEFAULT_VM_NAME}"
# vboxmanage createvm --name "$VM_NAME" --register --ostype openSUSE_64
# vboxmanage modifyvm "$VM_NAME" --ioapic on --memory 6000 --vram 128 --nic1 nat --cpus 4
# vboxmanage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
# vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  "$(find $VM_IMAGE_DIR -name '*disk1*')"
# vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 1 --device 0 --type hdd --medium  "$(find $VM_IMAGE_DIR -name '*disk2*')"
# vboxmanage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 2 --device 0 --type hdd --medium  "$(find $VM_IMAGE_DIR -name '*disk3*')"
# vboxmanage modifyvm "$VM_NAME" --natpf1 "tdssh,tcp,,4422,,22"
# vboxmanage modifyvm "$VM_NAME" --natpf1 "tddb,tcp,,1025,,1025"
# vboxmanage startvm "$VM_NAME" --type headless
# vboxmanage controlvm "$VM_NAME" keyboardputscancode 1c 1c
