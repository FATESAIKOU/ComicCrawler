# 簡單的漫畫爬蟲

## 本專案對應 Medium

-   [關於我想看漫畫卻不想看廣告這檔事 (17) — 使用 github actions 自動測試程式碼](https://seaweed-programmer.medium.com/%E9%97%9C%E6%96%BC%E6%88%91%E6%83%B3%E7%9C%8B%E6%BC%AB%E7%95%AB%E5%8D%BB%E4%B8%8D%E6%83%B3%E7%9C%8B%E5%BB%A3%E5%91%8A%E9%80%99%E6%AA%94%E4%BA%8B-17-%E4%BD%BF%E7%94%A8-github-actions-%E8%87%AA%E5%8B%95%E6%B8%AC%E8%A9%A6%E7%A8%8B%E5%BC%8F%E7%A2%BC-c123ed058b87)

## 特別注意

-   本篇的 github actions 檔案位置在 `ComicCrawler/.github/workflows/section_17_crawlertest.yml`

## 執行 github actions 前請先確保有以下 secrets 變數

-   `PROXY_USER` 登入跳板的 user
-   `PROXY_PEM` 登入跳板時的認證用 key(pem)，不是檔案路徑，是檔案內容
-   `PROXY_HOST` 跳板 server 路徑
-   `PROXY_PORT` 跳板 server port(ssh)

### github 上的 secrets 設定方法

-   [官方說明](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-an-environment)

### 使用 nektos/act 時的 secrets 設定方法

-   [Github repo](https://github.com/nektos/act)
-   準備一個 .secrets 內含多行 `KEY="VAL"` 形式的變數設定並用 --secret-file 指定該檔案
-   或者使用 -s KEY="xxxx" 直接在指令列指定
    -   PEM 檔案內容太長無法用 .secrets 時建議用這個方法，寫法為 -s PEM="$(cat your.pem)"

## 執行

### github

-   fork 到自己的 repo & 設定好 secrets 變數之後到 Actions 分頁
-   點擊 Workflows 下的 Section 17 crawler test 找到 Run workflow 下拉按鈕
-   看到綠色的 Run workflow 點下去就對了

### nektos/act

-   先移動到上層資料夾(看得到 .github 的專案根目錄)
-   執行 `act -j test-crawler -s PEM="$(cat your.pem)" --secret-file your.secrets`
