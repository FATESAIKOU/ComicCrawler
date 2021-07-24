# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (6) — 實體佈署心累，那你有試過 docker 嗎？](https://seaweed-programmer.medium.com/%E9%97%9C%E6%96%BC%E6%88%91%E6%83%B3%E7%9C%8B%E6%BC%AB%E7%95%AB%E5%8D%BB%E4%B8%8D%E6%83%B3%E7%9C%8B%E5%BB%A3%E5%91%8A%E9%80%99%E6%AA%94%E4%BA%8B-5-%E5%AF%A6%E9%AB%94%E4%BD%88%E7%BD%B2%E5%BF%83%E7%B4%AF-%E9%82%A3%E4%BD%A0%E6%9C%89%E8%A9%A6%E9%81%8E-docker-%E5%97%8E-6f25001ea3d1)

## 系統需求

本程式預期執行環境能使用 python3, pip。

-   最好是 Linux

## 使用方法

### 環境建置

```shell=
$ pip3 install -r requirements.txt
```

### 爬取漫畫首頁網址

```shell=
$ ./get_comic_home.py '關于我轉生後成為史萊姆的那件事' <--- 隨意放入想看的漫畫名
```

### 爬取所有漫畫集數網址

```shell=
$ ./get_episode_home.py 'https://comicbus.com/html/13313.html' <--- 將 get_comic_home.py 的輸出填入
```

### 簡單組合技

```shell=
$ ./get_episode_home.py $(./get_comic_home.py '關于我轉生後成為史萊姆的那件事')
```
