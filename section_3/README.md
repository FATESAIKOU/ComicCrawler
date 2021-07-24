# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (3) — Selenium/Chrome 爬蟲環境安裝](https://seaweed-programmer.medium.com/%E9%97%9C%E6%96%BC%E6%88%91%E6%83%B3%E7%9C%8B%E6%BC%AB%E7%95%AB%E5%8D%BB%E4%B8%8D%E6%83%B3%E7%9C%8B%E5%BB%A3%E5%91%8A%E9%80%99%E6%AA%94%E4%BA%8B-3-selenium-chrome-%E7%88%AC%E8%9F%B2%E7%92%B0%E5%A2%83%E5%AE%89%E8%A3%9D-5dabd8a99aac)

## 系統需求

本程式預期執行環境能使用 python3, pip, docker。

-   最好是 Linux

## 使用方法

### 本機版

```shell=
$ ./selenium_local_test.sh
```

### docker 版

```shell=
$ ./docker_build.sh
$ ./docker_run.sh
root@xxxxxxxxxxxx:/# cd /project
root@xxxxxxxxxxxx:/# ./selenium_docker_test.py
```

兩種方法都只要看到 `google_homepgae.png` 在當前的資料夾底下，就表示成功。
