# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (1)— 靜態網頁爬蟲](https://seaweed-programmer.medium.com/%E9%97%9C%E6%96%BC%E6%88%91%E6%83%B3%E7%9C%8B%E6%BC%AB%E7%95%AB%E5%8D%BB%E4%B8%8D%E6%83%B3%E7%9C%8B%E5%BB%A3%E5%91%8A%E9%80%99%E9%BB%A8%E4%BA%8B-1-%E9%9D%9C%E6%85%8B%E7%B6%B2%E9%A0%81%E7%88%AC%E8%9F%B2-f89d39a8b2f5)

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
