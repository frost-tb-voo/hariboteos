# メモリ管理

備考：何度も `make clean` するとたまに img がおかしくなるので `make clean run` する.

### ソースの整理 (a)
keyboard.c と mouse.c を bootpack.c から分離.

Makefile 変更点.

```diff
 OBJS_BOOTPACK = bootpack.obj naskfunc.obj hankaku.obj graphic.obj dsctbl.obj \
-		int.obj fifo.obj
+		int.obj fifo.obj keyboard.obj mouse.obj
```

### メモリ容量チェック (b)

- memory cache をオフにする
  - 386 には cpu に memory cache が載っていなかった
  - 諸々の機能追加により 486 では６倍ほど高速になったらしい
- memtest 関数を c で自作
  - [09_day\harib06b\bootpack.c](09_day\harib06b\bootpack.c)#L97
  - eflags check と CR0 register への書き込み
- memtest_sub (#L130)
  - ４バイト分ずつ番地を増やしながら
  - 各番地に対して適当な値 (unsigned int) `0xaa55aa55`を書き込んでみて，反転させてから比較
  - 比較に失敗したらその時の番地を呼び出し元に返す
  - しれっと goto が使われている..
- ４バイト分ずつだと遅いので 0x1000 単位でチェックする
  - それぞれのチェックは末尾の４バイトに対してのみ行う
- QEMU 環境だと 32MiB になるはず
  - 表示すると 3072 MiB となり失敗

### メモリ容量チェック (c)

- コンパイル後のアセンブリを見ると XOR 命令が消えている
  - C compiler の最適化によるもの
- memtest 関数をアセンブリで書き直す
  - [09_day\harib06c\naskfunc.nas](09_day\harib06c\naskfunc.nas)#L153

### メモリ管理に挑戦 (d)

- メモリの確保と解放
  - アプリケーションに割り振るメモリ領域を管理したい
  - 各番地の使用状態，空き状態を知りたい
- 各番地に対して bool を振って boolean table で管理する方式
  - windows の floppy disk の管理に類似する方式が使われている
- 「aa 番地から bb バイトが空いている」で管理する方式
  - 確保するときは，空き情報から必要な分だけ削り出して記録する
  - 解放するときは，管理テーブル上の地続きの空き番地をまとめてしまう
  - この方法はメモリを使わず速いが, 飛び地ができる，管理が複雑になるという問題がある
  - でフラグ前のディスクっぽい
- alloc と free の実装
  - [09_day\harib06d\bootpack.c](09_day\harib06d\bootpack.c)
  - free のほうは場合分けがめんどくさい
  - 今回は，飛び地だらけになってメモリが足りなくなっても特に対処はしない
  - 0x003c0000 番地以降をメモリ管理に使用する

