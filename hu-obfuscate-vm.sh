#!/bin/bash

# main parts from ...
# http://blog.prowling.nu/search?updated-min=2013-01-01T00:00:00%2B01:00&updated-max=2014-01-01T00:00:00%2B01:00&max-results=2

# get values from:
#
# dmidecode -t0, -t1, t2, -t3, -t4 and -t11 to gather the information need for the script below 
#

# Change the VBox settings for the guest to use PIIX3 (controller: IDE -> Attributes).

# !!! The script should be run with the guest powered off and the VirtualBox GUI closed !!!


# Generate your own SLIC Image
# sudo dd if=/sys/firmware/acpi/tables/SLIC of=SLIC.bin
# mv SLIC.bin /home/<user>/VirtualBox\ VMs/<vm>/SLIC.bin
# sudo chown <vbox users>.<vbox user> /home/<user>/VirtualBox\ VMs/<vm>/SLIC.bin

# Generate your own DSDT
# dd if=/sys/firmware/acpi/tables/DSDT of=ACPI-DSDT.bin
# If your replacement ACPI tables from linux are too large (as it was in my case) or for some other reason don't work, 
# download Read & Write Everything from http://rweverything.com/, and use it to dump the full binary default tables under 
# your Windows guest. 
# Copy the file onto your host and edit it either with a hex editor or by decompiling using iasl -d AcpiTbls.bin, then editing 
# the resulting .dsl script and then recompiling using iasl -tc AcpiTbls.dsl. Set the resulting .aml binary table as your ACPI table 
# using VBoxManage setextradata <machine> "VBoxInternal/Devices/acpi/0/Config/CustomTable" "/yourpath/DSDT.aml". Be sure to at least 
# change all vendor names from VBox/Virtualbox/innotek to something else.

# use "VBoxManage list vms" to see VM names

# usage: obfuscate.sh"

echo "This script is patching an existing VirtualBox VM. It obfuscates a couple of HW strings"
echo "Make sure the VM and VirtualBox App is closed before you execute this script"

VMLIST="$(VBoxManage list vms|cut -d' ' -f1)"
echo "Installed VMs:"

count=0
for i in $VMLIST; do
	count=`expr $count + 1`
	echo [$count] $i
done
echo -n "Which one do you want to patch (1-$count): "
read VMNUM

VMNAME=$(echo $VMLIST | cut -d" " -f$VMNUM | cut -d\" -f2)

echo -n "Ok. Should we start patching VM: \"$VMNAME\" (y/N)? "
read s
if [ "$s" != "y" ]; then
        echo "ok, nothing done.";
	exit 1
fi

echo "Start patching, pls wait...."

VBODIR="/home/talos/sources/HU_VirtualBoxObfuscateHW2017"

SLIC="$VBODIR/vbox-obfuscator-data/SLIC.bin"
DSDT="$VBODIR/vbox-obfuscator-data/ACPI-DSDT.bin"
SSDT="$VBODIR/vbox-obfuscator-data/ACPI-SSDT1.bin"
SPLASH="$VBODIR/vbox-obfuscator-data/splash.xcf"
VIDEO="$VBODIR/vbox-obfuscator-data/videorom.bin"
PCBIOS="$VBODIR/vbox-obfuscator-data/pcbios.bin"
PXE="$VBODIR/vbox-obfuscator-data/pxerom.bin"
ACPIDSDT="$VBODIR/vbox-obfuscator-data/ACPI-DSDT-new.bin"
ACPISSDT="$VBODIR/vbox-obfuscator-data/ACPI-SSDT1-new.bin"

VBOXMAN="/usr/local/bin/VBoxManage"

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/ahci/0/Config/Port0/SerialNumber"     "K30GT7B25GKD"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/ahci/0/Config/Port0/FirmwareRevision" "0000001A"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/ahci/0/Config/Port0/ModelNumber"      "FUJITSU MHW2160BJ G2"

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/ahci/0/Config/Port1/ATAPIVendorId"  "Optiarc"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/ahci/0/Config/Port1/ATAPIProductId" "DVD RW AD-7710H"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/ahci/0/Config/Port1/ATAPIRevision"  "1.S0"

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSVendor"        "HP"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSVersion"       "1.17"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSReleaseDate"   "03/31/2006"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSReleaseMajor"  117
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSReleaseMinor"  22
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSFirmwareMajor" 2
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBIOSFirmwareMinor" 3

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemVendor"      "HP"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemProduct"     "ProLiant DL140 G2"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemVersion"     "419758-001"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemSerial"      "MX262900Z4"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemSKU"         "<EMPTY>"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemFamily"      "Xeon"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiSystemUuid"        "747EED80-64DE-1000-BEF2-D628C931D455"

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardVendor"       "Wistron Corporation"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardProduct"      "M75ILA"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardVersion"      "Revision A1"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardSerial"       "L3X4719"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardAssetTag"     "<EMPTY> "
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardLocInChass"   "Not Present"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiBoardType"         ""

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiChassisVendor"     "HP"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiChassisVersion"    "N/A"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiChassisType"       "10"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiChassisSerial"     "MX262900Z4"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiChassisAssetTag"  " "

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiProcManufacturer"  "Intel"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiProcVersion"       "Intel(R) Xeon(TM) CPU"

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiOEMVBoxVer"        "string:0x00001234"
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/DmiOEMVBoxRev"        " "

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/acpi/0/Config/CustomTable" $SLIC
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/acpi/0/Config/AcpiOemId" "ASUS"

$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/acpi/0/Config/DsdtFilePath" $ACPIDSDT
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/acpi/0/Config/SsdtFilePath" $ACPISSDT
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/vga/0/Config/BiosRom" $VIDEO
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/BiosRom" $PCBIOS
$VBOXMAN setextradata "$VMNAME" "VBoxInternal/Devices/pcbios/0/Config/LanBootRom" $PXE

$VBOXMAN modifyvm "$VMNAME" --macaddress1 6CF1481A9E03			# change MAC of virtual NIC
#$VBOXMAN modifyvm "$VMNAME" --bioslogoimagepath $SPLASH		# DOES NOT WORK anymore, dunno what Orcale has changed
$VBOXMAN modifyvm "$VMNAME" --paravirtprovider legacy			# avoid idetection by cpuid check

$VBOXMAN getextradata "$VMNAME" enumerate

