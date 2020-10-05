# タイマ-2

### 文字列表示を簡単に (a)
[./13_day/harib10a/bootpack.c#L202](./13_day/harib10a/bootpack.c#L202)

```
void putfonts8_asc_sht(struct SHEET *sht, int x, int y, int c, int b, char *s, int l)
{
	boxfill8(sht->buf, sht->bxsize, b, x, y, x + l * 8 - 1, y + 15);
	putfonts8_asc(sht->buf, sht->bxsize, x, y, c, s);
	sheet_refresh(sht, x, y, x + l * 8, y + 16);
	return;
}
```

### FIFO バッファを見直す (b)
timer 用の fifo をひとつにする（timer_init へ渡す番号, すなわち timeout したときに fifo へ積む番号を変える）.

- diff : [./13_day/bootpack_a_b.diff](./13_day/bootpack_a_b.diff)

- timer に (その fifo で unique な) data 値をセット
  - [./13_day/harib10b/bootpack.c#L82](./13_day/harib10b/bootpack.c#L82)
  - timer_init : [./13_day/harib10a/timer.c#L46](./13_day/harib10a/timer.c#L46)
  - struct TIMER : [./13_day/harib10a/bootpack.h#L167](./13_day/harib10a/bootpack.h#L167)
- inthandler20 : [./13_day/harib10a/timer.c#L93](./13_day/harib10a/timer.c#L93)
  - fifo に data の値を積む

### 性能測定 (c) .. (f)
カウンタを回して比較（カウントが多いほうが良い）

- 10d --> 09d
- 10e --> 09e
- 10f --> 09f
- 10c --> 最新

３秒後からカウントを始める理由：
最初の数秒はPCの初期化にCPUが割かれるらしい

### FIFOバッファを見直す (g)
timer (timeout), mouse, keyboard を同一 fifo バッファで管理したい.
割り込みがあったときに fifo へ積む値をそれぞれ unique にすれば同一 fifo バッファが使える.

unsigned char では 8 bit を超える値を扱えないので int に変更する.
（struct FIFO8 を FIFO32 へ変更）

diff : [./13_day/harib10c_g.diff](./13_day/harib10c_g.diff)

著者環境では fifo バッファを減らすことで速度が 1.3 倍程度になる.

備考：c と同様に性能測定プログラムが走る

### 割り込み処理は短く (h)

- タイムアウトした割り込みを取り除きたい
- timerctl へ登録時の timer ずらし処理を減らしたい

diff : [./13_day/harib10g_h.diff](./13_day/harib10g_h.diff)

- 配列から LinkedList での管理に変更する.
- timer は常にソートされた状態に保つ.
  - 自分より timeout が遅い中で最も timeout が速い timer を next に入れる

### 番兵を使ってプログラムを短くしてみる (i)
４通りの場合分けを減らしたい.

timeout が来ることのないタイマ；番兵を用意する. リストには常に二つ以上の要素が入ることになり，かつ一番後ろには常に番兵が控えることになる.

diff : [./13_day/harib10h_i.diff](./13_day/harib10h_i.diff)

備考：VM の上の QEMU 環境だがカウントは大体 70M 回くらいになる



