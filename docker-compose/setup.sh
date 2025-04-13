#!/bin/sh

# ==================
# == Env settings ==
# ==================

# 安装 Alpine 必需依赖
apk update
apk add --no-cache bash gcompat coreutils iproute2 sed wget docker docker-compose openssl

# check operating system
# 修改为 POSIX 兼容语法
if [ "$(uname)" = "Darwin" ]; then
    SED_COMMAND="sed -i ''"
else
    SED_COMMAND="sed -i"
fi

# ======================
# == Process the args ==
# ======================
[...保持参数解析部分不变...]

#######################
## Helper Functions ##
#######################

# 修改所有 [[ 为 [ 并调整语法
show_message() {
    [...保持原有结构，替换所有 [[ 为 [ ...]
}

download_file() {
    [...保持原有结构不变...]
}

print_centered() {
    [...删除数组声明，改为直接使用颜色代码...]
    # 修改颜色定义方式
    local color_reset="\e[0m"
    case "$color" in
        red) color_code="\e[31m" ;;
        green) color_code="\e[32m" ;;
        yellow) color_code="\e[33m" ;;
        blue) color_code="\e[34m" ;;
        *) color_code="" ;;
    esac
    printf "%*s%s%s%s\n" $padding "" "$color_code" "$text" "$color_reset"
}

ask() {
    [...保持原有结构，替换 read -p 为 POSIX 兼容方式...]
    printf "%s [%s %s]: " "$prompt" "$description" "$default"
    read result
}

####################
## Main Process ##
####################

# ===============
# == Variables ==
# ===============
[...保持变量声明不变，但移除数组...]
# 修改数组为空格分隔字符串
SUB_DIR="docker-compose/local"
FILES="docker-compose.yml init_data.json searxng-settings.yml"
ENV_EXAMPLES=".env.zh-CN.example .env.example"

[...后续代码需要调整数组引用为位置参数...]

section_download_files(){
    # 修改数组引用
    for file in $FILES; do
        download_file "$SOURCE_URL/$SUB_DIR/$file" "$file"
    done
    
    # 根据语言下载对应示例文件
    if [ "$LANGUAGE" = "zh_CN" ]; then
        download_file "$SOURCE_URL/$SUB_DIR/.env.zh-CN.example" ".env"
    else
        download_file "$SOURCE_URL/$SUB_DIR/.env.example" ".env"
    fi
}

section_configurate_host() {
    # 修改所有 [[ 为 [ 并调整语法
    DEPLOY_MODE=$ask_result
    if [ "$DEPLOY_MODE" = "2" ]; then
        HOST="localhost:3210"
        LOBE_HOST="$HOST"
        return 0
    fi

    # 修改条件判断
    if [ "$DEPLOY_MODE" = "0" ]; then
        [...保持逻辑，替换 [[ 为 [ ...]
    fi
    
    # 获取 IP 地址的 Alpine 兼容方式
    if [ -z "$HOST" ]; then
        HOST=$(ip -o -4 addr show scope global | awk '{print $4}' | cut -d/ -f1 | head -n1)
        # 私有 IP 检测逻辑
        if [ "$DEPLOY_MODE" = "1" ]; then
            case "$HOST" in
                192.168.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*|10.*)
                    echo $(show_message "tips_private_ip_detected")
                ;;
            esac
        fi
    fi

    [...后续 case 语句保持不变...]
}

# 修改部署模式判断逻辑
show_message "ask_deploy_mode"
ask "(0,1,2)" "2"
if [ "$ask_result" = "0" ] || [ "$ask_result" = "1" ] || [ "$ask_result" = "2" ]; then
    section_configurate_host
else
    [...错误处理保持不变...]
fi

[...后续其他函数按相同模式修改...]

section_display_configurated_report() {
    # 修改打印方式
    printf "\n%s\n" "$(show_message "security_secrect_regenerate_report")"
    printf "LobeChat: \n  - URL: %s://%s \n  - Username: user \n  - Password: %s \n" "$PROTOCOL" "$LOBE_HOST" "$CASDOOR_PASSWORD"
    [...保持其他输出逻辑...]
}
