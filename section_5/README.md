# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (5) — Selenium 實戰（下）](https://seaweed-programmer.medium.com/%E9%97%9C%E6%96%BC%E6%88%91%E6%83%B3%E7%9C%8B%E6%BC%AB%E7%95%AB%E5%8D%BB%E4%B8%8D%E6%83%B3%E7%9C%8B%E5%BB%A3%E5%91%8A%E9%80%99%E6%AA%94%E4%BA%8B-4-selenium%E5%AF%A6%E6%88%B0-%E4%B8%8B-eed72efa4de0)

## 系統需求

本程式預期執行環境能使用 docker。

-   最好是 Linux

## 使用方法

### 環境建置與執行

```shell=
$ ./docker_build.sh
$ ./docker_run.sh
```

### 建立跳板(IP 在港澳台就不用)

```shell=
$ ssh -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    -Nf -D8079 \
    -p [ssh_port] \
    -4 [username]@[host] \
    -i [private_key_file]
```

-   `ssh_port`: ssh 的 port
-   `username`: 登入 ssh 的帳號名
-   `host`: ssh 機器位置
-   `private_key_file`: 用於免登入的私鑰(沒有這個就把 -i 刪掉，單純打密碼也行)

PS: `-4` 是由於 docker 內部基本使用 ipv6 通訊，這樣在與 ipv4 的機器建立 tunnel 時會失敗，所以這裡強制指定 ipv4(`-4`)。

### 實際爬取

```shell=
root@xxxxxxxxxxxx:/# cd /project
root@xxxxxxxxxxxx:/# ./get_image.py 'https://comicabc.com/online/new-13313.html?ch=85'
```

網址的部份可以自由替換成其他漫畫集數的網址。
