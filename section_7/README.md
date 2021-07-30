# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (7) — 一個簡單的漫畫閱讀器](https://seaweed-programmer.medium.com/%E9%97%9C%E6%96%BC%E6%88%91%E6%83%B3%E7%9C%8B%E6%BC%AB%E7%95%AB%E5%8D%BB%E4%B8%8D%E6%83%B3%E7%9C%8B%E5%BB%A3%E5%91%8A%E9%80%99%E6%AA%94%E4%BA%8B-7-%E4%B8%80%E5%80%8B%E7%B0%A1%E5%96%AE%E7%9A%84%E6%BC%AB%E7%95%AB%E9%96%B1%E8%AE%80%E5%99%A8-2102638b8c25)

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
