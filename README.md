# vboxhardening

This is a collection of scripts and binary files which you can use to harden your VirtualBox installation on Ubuntu/Linux.
The scripts are patching the VirtualBox source code and the VirtualBox VM in a way that it is hard for a malware sample 
to detect that it is running on a Virtual Machine.

You can find a manual how to install and use them in the VirtualBox Hardening.pdf document. 

Disclaimer:
These scripts are dirty hacks with limited error checking, in other words think before you execute them e.g. check if 
the working directories are fine etc. You are using the scripts on your own risk.

The scripts are tested on:
Ubuntu 16.04.2 LTS server (ubuntu-16.04.2-server-amd64.iso) on 16 Apr 2017 (last time) and should work fine this system.
