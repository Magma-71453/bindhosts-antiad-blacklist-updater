# bindhosts-antiad-blacklist-updater

为 [Magisk](https://topjohnwu.github.io/Magisk/) 模块 [bindhosts](https://github.com/bindhosts/bindhosts?tab=readme-ov-file) 提供的扩展脚本，实现自动化下载 [anti-ad](https://anti-ad.net/) 黑名单订阅并无缝集成到 bindhosts 配置中。脚本特别针对 anti-ad 这类“单域名”格式的订阅规则，解决了 bindhosts 官方订阅对 hosts 格式的严格限制，极大提升了规则更新的便捷性和自定义能力。

---

## 项目背景

bindhosts 是一款基于 Magisk 的广告过滤模块，允许用户通过 hosts 文件拦截广告。官方支持三种订阅规则（黑名单、白名单、重定向），但要求订阅内容必须为 `0.0.0.0 example.com` 之类的标准 hosts 格式。像 anti-ad 这类只包含单域名（如 `example.com`）的订阅，无法直接通过官方订阅机制导入。手动添加单条域名可以，但不便于批量规则管理和自动更新。

本项目脚本通过自动下载 anti-ad 订阅内容，并直接替换到 bindhosts 的配置文件，实现了对非标准 hosts 规则的便捷批量导入和自动更新，提升了模块的实用性和可玩性。

---

## 功能特色

- **自动联网检测**：脚本自动检测网络连通性，避免因断网造成规则更新失败。
- **模块状态校验**：自动检测 bindhosts 模块当前状态（是否已挂载、移除、禁用）。
- **黑名单批量替换**：下载 anti-ad 订阅内容，批量替换 bindhosts 的 blacklist.txt 文件。
- **完整性安全检测**：下载完成后校验文件是否完整，保障更新安全。
- **自动重载 hosts**：自动调用 bindhosts 的 action.sh 脚本，立即生效新规则。
- **兼容单域名格式**：支持 anti-ad 及类似单域名规则格式的批量导入。
- **结构清晰、注释详细**：易于二次开发和自定义扩展。

---

## 脚本使用方法

1. **前提条件**
    - 已安装 Magisk 并刷入 bindhosts 模块
    - 设备已 root 且具备 shell 或 Termux 运行环境
    - 建议提前备份 `/data/adb/bindhosts/blacklist.txt`

2. **部署脚本**
    - 将本脚本复制到 `/data/adb/modules/bindhosts/` 目录
    - 赋予可执行权限：
      ```sh
      chmod +x your_script_name.sh
      ```

3. **运行脚本**
    - 在终端执行：
      ```sh
      sh your_script_name.sh
      ```
    - 脚本会自动完成 anti-ad 黑名单的下载、替换和重载

4. **自定义订阅源**
    - 若需更换为其他规则源，只需修改脚本中的 `curl` 目标链接即可

---

#-------------"
