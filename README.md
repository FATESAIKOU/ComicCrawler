# 簡單的漫畫爬蟲

## 聲明
本專案為[此系列教學](https://seaweed-programmer.medium.com/%E9%97%9C%E6%96%BC%E6%88%91%E6%83%B3%E7%9C%8B%E6%BC%AB%E7%95%AB%E5%8D%BB%E4%B8%8D%E6%83%B3%E7%9C%8B%E5%BB%A3%E5%91%8A%E9%80%99%E9%BB%A8%E4%BA%8B-%E5%89%8D%E8%A8%80-744ca8f3a679)用的範例程式碼，為一個拿來學習爬蟲與佈署技術的簡單漫畫爬蟲，除學術用途外請勿用於任何營利或者會影響其他網站服務提供商的行為。若因濫用而造成任何法律問題，則本人概不負責。

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
dir: 表示容器執行時要 mount 的外部資料夾的路徑，預設會 mount 到 `/project` 中
command: 容器要執行的指令，可以是 shell 或者指令，通常使用 `bash`

#### 執行程式
執行程式前需先給定要爬取的漫畫名稱，並儲存於一個檔案內，如：

req.json
```
食戟之靈
關于我轉生後成為史萊姆的那件事
```

然後以以下指令執行
```shell=
$ cd /project
$ ./do_download.sh [req.json] [dir]
```
req.json: 包含要爬取漫畫列表的檔案
dir: 爬取結果的輸出路徑

### 程式輸出
程式輸出資料截結構如下：
```
[dir]
- [漫畫名]
    - 01話.json
    - 02話.json
    - ...
```

