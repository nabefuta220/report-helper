# report helper

## what's report helper?

markdownでの図・表のラベル付けや参考文献の貼り替えを支援するツールです。


## how to use

1. レポジトリをcloneする

    以下のコマンドでできます。

    ```bash
    git clone https://github.com/nabefuta220/report-helper
    ```

2. 権限を与える

    以下のコマンドでできます。

    ```bash
    chmod u+x report-helper.bash
    ```


3. パスを通す


    ~/.bash_profileに移動して、PATHにこのレポジトリをインストールしたパスを追加します

    例えば、`/home/hoge/fuga`にこのレポジトリを追加した場合、次のコマンドでできます。

    ```bash
    echo 'export PATH=/home/hoge/fuga/report-helper:$PATH' >> ~/.bash_profile
    ```

    また、次のコマンドで追加をすぐに反映することができます(もしくは再起動をしても構いません)

    ```bash
    source ~/.bash_profile
    ```

    



## features

1. リンクを貼り替え

    図1-3-4 などの図などの後ろに数字とハイフンで複数個つながっているリンクを図13などの通し番号に付け替えます。

    その時、同一のリンクは同じ番号に付け変わります。

2. リンクの整合性チェック

    本文中に同じラベルで提示してある資料が複数ないか、また、本文中で参照しているラベルが提示されているかを調べます。

3. 次につけられるリンクを確認する

    ラベルが重複しないようなリンクを調べることができます。

4. 参考文献の貼り替え

    本文中に2重の大かっこ([[hoge]]の形式)で書かれたものを末尾にまとめ、本文中は通し番号を振ります。

    同一の文字列は同じ番号につけ変わります。