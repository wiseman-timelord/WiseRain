# WiseTime-Rm

### STATUS: DEVELOPMENT
This is a work in progress, progress will be slow, occasionally it will be improved, probably a little between projects.
- A stripped down version of CreditSight in its own panel, with use of additional plugins there will be input box.
- A task list panel with input, self-maintenence/prioritizing.

## DESCRIPTION
Here is the official Wiseman-Timelord RainMeter skin, yes there is one. This skin is a PowerShell focused skin, that utilizes "PowershellRM", while it may not be necessary to be using this, it provides comprihensive future development potential. If looking for a blueprint to make an advanced custom rain-meter skin based on powershell scripts with all, of the basic requirements in place and done through the use of cmdlets, therein...
- Version 1.00 is a good lightweight base with a timer of 5000, though I advise changing this to 10000.
- Version 1.05, has a few more, features and improvements, with a timer of 15000, and uses a Psd1 file requiring saving each iteration of a <1kb temp file.
- The distinction between Versions 1.05a/b is related to the theme of panel titles, either it is, in the middle "-= TITLE =-" or across the whole thing "=== TITLE ===".

### FEATURES
- ** Dark Theme **: Designed for dark-themed desktops, where the background is dark-grey and the text is light-grey or white.
- ** User Friendly **: Use of powershell scripts with clearly commented global variables at the top, for customized readings.
- ** Multi-Panel **: Currently has 2 panels, System and Network.
- ** Plugin Enhancement **: Use of "PowershellRM" with, Ps1s and Psd1 (=>v1.02), for enhanced powershell support.

## PREVIEW
System Panel..
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
ProcessName04 - XXX.X MB
ProcessName05 - XXX.X MB

```
Network Panel..
```
====== Network Panel =====

Current Connections:
In - XXX.X.X.X
Out - XXX.XXX.X.X

Transfer Rates:
Inbound - XX.XX KB/s
Outbound - XX.XX KB/s

Recent Downloads:
DownloadFileName01.Ext
DownloadFileName02.Ext
DownloadFileName03.Ext
DownloadFileName04.Ext
DownloadFileName05.Ext
 
```

## USAGE
1. Download and Install, the plugin [PowershellRM](https://github.com/khanhas/PowershellRM) into your `Rainmeter/Plugins` folder.
2. Download `Wiseman-Timelords Rainmeter Skin`, and then unpack it to a suitable location.
3. Copy the `WiseTime-Rm` folder into your `RainMeter\Skins` folder.
4. Edit the global variables at the top of, ".\system\System.ps1" and ".\network\Netork.ps1", to point to the appropriate locations.
5. Load rain meter or Refresh the skins display, then navigate in the folders in RainMeter, load the 2 panels from `WiseTime-Rm` named, `system.ini` and `network.ini`, as you normally would the panels of other skins.   

### REQUIREMENTS
1. [RainMeter](https://www.rainmeter.net/) (to load the skin).
2. Powershell => v3.0.
3. [PowershellRM](https://github.com/khanhas/PowershellRM) (plugin for enhanced powershell support).

### NOTATION
- RainMeter will flash up a script, you cannot use loops and variables cannot sustain changes.
- It is possible to use additional plugins for input on panels, then use rainmeter as a gui for powershell projects.
- 

## DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
