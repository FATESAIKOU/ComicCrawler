# 簡單的漫畫爬蟲

## 本專案對應 Medium
* [關於我想看漫畫卻不想看廣告這檔事 (6) — 實體佈署心累，那你有試過 docker 嗎？](https://seaweed-programmer.medium.com/%E9%97%9C%E6%96%BC%E6%88%91%E6%83%B3%E7%9C%8B%E6%BC%AB%E7%95%AB%E5%8D%BB%E4%B8%8D%E6%83%B3%E7%9C%8B%E5%BB%A3%E5%91%8A%E9%80%99%E6%AA%94%E4%BA%8B-5-%E5%AF%A6%E9%AB%94%E4%BD%88%E7%BD%B2%E5%BF%83%E7%B4%AF-%E9%82%A3%E4%BD%A0%E6%9C%89%E8%A9%A6%E9%81%8E-docker-%E5%97%8E-6f25001ea3d1)

## 使用方式
本程式預期執行環境能使用 docker。

### 創建容器
創建容器前請先填入 `docker_build.sh` 中必要的各項參數。
* `PROXY_HOST`: 能 ssh 的機器的 ip 或者 hostname
* `PROXY_USER`: 用於登入 ssh 的 username
* `PROXY_PORT`: 目標機器開著 ssh 的 port
* `PROXY_PEM`: ssh-keygen 或者其他方法產生，用於 ssh 登入認證的 secret key

填入完成後執行：
```shell=
$ ./docker_build.sh
```

### 執行程式

#### 容器啟動
由於程式執行於容器內，執行程式前需要先啟動容器

```shell=
$ ./docker_run.sh [dir] [command]
```
* dir: 表示容器執行時要 mount 的外部資料夾的路徑，預設會 mount 到 `/project` 中
* command: 容器要執行的指令，可以是 shell 或者指令，通常使用 `bash`

#### 執行程式
執行程式前需先給定要爬取的漫畫名稱，並儲存於一個檔案內，如：

req.txt
```
食戟之靈
關于我轉生後成為史萊姆的那件事
```

然後以以下指令執行
```shell=
$ cd /project
$ ./do_download.sh [req.txt] [dir]
```
* req.txt: 包含要爬取漫畫列表的檔案
* dir: 爬取結果的輸出路徑

### 程式輸出
程式輸出資料截結構如下：
```
[dir]
- [漫畫名]
    - 01話.json
    - 02話.json
    - ...
```

