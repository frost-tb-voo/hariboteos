
# 1
- HariboteOS.zip をダウンロード
  - https://book.mynavi.jp/supportsite/detail/4839919844.html
- Bz Editor をダウンロード
  - https://github.com/devil-tamachan/binaryeditorbz/releases
  - Gitlab のアカウントを作るのが面倒だったので 1985 を利用
- img を作成
- qemu で起動
  - VMware workstation 15 player でも起動する

# 2
バイナリエディタは手間を無限大にかければ何でも書ける

# 3

- [NASM](https://ja.wikipedia.org/wiki/Netwide_Assembler)
  - intel x86 向けのアセンブラ
- を img へ変換するツール [nask](http://hrb.osask.jp/wiki/index.php?tools%2Fnask)
- [NASK からの解脱](https://seesaawiki.jp/w/yamaneko1144/d/1.NASK%B4%C4%B6%AD%A4%AB%A4%E9%A4%CE%B2%F2%C3%A6)
  - nask には NASM にはない独自文法があるらしい
  - GCC(CC,G++,LD,ASを含む), NASM, MAKE, QEMU があれば代替可能とのこと
  - １日目の内容はあまり関係ない

- DB, RESB, DW, DD 命令
- `0x1fe-$` ：現在位置から位置 0x1fe までの残りバイト数
- ブートセクタは 512 Bytes (0.5 KB)
  - ラストを 0x55 0xaa で〆る
- IPL; initial program loader
  - ブーツセクタ中に記述する初期プログラムを読み込むためのプログラム
- [MBR](https://ja.wikipedia.org/wiki/%E3%83%9E%E3%82%B9%E3%82%BF%E3%83%BC%E3%83%96%E3%83%BC%E3%83%88%E3%83%AC%E3%82%B3%E3%83%BC%E3%83%89)
  - １セクタを使用
  - PC/AT互換機だと共通らしい
  - IPL は先頭から 446 バイト目まで
  - ラストの２バイトはブートシグニチャと呼ばれる
- [GPT](https://ja.wikipedia.org/wiki/GUID%E3%83%91%E3%83%BC%E3%83%86%E3%82%A3%E3%82%B7%E3%83%A7%E3%83%B3%E3%83%86%E3%83%BC%E3%83%96%E3%83%AB)
  - 2TiB 以上の領域が管理できなかった MBR の置き換え
  - パーティションテーブルの領域を拡張することで 8ZiB まで管理できるようになった
  - 34セクタを使用
  - MBR と互換性がある
  - 各セクタを Logical Block Addressing (LBA) と呼んでおり 0 セクタ目に MBR の情報を書くことになっている
  - EFI をサポートしていない（BIOS によって読まれた）場合でも OS 側で読み込めるような工夫がされているらしい
