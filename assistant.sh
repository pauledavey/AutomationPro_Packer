#!/bin/bash
clear

function menu() {
SEL=$(whiptail --title "AutomationPro - Hashicorp Assistant" --menu "Choose an option" 8 78 0 \
   "1" "Install Packer 1.6.2" \
   "2" "Install Vault 1.5.3" \
   "3" "Clone AutomationPro Hashicorp Public Repo" \
   "4" "Exit" 3>&1 1>&2 2>&3)

case $SEL in
   1)
	CheckSystemRequirements
	CreateRequiredPackerFolders
	DownloadPacker
	ExtractPacker
	CleanupPacker
	whiptail --title "Automationpro Configurator" --msgbox "Configuration is complete. For more information please check the github repository and/or its' WIKI" 8 78 0
   ;;
   2)
        CheckSystemRequirements
        CreateRequiredVaultFolders
        DownloadVault
        ExtractVault
        GetVaultHcl
        InitialVaultConfigurationPart1
        InitialVaultConfigurationPart2
        StartVault
        CleanupVault
   ;;
   3)
        CloneAutomationProPackerGithubPublicRepo
   ;;
   4)
        exit
   ;;
esac
}

## Common
function CheckSystemRequirements() {
  { echo -e "XXX\n0\nInstalling wget via yum\nXXX"
     yum install wget -y
     echo -e "XXX\n25\nInstalling unzip via yum\nXXX"
     yum install unzip -y
     echo -e "XXX\n50\nInstalling nano via yum\nXXX"
     yum install nano -y
     echo -e "XXX\n75\nInstalling git via yum\nXXX"
     yum install git -y
     sleep 2s
  } | whiptail --gauge "Installing any missing requirements" --title "Automationpro Configurator" 8 78 0
}


## Vault
function InitialVaultConfigurationPart1() {
  {  echo -e "XXX\n10\nCreate Vault user (non-privileged)\nXXX"
     sudo useradd --system --home /etc/vault.d --shell /bin/false vault
     echo -e "XXX\n30\nSetting owner on /usr/local/bin/hashicorp/vault153/vault\nXXX"
     sudo chown -R vault:vault /usr/local/bin/hashicorp/vault153
     echo -e "XXX\n67\nConfigure Vault autocomplete\nXXX"
     ./usr/local/bin/hashicorp/vault153/vault -autocomplete-install
     echo -e "XXX\n88\nEnable Vault autocompletion\nXXX"
     complete -C ./usr/local/bin/hashicorp/vault153/vault vault
  } | whiptail --gauge "Initial Vault configuration (part1)" --title "Automationpro Configurator" 8 78 0
}

function InitialVaultConfigurationPart2() {
   VAULTSERVICEFILE="https://raw.githubusercontent.com/pauledavey/AutomationPro_Hashicorp/master/vault.service"
   wget -P /etc/systemd/system "$VAULTSERVICEFILE" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading vault_1.5.3_linux_amd64.zip" --title "Automationpro Configurator" 8 78 0
}

function CreateRequiredVaultFolders() {
  { echo -e "XXX\n0\nFolders in path '/usr/local/bin/hashicorp/vault153/vaultdata'\nXXX"
     mkdir -p /usr/local/bin/hashicorp/vault153
     sleep 2s
  } | whiptail --gauge "Creating any missing [required] folders" --title "Automationpro Configurator" 8 78 0
}

function StartVault() {
   { echo -e "XXX\n40\nSystemctl enable vault\nXXX"
     systemctl enable vault
     echo -e "XXX\n80\nStart Vault server\nXXX"
     systemctl start vault
     sleep 5s
     ./usr/local/bin/hashicorp/vault153/vault operator init > usr/local/bin/hashicorp/vault153/init.file
  } | whiptail --gauge "Starting Vault" --title "Automationpro Configurator" 8 78 0

}

function DownloadVault() {
   VAULTURL="https://releases.hashicorp.com/vault/1.5.3/vault_1.5.3_linux_amd64.zip"
   wget -P /usr/local/bin/hashicorp/vault153 "$VAULTURL" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading vault_1.5.3_linux_amd64.zip" --title "Automationpro Configurator" 8 78 0
}

function GetVaultHcl() {
   VAULTCONFIGURL="https://raw.githubusercontent.com/pauledavey/AutomationPro_Hashicorp/master/config.hcl"
   wget -P /usr/local/bin/hashicorp/vault153 "$VAULTCONFIGURL" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading basic vault.hcl file" --title "Automationpro Configurator" 8 78 0
}

function ExtractVault() {
   (pv -n /usr/local/bin/hasicorp/vault152/vault_1.5.3_linux_amd64.zip | unzip /usr/local/bin/hashicorp/vault153/vault_1.5.3_linux_amd64.zip -d /usr/local/bin/hashicorp/vault153/ ) 2>&1 | whiptail --gauge "Extracting vault_1.5.3_linux_amd64.zip" --title "Automationpro Configurator" 8 78 0
}

## Packer
function CreateRequiredPackerFolders() {
  { echo -e "XXX\n0\nFolders in path '/usr/local/bin/hashicorp/packer162'\nXXX"
     mkdir -p /usr/local/bin/hashicorp/packer162
     sleep 2s
  } | whiptail --gauge "Creating any missing [required] folders" --title "Automationpro Configurator" 8 78 0
}

function DownloadPacker() {
   PACKERURL="https://releases.hashicorp.com/packer/1.6.2/packer_1.6.2_linux_amd64.zip"
   wget -P /usr/local/bin/hashicorp/packer162 "$URL" 2>&1 | sed -un 's/.* \([0-9]\+\)% .*/\1/p' | whiptail --gauge "Downloading packer_1.6.2_linux_amd64.zip" --title "Automationpro Configurator" 8 78 0
}

function ExtractPacker() {
   (pv -n /usr/local/bin/hasicorp/packer162/packer_1.6.2_linux_amd64.zip | unzip /usr/local/bin/hashicorp/packer162/packer_1.6.2_linux_amd64.zip -d /usr/local/bin/hashicorp/packer162/ ) 2>&1 | whiptail --gauge "Extracting packer_1.6.2_linux_amd64.zip" --title "Automationpro Configurator" 8 78 0
}

function CleanupPacker() {
       rm -r -f /usr/local/bin/hashicorp/packer162/packer_1.6.2_linux_amd64.zip
       sleep 2s | whiptail --gauge "Removing packer_1.6.2_linux_amd64.zip archive" --title "Automationpro Configurator" 8 78 0
}

function CleanupVault() {
       rm -r -f /usr/local/bin/hashicorp/vault153/vault_1.5.3_linux_amd64.zip
       sleep 2s | whiptail --gauge "Removing vault_1.5.3_linux_amd64.zip archive" --title "Automationpro Configurator" 8 78 0
}

## Github Clone Option
function CloneAutomationProPackerGithubPublicRepo() {
   git clone https://github.com/pauledavey/AutomationPro_Hashicorp.git /usr/local/bin/hashicorp/automationpro > /dev/null 2>&1 |
   stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' |
   whiptail --gauge "Cloning AutomationPro Packer Github repository" --title "Automationpro Configurator" 8 78 0
}


#### 
echo "Making magic.. please wait.."
cd /tmp
wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/pv-1.4.6-1.el7.x86_64.rpm
rpm -Uvh *rpm
clear
menu



