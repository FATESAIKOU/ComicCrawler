# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (7) — 一個簡單的漫畫閱讀器]()

## 使用方式

本程式預期執行環境可以執行 python3。

### 安裝程式相依

```shell=
$ pip3 install -r requirements.txt
```

### 設定 [section_6](https://github.com/FATESAIKOU/ComicCrawler/tree/master/section_6) 爬下來的資料夾當作資料庫

```shell=
$ export fsdb_root=/path/to/your/comicdb
```

### 啟動服務

```shell=
$ python3 app.py
```

於是就完成了，local 佈署總是這麼簡單快速。

## 閱讀

-   預設服務會開在 `http://localhost:5000`

-   效果圖

![](https://i.imgur.com/DWxChKT.jpg)
