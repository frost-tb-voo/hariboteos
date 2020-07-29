TOLSET     = F:/TEMP/hariboteos/hariboteos/tolset

# デフォルト動作

default :
	${TOLSET}/z_tools/make.exe img

# ファイル生成規則

ipl.bin : ipl.nas Makefile
	${TOLSET}/z_tools/nask.exe ipl.nas ipl.bin ipl.lst

helloos.img : ipl.bin Makefile
	${TOLSET}/z_tools/edimg.exe imgin:${TOLSET}/z_tools/fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0 imgout:helloos.img

# コマンド

asm :
	${TOLSET}/z_tools/make.exe -r ipl.bin

img :
	${TOLSET}/z_tools/make.exe -r helloos.img

run :
	${TOLSET}/z_tools/make.exe img
	copy helloos.img ..\z_tools\qemu\fdimage0.bin
	${TOLSET}/z_tools/make.exe -C ${TOLSET}/z_tools/qemu

install :
	${TOLSET}/z_tools/make.exe img
	${TOLSET}/z_tools/imgtol.com w a: helloos.img

clean :
	-del ipl.bin
	-del ipl.lst

src_only :
	${TOLSET}/z_tools/make.exe clean
	-del helloos.img
