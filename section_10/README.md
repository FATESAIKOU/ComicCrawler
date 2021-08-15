# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (10) -  使用 AWS 佈署 Serverless 網頁]()

## 安裝相依套件

```shell=
$ npm install -g serverless
$ sls plugin install -n serverless-python-requirements
$ sls plugin install -n serverless-dotenv-plugin
$ sls plugin install -n serverless-s3-sync
$ sls plugin install -n serverless-wsgi
```

## 更新&建立設定檔

### 建立 IAM 使用者 & 初始化 aws 設定檔

-   使用 IAM 建立一個有足夠權限的 User (可以暫時用 Admin) - [tutorial](https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-admin-user.html)
-   複製上一步建立 User 取得的 `aws_access_key_id` 與 `aws_secret_access_key`。
-   設定 aws 登入用必要設定檔(如下)

```shell=
$ mkdir -p ~/.aws
$ cat > ~/.aws/credentials <<EOF
[default]
aws_access_key_id = [剛剛複製的 aws_access_key_id]
aws_secret_access_key [剛剛複製的 aws_secret_access_key]
EOF
```

### 建立 .env 設定檔(指定 bucket 名與漫畫資料庫的路徑)

```shell=
$ cat > .env <<EOF
bucket_name=[bucket 名，拿來放 html 與漫畫用，但不是隨意設定，詳見下]
fsdb_root=[上面 bucket 裏面放漫畫的路徑，例：comicdb/]
EOF
```

關於 `bucket_name` 需要特別注意，本部署程式實際上是使用 `serverless.yml` 中的 `service: ` 欄位值為參考後面接上 `-bucket` 作為要創建的 bucket 名字。因此 `.env` 中的 `bucket_name` 實際上也必須符合本規則，比如： `serverless.yml` 中寫有 `service: crawler-reader`，那麼 `.env` 中的 `bucket_name` 就必須是 `crawler-reader-bucket`。

另外，為避免 bucket 名稱(必須全網唯一)衝突導致部署失敗，部署前強烈建議更改 `serverless.yml` 的 `service:` 欄位。

### 修改 serverless.yml 中的 comicdb 位置

```yml=
custom:
    wsgi:
        app: api.app
    s3Sync:
        - bucketName: ${self:service}-bucket
          bucketPrefix: comicdb/
          localDir: /PATH/TO/YOUR/COMICDIR # <--- 這邊麻煩改掉
        - bucketName: ${self:service}-bucket
          localDir: ./frontend/
```

## 佈署

```shell=
$ export AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
$ sls deploy
```

## 移除整個環境

```shell=
$ export AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials
$ sls remove
```
