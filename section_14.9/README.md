# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (14.9) — 使用 Terraform & Serverless Framework 佈署漫畫爬蟲與閱讀器](https://seaweed-programmer.medium.com/%E9%97%9C%E6%96%BC%E6%88%91%E6%83%B3%E7%9C%8B%E6%BC%AB%E7%95%AB%E5%8D%BB%E4%B8%8D%E6%83%B3%E7%9C%8B%E5%BB%A3%E5%91%8A%E9%80%99%E6%AA%94%E4%BA%8B-14-9-%E4%BD%BF%E7%94%A8-terraform-serverless-framework-%E4%BD%88%E7%BD%B2%E6%BC%AB%E7%95%AB%E7%88%AC%E8%9F%B2%E8%88%87%E9%96%B1%E8%AE%80%E5%99%A8-a0a858b8977d)

## 部署前需先完成 Terraform 設定檔(crawler/env/terraform.tfvars, 參考 crawler/env/terraform.tfvars.sample)

-   使用 IAM 建立一個有足夠權限的 User (可以暫時用 Admin) - [tutorial](https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-admin-user.html)
-   複製上一步建立 User 取得的 `aws_access_key_id` 與 `aws_secret_access_key` 並更新到 terraform.tfvars 的對應欄位。
-   `key_name` 填入要使用的 `key_pair` 名。
-   `private_key_path` 填入下載下來的 pem 檔案位置。
-   `db_username` 資料庫使用者
-   `db_password` 上述資料庫使用者的密碼
-   `db_sql_path` 初始化資料庫用的 `.sql` 檔案路徑
-   `proxy_user` 登入跳板 server 的使用者名
-   `proxy_pem_path` 登入跳板時的認證用 key(pem)
-   `proxy_host` 跳板 server 路徑
-   `proxy_port` 跳板 server port(ssh)

## 部署工具安裝與初始化

### Terraform

```shell=
$ cd crawler/env
$ terraform init
```

### Serverless Framework

```shell=
$ cd reader
$ npm install -g serverless
$ sls plugin install -n serverless-python-requirements
$ sls plugin install -n serverless-dotenv-plugin
$ sls plugin install -n serverless-wsgi
```

## 部署

```shell=
$ ./deploy_all.sh
```

然後就完成了(又撒花)
