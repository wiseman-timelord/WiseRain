# WiseTime-Rm

### STATUS: DEVELOPMENT
This is a work in progress, progress will be slow, occasionally it will be improved, probably a little between projects.
- Figure out what forms of stats are desired in the panels, and how many panels.
- Additional stats, making use of a psd1 file and knowing the interface refresh speed, it is possible to write to the psd1 each time, and use this to calculate difference, for example, for calculating data transfer rates.
- Possibly a stripped down version of CreditSight in its own panel, with use of additional plugins there will be input box.

## DESCRIPTION
Here is the official Wiseman-Timelord RainMeter skin, it ain't nothing special, but there is one. This skin is a PowerShell focused skin, that utilizes "PowershellRM", while it may not be necessary to be using this, it provides comprihensive future development potential. If looking for a blueprint to make an advanced custom rain-meter skin based on powershell scripts, the current version is a great starting place, with all of the basic requirements in place.

### FEATURES
- ** Dark Theme **: Designed for dark-themed desktops, where the background is dark-grey and the text is light-grey or white.
- ** User Friendly **: Use of powershell scripts with clearly commented global variables at the top, for customized readings.
- ** Multi-Panel **: Currently has 2 panels, System and Network.
- ** Plugin Enhancement **: Use of "PowershellRM", for enhanced powershell support.

## PREVIEW
System..
```
    -= System Panel =-

Processor Info:
X% - XXXXMHz

Large Processes:
ProcessName01 - XXX.X MB
ProcessName02 - XXX.X MB
ProcessName03 - XXX.X MB
ProcessName04 - XXX.X MB
ProcessName05 - XXX.X MB

Temporary Spaces:
Memory - XX.X GB / XX.X GB
RamDrive - XX.X GB / XX.X GB
 
```
Network..
```
    -= Network Panel =-

Current Connections:
In - XXX.X.X.X
Out - XXX.XXX.X.X

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
4. Load rain meter or Refresh the skins display, then navigate in the folders in RainMeter, load the 2 panels from `WiseTime-Rm` named, `system.ini` and `network.ini`, as you normally would the panels of other skins.   

### REQUIREMENTS
1. [RainMeter](https://www.rainmeter.net/).
2. Powershell => 3.0.
3. [PowershellRM](https://github.com/khanhas/PowershellRM)

### NOTATION
- RainMeter will flash up a script, you cannot use loops and variables cannot sustain changes.
- Out of curiosity, yes it would be possible to use additional plugins for input on panels, then use rainmeter as a gui for llm chatbot interface with multi-panel output.

## DISCLAIMER
This software is subject to the terms in License.Txt, covering usage, distribution, and modifications. For full details on your rights and obligations, refer to License.Txt.
