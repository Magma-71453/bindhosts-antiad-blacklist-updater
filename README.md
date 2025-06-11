# bindhosts-antiad-blacklist-updater

为 [Magisk](https://topjohnwu.github.io/Magisk/) 模块 [bindhosts](https://github.com/bindhosts/bindhosts?tab=readme-ov-file) 提供的扩展脚本，实现自动化下载 [example.com]格式订阅 并无缝集成到 bindhosts 配置中。
---

## 项目背景

bindhosts 是一款基于 Magisk 的广告过滤模块，允许用户通过 hosts 文件拦截广告。官方支持三种订阅规则（黑名单、白名单、重定向），但要求订阅内容必须为 `0.0.0.0 example.com` 之类的标准 hosts 格式。像 anti-ad 这类只包含单域名（如 `example.com`）的订阅，无法直接通过官方订阅机制导入。手动添加单条域名可以，但不便于批量规则管理和自动更新。

本项目脚本通过自动下载 [anti-ad](https://anti-ad.net/domains.txt) 订阅内容，并直接替换到 bindhosts 的配置文件，实现了对非标准 hosts 规则的便捷批量导入和自动更新，提升了模块的实用性和可玩性。

---

## 功能特色

- **自动联网检测**：脚本自动检测网络连通性，避免因断网造成规则更新失败。
- **模块状态校验**：自动检测 bindhosts 模块当前状态（是否已挂载、移除、禁用）。
- **黑名单批量替换**：下载 anti-ad 订阅内容，批量替换 bindhosts 的 blacklist.txt 文件。
- **自动重载 hosts**：自动调用 bindhosts 的 action.sh 脚本，立即生效新规则。
- **兼容单域名格式**：支持 anti-ad 及类似单域名规则格式的批量导入。
- **结构清晰、注释详细**：易于二次开发和自定义扩展。

---

## 脚本使用方法

1. **前提条件**
    - 已刷入 bindhosts 模块
    - 设备已 root 且具备 shell 
    - 建议提前备份 `/data/adb/bindhosts/blacklist.txt`

2. **安装模块**
    - 将本模块通过Magisk/Apatch/KernelSu等任意方式安装到手机
    - 重启

3. **运行脚本**
    - 在管理器中执行action，直到脚本提示完成
      
    - 脚本会自动完成 anti-ad 订阅的下载、替换和重载

4. **自定义订阅源**
    - 若需更换为其他规则源，只需修改脚本中的 `curl` 目标链接即可

## 常见问题

- **Q: 支持哪些订阅格式？**  
  **A:** 脚本主要针对 anti-ad 的单域名格式（如 `example.com`），如需支持其他格式可自行适配。

- **Q: 兼容其他hosts模块吗？**  
  **A:** 模块中可定义三个路径
  
#👇模块目录，用于检测模块启用状态
MODDIR="/data/adb/modules/bindhosts"

#👇配置目录，如bindhosts的黑名单、白名单相关文件配置存在于/data/adb/bindhosts
home="/data/adb/bindhosts"

#👇订阅更新到哪个文件，目前模块只写了更新blacklist.txt
list="blacklist.txt"

综合以上原始变量，模块将：检测/data/adb/modules/bindhosts路径下是否存在disable和remove文件来动态运行或退出，然后再：把订阅更新至/data/adb/bindhosts/blacklist.txt
你可以结合实际使用的模块的部分差异进行修改

- **Q: 如何恢复默认规则？**  
  **A:** 备份原始 `blacklist.txt`，如遇异常直接恢复即可。

## 贡献方式

欢迎提交 Issue、Pull Request 或提出建议！  
如果你有改进想法、Bug 修复、适配其他规则源等需求，欢迎 Fork 本项目并二次开发。  
贡献代码请遵循 [GPL v3 许可协议](#license)。

---

## 致谢

- [bindhosts](https://github.com/bindhosts/bindhosts?tab=readme-ov-file) - 高效的 Magisk 广告过滤模块
- [anti-ad](https://anti-ad.net/) - 优质的去广告规则订阅源
- Magisk及所有开源社区贡献者
