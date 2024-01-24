# WiseTime-Rm

### STATUS: DEVELOPMENT
This is a work in progress, progress will be slow, occasionally it will be improved, probably a little between projects.
- Optimize & Improve powershell scripts, DONE: "monitor.ps1", "network.ps1".
- A stripped down version of CreditSight in its own panel, with use of additional plugins there will be input box.
- A task list panel with input, self-maintenence/prioritizing.

## DESCRIPTION
Here is the official Wiseman-Timelord RainMeter skin, yes there is one. This skin is a PowerShell focused skin, that utilizes "PowershellRM", while it may not be necessary to be using this, it provides comprihensive future development potential. If looking for a blueprint to make an advanced custom rain-meter skin based on powershell scripts with all, of the basic requirements in place and done through the use of cmdlets, therein...
- Version 1.00 is a good lightweight base, for people wishing to develop their own powershell based scripts.
- Version => 1.05, has a few more, features and improvements, and uses a Psd1 file requiring saving each iteration of a <1kb temp file.

### FEATURES
- ** Dark Theme **: Designed for dark-themed desktops, where the background is dark-grey and the text is light-grey or white.
- ** User Friendly **: Use of powershell scripts with clearly commented global variables at the top, for customized readings.
- ** Multi-Panel **: Currently has 2 panels, System and Network.
- ** Plugin Enhancement **: Use of "PowershellRM" with, Ps1s and Psd1 (=>v1.02), for enhanced powershell support.
- ** Compatibility **: Supports, IPv4 and truncated IPv6, display of IP address on network panel.

## PREVIEW
System Panel  (10 seconds refresh)..
```
====== System Panel ======
Processor Info:
CXX/TXX - X% - XXXXMHz

Temporary Spaces:
Memory - XX.XGB/XX.XGB
RamDrive1 - XX.XGB/XX.XGB
Ramdrive2 - XX.XGB/XX.XGB 

Large Processes:
ProcessName01 - XXX.X MB
ProcessName02 - XXX.X MB
ProcessName03 - XXX.X MB

```
Network Panel (10 seconds refresh)..
```
====== Network Panel =====

Current Connections:
IP In - XXX.X.X.X
IP Out - XXX.XXX.X.X

Recent Downloads:
DownloadFileName01.Ext
DownloadFileName02.Ext
DownloadFileName03.Ext

```
Monitor Panel (5 seconds refresh)..
```
==== Monitoring Panel ====

Total Rates:
Inbound - XX.XX KB/s
Outbound - XX.XX KB/s
 
```

## USAGE
1. Download and Install, the plugin [PowershellRM](https://github.com/khanhas/PowershellRM) into your `Rainmeter/Plugins` folder.
2. Download `Wiseman-Timelords Rainmeter Skin`, and then unpack it to a suitable location.
3. Copy the `WiseTime-Rm` folder into your `RainMeter\Skins` folder.
4. Edit the global variables at the top of, ".\system\System.ps1" and ".\network\Netork.ps1", to point to the appropriate locations.
5. Load rain meter or Refresh the skins display, then navigate in the folders in RainMeter, load the 2 panels from `WiseTime-Rm` named, `system.ini` and `network.ini`, as you normally would the panels of other skins.   
- When updating I suggest deleting the old "WiseTime-RM" folder and replacing with the new, as, files and filenames, differ, and yes this will require editing the variables again.

### REQUIREMENTS
1. [RainMeter](https://www.rainmeter.net/) (to load the skin).
2. Powershell => v3.0.
3. [PowershellRM](https://github.com/khanhas/PowershellRM) (plugin for enhanced powershell support).

### NOTATION
- RainMeter will flash up a script, you cannot use loops and variables cannot sustain changes.
- It is possible to use additional plugins for input on panels, then use rainmeter as a gui for powershell projects.
- The scripts assume "IPv4", if you 

### CANCELLATIONS
- Button to enable/disable monitoring, it would require its own panel just to have a button in order for higher refresh, obviously its better to right-click enable/disable monitor.ini.
- Top 3 bandwidh using apps, this required special libraries to achieve, at least it was not possible through, cmdlets and .net 4.0.

## DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
