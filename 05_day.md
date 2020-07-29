# 構造体と文字表示とGDT/IDT初期化
### 1.起動情報の受け取り (a)
asm.nas のメモする情報.

```nasm
; BOOT_INFO関係
CYLS	EQU		0x0ff0			; ブートセクタが設定する
LEDS	EQU		0x0ff1
VMODE	EQU		0x0ff2			; 色数に関する情報。何ビットカラーか？
SCRNX	EQU		0x0ff4			; 解像度のX
SCRNY	EQU		0x0ff6			; 解像度のY
VRAM	EQU		0x0ff8			; グラフィックバッファの開始番地
```

asm.nas のメモした情報を bootpack.c で受け取る.

```c
	char *vram;
	int xsize, ysize;
	short *binfo_scrnx, *binfo_scrny;
	int *binfo_vram;

	init_palette();
	binfo_scrnx = (short *) 0x0ff4;
	binfo_scrny = (short *) 0x0ff6;
	binfo_vram = (int *) 0x0ff8;
	xsize = *binfo_scrnx;
	ysize = *binfo_scrny;
	vram = (char *) *binfo_vram;
```

- init_screenを分離.
  - screen 下部で boxfill しているから上のほうで描画する分には問題ないということだろうか..

### 2.構造体を使ってみる (b)
struct を使う.

```c
struct BOOTINFO {
	char cyls, leds, vmode, reserve;
	short scrnx, scrny;
	char *vram;
};

void HariMain(void)
{
	char *vram;
	int xsize, ysize;
	struct BOOTINFO *binfo;

	init_palette();
	binfo = (struct BOOTINFO *) 0x0ff0;
	xsize = (*binfo).scrnx;
	ysize = (*binfo).scrny;
	vram = (*binfo).vram;

	init_screen(vram, xsize, ysize);

	for (;;) {
		io_hlt();
	}
}
```

### 3.矢印表記を使ってみる (c)

```c
	struct BOOTINFO *binfo = (struct BOOTINFO *) 0x0ff0;

	init_palette();
	init_screen(binfo->vram, binfo->scrnx, binfo->scrny);
```

- pointer の構造体内部のメンバーへは `(*binfo).scrx` あるいは `binfo->scrx` でアクセスできる
  - 長いこと使っていないと `->` が何の略記か忘れる

### 4.とにかく文字を出したい (d)
フォントの描画を自力でやる.

- 32ビットモードなので BIOS の用意している文字列描画命令が使えない..
- １文字あたり，8 (画素) x 16 行なので 8 bit x 16 = 16 bytes となる
  - 「行」という表現は本には書いてない. 正しいのか怪しい..
- ここではひとまずフォントデータを static char でハードコーディングする
  - フォントカラーで描画する位置を 1, 背景カラーで描画する位置を 0 とする
  - 背景はすでに描画されているはずなので描画処理の際には 0 の位置は何もしなくてよい

```c
	static char font_A[16] = {
		0x00, 0x18, 0x18, 0x18, 0x18, 0x24, 0x24, 0x24,
		0x24, 0x7e, 0x42, 0x42, 0x42, 0xe7, 0x00, 0x00
	};
```

- １行ごとにループで処理
  - COL8_FFFFFF はカラーパレットに登録されているカラー情報（４章を参照）

```c
void HariMain(void)
{
// ..
	putfont8(binfo->vram, binfo->scrnx, 10, 10, COL8_FFFFFF, font_A);
// ..
}
// ..
void putfont8(char *vram, int xsize, int x, int y, char c, char *font)
{
	int i;
	char *p, d /* data */;
	for (i = 0; i < 16; i++) {
		p = vram + (y + i) * xsize + x;
		d = font[i];
		if ((d & 0x80) != 0) { p[0] = c; }
		if ((d & 0x40) != 0) { p[1] = c; }
		if ((d & 0x20) != 0) { p[2] = c; }
		if ((d & 0x10) != 0) { p[3] = c; }
		if ((d & 0x08) != 0) { p[4] = c; }
		if ((d & 0x04) != 0) { p[5] = c; }
		if ((d & 0x02) != 0) { p[6] = c; }
		if ((d & 0x01) != 0) { p[7] = c; }
	}
	return;
}
```

描画される文字がでかくてビビる.

### 5.フォントを増やしたい (e)

- 独自フォーマット（ASCII Art）で書かれた hankaku.txt というファイルに OSASK のフォントデータが書かれている
  - makefont.exe で 256文字分のデータ（16 x 256 = 4096 bytes）hankaku.bin へ変換
  - hankaku.bin を obj （アセンブリ命令）へ変換
  - bim ファイル作成時にリンク（linux の場合は img 作成時？）
- hankaku.obj とリンクすることで bootpack.c のコードから `extern char hankaku[4096]` で参照できるようになる
  - 並びは ASCII に対応しているので, 例えば A のフォントデータへアクセスする場合は  `hankaku + 'A' * 16` で該当フォントデータの先頭位置へアクセスできる

ここから Makefile が微妙に変化.

```diff
--- ./harib02b/Makefile	2005-03-07 22:37:08.000000000 +0900
+++ ./harib02e/Makefile	2005-03-15 23:04:48.000000000 +0900
@@ -6,6 +6,8 @@
 CC1      = $(TOOLPATH)cc1.exe -I$(INCPATH) -Os -Wall -quiet
 GAS2NASK = $(TOOLPATH)gas2nask.exe -a
 OBJ2BIM  = $(TOOLPATH)obj2bim.exe
+MAKEFONT = $(TOOLPATH)makefont.exe
+BIN2OBJ  = $(TOOLPATH)bin2obj.exe
 BIM2HRB  = $(TOOLPATH)bim2hrb.exe
 RULEFILE = $(TOOLPATH)haribote/haribote.rul
 EDIMG    = $(TOOLPATH)edimg.exe
@@ -38,9 +40,15 @@
 naskfunc.obj : naskfunc.nas Makefile
 	$(NASK) naskfunc.nas naskfunc.obj naskfunc.lst
 
-bootpack.bim : bootpack.obj naskfunc.obj Makefile
+hankaku.bin : hankaku.txt Makefile
+	$(MAKEFONT) hankaku.txt hankaku.bin
+
+hankaku.obj : hankaku.bin Makefile
+	$(BIN2OBJ) hankaku.bin hankaku.obj _hankaku
+
+bootpack.bim : bootpack.obj naskfunc.obj hankaku.obj Makefile
 	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k map:bootpack.map \
-		bootpack.obj naskfunc.obj
+		bootpack.obj naskfunc.obj hankaku.obj
 # 3MB+64KB=3136KB
 
 bootpack.hrb : bootpack.bim Makefile
```

make の時間も若干長くなる.

### 6.文字列を書きたい (f)
文字を描画する関数 putfont8 を使って，文字列を描画する関数 putfonts8_asc を作る.

```c
void HariMain(void)
{
// ..
	putfonts8_asc(binfo->vram, binfo->scrnx,  8,  8, COL8_FFFFFF, "ABC 123");
	putfonts8_asc(binfo->vram, binfo->scrnx, 31, 31, COL8_000000, "Haribote OS.");
	putfonts8_asc(binfo->vram, binfo->scrnx, 30, 30, COL8_FFFFFF, "Haribote OS.");
// ..
}
// ..

void putfonts8_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s)
{
	extern char hankaku[4096];
	for (; *s != 0x00; s++) {
		putfont8(vram, xsize, x, y, c, hankaku + *s * 16);
		x += 8;
	}
	return;
}
```

- ループで `unsigined char *s` を順次読み取り 0x00 というデータが来たらループを終了する
  - "ABC 123" という文字列をコードに書くと，コンパイラで勝手に 0x00 という文字列の終わりを示す文字データを末尾へ付与する
- この例だと１画素ずらす，すなわち (31, 31) に同じ文字列を描画することで "Haribote OS." という文字列に影をつけている

### 7.変数の値の表示 (g)
haribote OS 上で print debugging できるようにする.

- 変数の中身を文字列に変換してそれを putfonts8_asc で描画
- [GO compiler](http://oswiki.osask.jp/?GO) による sprintf の実装を使う
  - sub project of OSASK. NOT Go
  - OS に依存しない実装となっている
  - 使うには c コード上で `#include stdio.h` する

### 8.マウスカーソルも書いてみよう (h)
描画するだけ. まだハードウェアとの情報のやり取りができないので動かすことはできない.

- マウスカーソルのデータをフォントデータ同様に準備する
  - 16 x 16 画素
  - init_mouse_cursor8 内で ASCII art を画素データに変換するようなことをしている
  - 背景色は引数 bc で受け取る
- putblock8_8 で描画
  - なぜか struct は使っていない
- vxsize は画面の横サイズ
- pxsize, pysize は描画する picuture size
  - px0, py0 は描画位置の基点
- buf は画像データへのポインタ
  - bsize は pxsize と同じ（行の切り替え位置）

### 9.GDT/IDT を初期化しよう (i)
マウスを動かすための初期設定を行う（まだ動かない）. 難易度が高いので説明も長い.

- asmhead.nas で行っていた設定を bootpack.c で書き直す

segmentation と GDT について.

- segmentation によって, 例えば同時に動いている複数のプログラムが同じメモリ位置に読み込まれること（競合）を防ぐ
  - segmentation があるので，それぞれのプログラムに割り当てられたメモリの先頭位置を（プログラムから見ると） 0 として扱える
- セグメントの構成情報（8 bytes）
  - limit : 大きさ
  - base : 開始位置（番地）
  - ar : 管理用属性（書き込み禁止，実行禁止，システム専用）
- CPU のセグメントレジスタ (16 bits, 実質 13 bits) で管理
  - セグメント情報の代わりにセグメント番号を保持させる（カラーパレットと同様）
  - セグメント番号には 0..8191 が使える
- セグメント情報そのものはメモリ上の **GDT (global segment descriptor table)** という専用の領域 (64KB = 8 bytes x 8192) に保持する
  - 大域セグメント記述子表
  - GDT の先頭番地と有効な segment 設定の個数を CPU の **GDTR レジスタ** に設定する

IDT (interrupt descriptor table) について.

- CPU には外部装置の状況変化や内部トラブルが起きると処理の切り替え（割り込み）を行う機能がある
  - 例えばキーボードからの入力（CPU の演算能力に比して非常に遅い）
  - 現在実行中の処理を一時中断して，あらかじめ設定しておいた割り込み用の関数を呼び出す
- マウスを使うには IDT を設定して割り込みを使えるようにする必要がある
  - IDT の設定方法は GDT と類似
  - IDT 設定前に GDT 設定を行う必要がある

bootpack.c

- struct
  - SEGMENT_DESCRIPTOR : GDT 上のそれぞれのセグメント情報
  - GATE_DESCRIPTOR : IDT 上のそれぞれの割り込み情報
- init (bootpack.c#L234 に記載)
  - 0x00270000 : GDT
  - 0x0026f800 : IDT
  - 0x00280000 : bootpack.hrb
  - 構造体への pointer に increment をかけると構造体のサイズ分だけ値が加算される（２を足せば, 構造体のサイズ x 2 加算）
  - segment 1 には全メモリ（4GB）に対する設定
  - segment 2 には bootpack.hrb (512KB) に対する設定
  - load_gdtr は GDTR へ値を設定する関数（naskfunc.nas#L80 に記載）
- 演算子の話
  - `|=`, `/=`
  - `>>`






