# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   []()

## 部署前需先完成 Terraform 設定檔(crawler/env/terraform.tfvars, 參考 crawler/env/terraform.tfvars.sample)

-   使用 IAM 建立一個有足夠權限的 User (可以暫時用 Admin) - [tutorial](https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-admin-user.html)
-   複製上一步建立 User 取得的 `aws_access_key_id` 與 `aws_secret_access_key` 並更新到 terraform.tfvars 的對應欄位。
-   `db_username` 資料庫使用者
-   `db_password` 上述資料庫使用者的密碼
-   `db_sql_path` 初始化資料庫用的 `.sql` 檔案路徑
-   `proxy_user` 登入跳板 server 的使用者名
-   `proxy_host` 跳板 server 路徑
-   `proxy_port` 跳板 server port(ssh)
-   `proxy_pem` 登入跳板時的認證用 key(pem)
