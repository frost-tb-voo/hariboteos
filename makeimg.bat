
SET TOLSET=F:\TEMP\hariboteos\hariboteos\tolset
SET PATH=%TOLSET%\z_tools;%PATH%

edimg.exe imgin:%TOLSET%/z_tools/fdimg0at.tek wbinimg src:ipl.bin len:512 from:0 to:0 imgout:helloos.img
