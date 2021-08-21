# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (11) -  爬蟲 ✕  Msyql](https://seaweed-programmer.medium.com/%E9%97%9C%E6%96%BC%E6%88%91%E6%83%B3%E7%9C%8B%E6%BC%AB%E7%95%AB%E5%8D%BB%E4%B8%8D%E6%83%B3%E7%9C%8B%E5%BB%A3%E5%91%8A%E9%80%99%E6%AA%94%E4%BA%8B-11-%E7%88%AC%E8%9F%B2-msyql-637a68de94dd)

## 使用前準備 - 安裝相依套件

```shell=
$ pip3 install -r requirements.txt
```

## 啟動資料庫

記得先安裝 `docker` 與 `docker-compose`

```shell=
$ docker-compose up -d # 等個幾秒 服務開好後
$ cat create_table.sql | mysql -u db_user -p -h 127.0.0.1
Enter password: # 輸入 db_pass 後 Enter
```

## 加入要下載的漫畫

1. 打開瀏覽器前往 http://127.0.0.1:8081
2. 用以下資訊登入
    - 伺服器: db
    - 使用者名稱: db_user
    - 密碼: db_pass
3. 於 comicdb 的 comics 內新增一列，需填入漫畫名至 `comic_name`

## 啟動漫畫閱讀器

-   需先啟動資料庫

```shell=
$ export db_host="127.0.0.1"
$ export db_port="3306"
$ export db_user="db_user"
$ export db_pass="db_pass"
$ python3 src/api.py
```

## 執行漫畫爬蟲

-   需先啟動資料庫
-   行為上，`crawler_main.py` 會根據 `comics` 表的漫畫順序一一爬取，直到一個漫畫爬完後才會換另外一個漫畫爬。

```shell=
$ export db_host="127.0.0.1"
$ export db_port="3306"
$ export db_user="db_user"
$ export db_pass="db_pass"
$ python3 crawler_main.py [num] # num 為要下載的最大集數
```
