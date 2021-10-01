# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (15) — ]()

## 部署前需先完成 Terraform 設定檔(terraform.tfvars, 參考 terraform.tfvars.sample)

-   使用 IAM 建立一個有足夠權限的 User (可以暫時用 Admin) - [tutorial](https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-admin-user.html)
-   複製上一步建立 User 取得的 `aws_access_key_id` 與 `aws_secret_access_key` 並更新到 terraform.tfvars 的對應欄位。

## 部署

```shell=
$ terraform init
$ terraform plan -out dev.tfplan && terraform apply dev.tfplan
```

## 移除

```shell=
$ terraform destroy
```
