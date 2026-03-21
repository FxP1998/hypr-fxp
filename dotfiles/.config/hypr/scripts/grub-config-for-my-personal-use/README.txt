# -----------------------------------------------------------------------------
#  󰣇  GRUB CONFIGURATION GUIDE
#  󰀻  File: README.txt
#  󰁔  Description: Optimized kernel parameters for Hybrid Intel/AMD systems.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

󰒓 SYSTEM SPECIFICATIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  󰍛 RAM:        16 GB
  󰓅 CPU:        Intel i3-6006U (4) @ 2.0GHz
  󰢮 iGPU:       Intel Skylake GT2 [HD Graphics 520] (Driver: i915)
  󰢮 dGPU:       AMD Radeon R7 M520 [2 GB] (Driver: amdgpu)
  󰍹 Resolution: 1920x1080

󰚰 OPTIMIZATION LOGIC
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
To ensure the best performance and stability on this hybrid system, we 
specifically disable legacy 'radeon' support and force the modern 
'amdgpu' driver for the Southern Islands (SI) and Sea Islands (CIK) 
architectures.

󰁔 REQUIRED PARAMETERS:
  GRUB_CMDLINE_LINUX_DEFAULT="quiet splash radeon.si_support=0 radeon.cik_support=0 amdgpu.si_support=1 amdgpu.cik_support=1"

󰒓 INSTALLATION STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Open terminal and edit the GRUB file:
   sudo nano /etc/default/grub

2. Replace the existing GRUB_CMDLINE_LINUX_DEFAULT line with the one above.

3. Update the GRUB bootloader:
   sudo grub-mkconfig -o /boot/grub/grub.cfg

4. Reboot your system to apply changes.
