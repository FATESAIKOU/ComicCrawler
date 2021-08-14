# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (9) — AWS 佈署基本網頁](https://seaweed-programmer.medium.com/%E9%97%9C%E6%96%BC%E6%88%91%E6%83%B3%E7%9C%8B%E6%BC%AB%E7%95%AB%E5%8D%BB%E4%B8%8D%E6%83%B3%E7%9C%8B%E5%BB%A3%E5%91%8A%E9%80%99%E6%AA%94%E4%BA%8B-9-aws-%E4%BD%88%E7%BD%B2%E5%9F%BA%E6%9C%AC%E7%B6%B2%E9%A0%81-1b7d7ce7361d)

## 手動佈署

-   參考本篇對應 Medium
-   注意：架設前需要把 [section_6](https://github.com/FATESAIKOU/ComicCrawler/tree/master/section_6) 爬下來的資料夾複製到 EC2 之內，並且設定環境變數 `fsdb_root`

## 自動佈署

### 環境準備

安裝 Terraform - [tutorial](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### 更新 Terraform 設定檔(env/terraform.tfvars)

-   使用 IAM 建立一個有足夠權限的 User (可以暫時用 Admin) - [tutorial](https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-admin-user.html)
-   複製上一步建立 User 取得的 `aws_access_key_id` 與 `aws_secret_access_key` 並更新到 terraform.tfvars 的對應欄位。
-   `key_name` 填入要使用的 `key_pair` 名。
-   `private_key_path` 填入下載下來的 pem 檔案位置。
-   `comicdb_dir` 填入要使用的漫畫資料夾路徑。（將會被複製到 EC2 內部）
-   `bucket_name` 放 index.html 的 bucket 名，隨意，不重複即可。

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
