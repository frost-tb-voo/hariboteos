# ウィンドウ移動の高速化
QEMU で十分な速度が出てしまうので違いが体感できなかった..

### ウィンドウ移動を速く（1） 23a
p.539

sheet_refreshmap 内の三重 for 中の if を減らす.
全シートの透明領域の判定 --> シートごとに透明領域の存在有無を判定へ変更.

- sheet_slide : p.199 あたりを読む
- sheet_refreshmap : どの画素がどのシートのものかを管理する p.226
  - col_inv: 透明色番号

[./26_day/harib22j_23a.diff](./26_day/harib22j_23a.diff)

```diff
+++ ./26_day/harib23a/Makefile  2006-01-29 23:58:12.000000000 +0900
+++ ./26_day/harib23a/sheet.c   2005-11-23 14:38:24.000000000 +0900
```

### ウィンドウ移動を速く（2） 23b
p.541

- sheet_refreshmap 内でまとめて４倍の sid (sheet_id) を書き込むことで４倍速にする.
- 「透明色なし専用の高速版（4バイト型）」が使われるよう bootpack.c 内でウィンドウの座標（初期位置、移動先）も４の倍数となるようにする.
- 変数 mmy2 がないのは縦座標は画素インデックス的に気にしなくてよいから？

[./26_day/harib23a_23b.diff](./26_day/harib23a_23b.diff)

```diff
+++ ./26_day/harib23b/bootpack.c        2005-11-23 18:16:44.000000000 +0900
+++ ./26_day/harib23b/console.c 2006-03-31 23:17:48.000000000 +0900
+++ ./26_day/harib23b/sheet.c   2005-11-23 19:56:40.000000000 +0900
```

### ウィンドウ移動を速く（3） 23c
p.545 (562)

sheet_refreshsub も４倍速にする.

- sheet_refreshsub : シート中の画素を実際に書き込む
  - vram 書き込み先
  - buf 書き込み元
  - map 画素ごとの sheet_id

[./26_day/harib23b_23c.diff](./26_day/harib23b_23c.diff)

- `p[i] == sid4` のときは int で処理
- そうでなければ byte で処理

```diff
+++ ./26_day/harib23c/sheet.c   2005-11-23 21:11:04.000000000 +0900
```

### ウィンドウ移動を速く（4） 23d
p.547

- bootpack.c 内. マウスの移動イベントを受け取っても FIFO buffer が空になるまでは描画しないよう修正.
- 描画前の座標を (new_mx, new_my) として記憶する.
- 特別な値として -1 と 0x7fffffff を使用

```
io_sti();
sheet_slide(...);
```

上がマウスもしくはウィンドウの描画処理.

[./26_day/harib23c_23d.diff](./26_day/harib23c_23d.diff)

```diff
+++ ./26_day/harib23d/bootpack.c        2005-11-25 22:21:06.000000000 +0900
```

### 最初のコンソールを１つに 23e
p.549

- 最初のコンソールを一つにして, Shift+F2 を押すと後からコンソールを追加できるようにする.
- 一連の処理を関数 open_console へ抜き出してキーが押されたら呼び出せるようにする.

[./26_day/harib23d_23e.diff](./26_day/harib23d_23e.diff)

```diff
+++ ./26_day/harib23e/bootpack.c        2005-11-25 22:49:28.000000000 +0900
```

### コンソールをもっとたくさん 23f
p.552

- コンソールの最大数 2 の制限をなくす.
- sht_cons[] はどこから呼ばれないので削除.
- key_win: フォーカス中のウィンドウを保持

[./26_day/harib23e_23f.diff](./26_day/harib23e_23f.diff)

```diff
+++ ./26_day/harib23f/bootpack.c        2005-11-26 00:54:22.000000000 +0900
```

### コンソールを閉じる（1） 23g
p.554

コンソールへ exit を実装する.

- TASK struct へ free のためにスタックの番地を記録する cons_stack を追加
- close_constask, close_console を実装
- cons_runcmd, cmd_exit を実装
  - 各コンソールはウィンドウを持たない task_a （HariMain そのものなので OS のメインプロセス？）から自身を閉じてもらうようにする
  - task_a への命令は fifo を通して実施 (diff の L28, L159)
  - 命令後はひたすら sleep

[./26_day/harib23f_23g.diff](./26_day/harib23f_23g.diff)

```diff
+++ ./26_day/harib23g/bootpack.c        2005-11-30 01:14:56.000000000 +0900
+++ ./26_day/harib23g/bootpack.h        2006-04-01 00:51:32.000000000 +0900
+++ ./26_day/harib23g/console.c 2006-04-01 01:00:50.000000000 +0900
```

### コンソールを閉じる（2） 23h

マウスでコンソールを閉じる.

- X ボタン押下の検知は task_a で実施, 押されたらコンソールの fifo へ命令データ（4）を送信

[./26_day/harib23g_23h.diff](./26_day/harib23g_23h.diff)

```diff
+++ ./26_day/harib23h/bootpack.c        2005-11-30 16:14:28.000000000 +0900
+++ ./26_day/harib23h/console.c 2006-04-01 03:20:36.000000000 +0900
```

### start コマンド 23i
p.560

新しいコンソールを開いてその上でアプリを起動するコマンドを実装する.

- cmd_start として実装.
- 新しいコンソールへ直接 fifo を通して文字列を打ち込んでいる

[./26_day/harib23h_23i.diff](./26_day/harib23h_23i.diff)

```diff
+++ ./26_day/harib23i/bootpack.c        2005-11-30 20:06:56.000000000 +0900
+++ ./26_day/harib23i/bootpack.h        2006-04-01 20:12:18.000000000 +0900
+++ ./26_day/harib23i/console.c 2006-04-01 23:39:16.000000000 +0900
```

### ncst コマンド 23j
p.562

コンソールなし版（no console start）を実装する.

- コンソールの表示そのものをなくしてコンソールへの表示も無視する
- コンソールがない場合はシート番号は０とする
  - console.c へシート番号０用の例外処理をひたすら追加していく
  - あぷりが終わったらすぐ閉じる. close_constask を利用
- bootpack.c の open_console の処理の一部を open_constask として分離

[./26_day/harib23i_23j.diff](./26_day/harib23i_23j.diff)

```diff
+++ ./26_day/harib23j/bootpack.c        2005-12-01 18:11:06.000000000 +0900
+++ ./26_day/harib23j/bootpack.h        2006-04-02 01:37:34.000000000 +0900
+++ ./26_day/harib23j/console.c 2006-04-02 01:38:42.000000000 +0900
```
