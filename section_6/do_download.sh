#!/usr/bin/env bash

removeQuotes () {
    tmp="${1%\"}"
    tmp="${tmp#\"}"
    echo $tmp
}

REQ_FILE=$1
COMIC_ROOT=$2

SCRIPT_PATH=$(pwd)

# 啟動 ssh proxy 放在背景
/proxy_launch.sh &

# 一一讀取欲爬取的漫畫名字列表
while read comic_name;
do
    # 建立儲存結果的資料夾
    comic_dir=$COMIC_ROOT/$comic_name
    mkdir -p $comic_dir

    # 取得漫畫首頁
    comic_home_url=$($SCRIPT_PATH/get_comic_home.py $comic_name)

    # 移除前後的 "
    comic_home_url=$(removeQuotes $comic_home_url)

    # 取得漫畫每一集的網址與對應集數 並初始化為陣列形式
    comic_episode_urls=( \
        $( \
            $SCRIPT_PATH/get_episode_urls.py $comic_home_url |\
            jq 'to_entries[] | [.key, .value] | @tsv' \
        ) \
    )
    declare -p comic_episode_urls > /dev/null

    # 給每一集網址與對應集數跑迴圈
    for epi_info in "${comic_episode_urls[@]}"
    do
        # 移除前後 "，並切割後建立 array
        # 注意： 使用 zsh 時 -a 參數要以 -A 替代
        epi_info=$(removeQuotes $epi_info)
        read -r -a epi_info <<< $(echo -e $epi_info)

        echo [Do crawl][${comic_name}][${epi_info[0]}][${epi_info[1]}]
        $SCRIPT_PATH/get_image.py ${epi_info[1]} > $comic_dir/${epi_info[0]}.json

        # 不然迴圈太快 Ctrl-c 關不掉
        sleep 1
    done
done < $REQ_FILE

killall -9 ssh
