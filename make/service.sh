#!/system/bin/sh

until_10 (){
    if [[ -z "$MMRL" ]] && ([[ -n "$KSU" ]] || [[ -n "$APATCH" ]]); then
	# 避免Apatch或KernelSu直接退出
	   sleep 10
	   exit
    else
       exit
    fi
}  
check_if (){
    cd $MODDIR
    if [ -f remove ]; then     
        echo "⚠️ 检测到模块被删除（remove 文件存在），脚本退出"
        until_10
    fi
    if [ -f disable ]; then 
        echo "⚠️ 检测到模块被禁用（disable 文件存在），脚本退出"
        until_10
    fi
    cd $script_dir
    echo "当前目录 $script_dir"
}    

echo "--------------------------------------------------------"

#初始化变量
#👇模块目录，用于检测模块启用状态
MODDIR="/data/adb/modules/bindhosts"
#👇配置目录，如bindhosts的黑名单、白名单相关文件配置存在于/data/adb/bindhosts
home="/data/adb/bindhosts"
#👇订阅更新到哪个文件，目前模块只写了更新blacklist.txt
list="blacklist.txt"
#👇订阅地址
update_ttp="https://anti-ad.net/domains.txt"
#综合以上原始变量，模块将：检测/data/adb/modules/bindhosts路径下是否存在disable和remove文件来动态运行或退出，然后再：读取订阅地址后更新至/data/adb/bindhosts/blacklist.txt
script_dir=$(dirname "$(realpath "$0")")
echo "脚本目录：$script_dir"
alias curl='$script_dir/curl-arm64'
#curl --version | grep -E "c-ares|Resolver"
#alias rename='$script_dir/rename'

echo "【1】检测网络连接..."
ping -c 1 anti-ad.net >/dev/null
if [ $? -eq 0 ]; then
    echo "✔ 网络正常，继续执行"
else
    echo "✘ 请检查网络是否开启后重试"
    until_10
fi

check_if

if grep active $MODDIR/module.prop >/dev/null; then
    echo "✔ hosts 已挂载，开始更新订阅并重载 hosts"
    echo "【2】正在更新..."
  #  curl -o $home/$list.new $update_ttp
    curl --resolve "anti-ad.net:443:114.114.114.114" -# -o "$home/$list.new" "$update_ttp"
        if [ $? -eq 0 ]; then
            echo "✔ 订阅下载完成"
            sleep 1
            echo "【3】应用新规则..."
            #在此脚本中rename没有mv好用，故mv
            mv "$home/$list.new" "$home/$list"
            #rename -v '.new' '' $home/$list.new
        else
            echo "✘ 下载失败，请检查网络或目标链接"
            echo "✘ 文件完整性未知，脚本退出"
            until_10
        fi
    echo "【4】重载模块..."
    #直接调用home/action，避免版本差异带来的未知问题
    sh $MODDIR/action.sh >/dev/null
    sleep 2
    if grep reset $MODDIR/module.prop >/dev/null; then
        sleep 2
        sh $MODDIR/action.sh >/dev/null
            if grep active $MODDIR/module.prop >/dev/null; then
                echo "🎉 订阅已更新并生效，享受更纯净的网络体验！"
            else
                echo "⚠️ 未检测到重载标记，订阅已更新但未强制重载"
            fi    
    else
        echo "⚠️ 错误，请检查订阅"
        until_10
    fi
else
    echo "✘ home 未挂载，脚本退出"
    until_10
fi
#检测订阅更新版本，只适配了截至2025年6月8日 | anti-ad，如有需要请自行适配，此功能非必须
if grep anti-AD $home/$list >/dev/null; then
    if grep VER= $home/$list >/dev/null; then
        echo "当前订阅版本…"
        grep VER= $home/$list
    fi
fi
echo "Done"        
echo "--------------------------------------------------------"

until_10