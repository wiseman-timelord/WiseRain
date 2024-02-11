# WiseRain

### Status : Beta
After leaving the given panels on for hours it was causing a hard-crash, it happened a lot less with the bandwidth monitor panel disabled, but still happened; I am currently testing some updates, they are present in v1.10...
- Ensured timers are odd numbers, Monitor=5s, System=9s and Network=13s, for less clashing.
- Ensured variables are unique with min 8 characters plus a 3 letter/number hash at end. 

## DESCRIPTION
Here is the official Wiseman-Timelord RainMeter skin, yes there is one. This skin is a PowerShell focused skin, that utilizes "PowershellRM", while it may not be necessary to be using this, it provides comprihensive future development potential. If looking for a blueprint to make an advanced custom rain-meter skin based on powershell scripts with all, of the basic requirements in place and done through the use of cmdlets, therein...
- Version 1.00 is a good lightweight base, for people wishing to develop their own powershell based scriptsm; newer versions have less comments too.
- Version 1.05, has a few more, features and improvements, and uses a Psd1 file requiring saving each iteration of a <1kb temp file, while monitoring panel is active.
- Version 1.09, see the monitoring on a separate panel, as well as safer code to update the psd1. 

### FEATURES
- ** Dark Theme **: Designed for dark-themed desktops, where the background is dark-grey and the text is light-grey or white.
- ** User Friendly **: Use of powershell scripts with clearly commented global variables at the top, for customized readings.
- ** Multi-Panel **: Currently has 2 panels, System and Network.
- ** Plugin Enhancement **: Use of "PowershellRM" with, Ps1s and Psd1 (=>v1.02), for enhanced powershell support.
- ** Compatibility **: Supports, IPv4 and truncated IPv6, display of IP address on network panel.
- ** Real-World Units **: Monitoring is in KB/s not Kb/s.

## PREVIEW
System Panel  (10 seconds refresh)..
```
====== System Panel ======
Processor Info:
CXX/TXX - X% - XXXXMHz

Temporary Spaces:
Memory - XX.XGB/XX.XGB
RamDrive - XX.XGB/XX.XGB

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
3. Copy the `WiseRain` folder into your `RainMeter\Skins` folder.
4. Edit the global variables at the top of, ".\system\System.ps1" and ".\network\Netork.ps1", to point to the appropriate locations. If you do not use a Ramdrive, then set the, drive letter and rename the label, to TempDrive D??, failing that, then the SystemDrive C; it should not be left to a dead location, for good practice.
5. Load rain meter or Refresh the skins display, then navigate in the folders in RainMeter, load the 2 panels from `WiseRain` named, `system.ini` and `network.ini`, as you normally would the panels of other skins.   

### UPDATING
- When updating I suggest deleting the old "WiseTime-RM" folder and replacing with the new, as, files and filenames, differ between versions, and yes this will require editing the variables again.

### REQUIREMENTS
1. [RainMeter](https://www.rainmeter.net/) (to load the skin).
2. Powershell => v3.0.
3. [PowershellRM](https://github.com/khanhas/PowershellRM) (plugin for enhanced powershell support).

### NOTATION
- RainMeter will flash up a script, you cannot use loops and variables cannot sustain changes, unless you have some kind of additional script running.
- It is possible to use additional plugins for input on panels.
- It is possible to use rainmeter as a gui for powershell projects.

## Development
Here are some possible directions for development...
1. Add new stealthed script producing ongoing operation to fetch all values from all the cmdlets, other scripts will check for this, and if its not running, then run it; the same signal should reset a countdown untill the process stops running, for example 60 seconds to self termination; thus solving spamming cmdlets with stop/start. each request from the 3 scripts should result with the most recent stats from the stealth script's psd1 being sent back to the relevant 1 of the 3 scripts by the stealth script, this way, the cmdlets can be kept active and the psd1 can be safely written to/read from, and the process will not remain running while not in use.
2. Some kind of notation, top 5 important tasks, short note of for example 5 items with editing/input through plugin.
3. A stripped down version of CreditSight in its own panel, with use of additional plugins there will be input box (CreditSight must be completed first).

### CANCELLATIONS
- Button to enable/disable monitoring, it would require its own panel just to have a button in order for higher refresh, obviously its better to right-click enable/disable monitor.ini. Will re-asses this if there are other new panels added.
- Top 3 bandwidh using apps, this required special libraries to achieve, at least it was not possible through, cmdlets and .net 4.0.

## DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
