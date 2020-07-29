
SET TOLSET=F:\TEMP\hariboteos\hariboteos\tolset
SET PATH=%TOLSET%\z_tools;%PATH%

copy helloos.img %TOLSET%\z_tools\qemu\fdimage0.bin
make.exe -C %TOLSET%\z_tools\qemu
