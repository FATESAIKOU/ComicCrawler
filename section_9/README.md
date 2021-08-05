# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (9) — AWS 佈署基本網頁]()

## 手動佈署

-   參考本篇對應 Medium
-   注意：架設前需要把 [section_6](https://github.com/FATESAIKOU/ComicCrawler/tree/master/section_6) 爬下來的資料夾複製到 EC2 之內，並且設定環境變數 `fsdb_root`

## 自動佈署

### 環境準備

安裝 Terraform - [tutorial](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### 更新 Terraform 設定檔(env/terraform.tfvars)

-   使用 IAM 建立一個有足夠權限的 User (可以暫時用 Admin) - [tutorial](https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-admin-user.html)
-   複製上一步建立 User 取得的 `aws_access_key` 與 `aws_secret_key` 並更新到 terraform.tfvars 的對應欄位。
-   在 terraform.tfvars 的 `key_name` 填入要使用的 `key_pair` 名。
-   在 terraform.tfvars 的 `comic_db_path` 填入要使用的漫畫資料夾路徑。（將會被複製到 EC2 內部）

### 佈署

```shell=
$ cd env
$ terraform init
$ terraform plan -out dev.tfplan && terraform apply dev.tfplan
```

### 移除整個環境

```shell=
$ terraform destroy
```
