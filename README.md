# v2rayN-7.15.6-for-Ubuntu18.04
针对Ubuntu18.04的部分功能修复，改工程在[v2rayN](https://github.com/2dust/v2rayN)的7.15.6的基础上修改。

1. Linux sudo / TUN 密码输入修复

提交：4162214 feat(core): 添加Linux sudo密码验证功能

变更点：

- 允许 sudo 密码为空字符串或空白字符，不再把空密码当成取消输入。
- SudoPasswordInputView 不再拒绝空输入，txtPassword.Text ?? string.Empty 作为密码值。
- 调用 sudo -S 校验时，给标准输入追加换行符，确保 sudo 能正确读取密码。
- CoreAdminManager 在 sudo 管理命令里也追加换行符，避免密码输入未结束。
- 新增 AppManager.IsLinuxSudoReady，把“是否已经输入过 sudo 密码”和“密码字符串是否为空”解耦。
- StatusBarViewModel 不再用 LinuxSudoPwd.IsNotEmpty() 判断 sudo 是否准备好，而改用 IsLinuxSudoReady。
- StatusBarView.axaml.cs 只在用户取消时关闭 TUN，空字符串密码也会保存并标记 sudo ready。

涉及文件：

- v2rayN/ServiceLib/Manager/AppManager.cs
- v2rayN/ServiceLib/Manager/CoreAdminManager.cs
- v2rayN/ServiceLib/ViewModels/StatusBarViewModel.cs
- v2rayN/v2rayN.Desktop/Views/StatusBarView.axaml.cs
- v2rayN/v2rayN.Desktop/Views/SudoPasswordInputView.axaml.cs

2. Ubuntu 18.04 托盘图标显示修复

提交：e75f1ac feat(app): 更新ubuntu18.04系统托盘图标并添加动态图标切换功能

变更点：

- 新增 Linux panel 专用托盘图标，尺寸为 22x22，避免 Ubuntu 18.04 AppIndicator 对大尺寸 IconPixmap 二次缩放导致图标过小。
- Linux 下托盘图标从原来的 .ico 改为加载 .panel.png。
- Windows 仍保留 .ico 加载逻辑。
- AvaUtils.GetAppIcon 根据系统平台动态选择图标资源。
- 应用启动时主动设置主窗口图标和托盘图标，避免初始托盘图标仍用旧资源。
- 初始 TrayIcon XAML 图标改成 /Assets/NotifyIcon1.panel.png。
- .gitignore 增加 .code*。

涉及文件：

- .gitignore
- v2rayN/v2rayN.Desktop/App.axaml
- v2rayN/v2rayN.Desktop/App.axaml.cs
- v2rayN/v2rayN.Desktop/Common/AvaUtils.cs
- v2rayN/v2rayN.Desktop/Assets/NotifyIcon1.panel.png
- v2rayN/v2rayN.Desktop/Assets/NotifyIcon2.panel.png
- v2rayN/v2rayN.Desktop/Assets/NotifyIcon3.panel.png
- v2rayN/v2rayN.Desktop/Assets/NotifyIcon4.panel.png

3. Linux DEB 打包脚本

提交：6b4bf49 build(linux): 添加Linux DEB包构建脚本

变更点：

- 新增 package-linux-deb.sh。
- 将 Release 输出打包到 /opt/v2rayN。
- 创建 /usr/bin/v2rayN 启动入口。
- 创建 /usr/share/applications/v2rayN.desktop 桌面入口。
- 安装应用图标到 /usr/share/pixmaps/v2rayN.png。
- 自动生成 DEBIAN/control 元数据。
- 使用 dpkg-deb --build --root-owner-group 生成 .deb。
- 打包时排除个人运行数据：
    - guiConfigs
    - guiLogs
    - guiTemps
    - guiBackups
    - NotifyIcon*.panel-v*.png


# v2rayN

A GUI client for Windows, Linux and macOS, support [Xray](https://github.com/XTLS/Xray-core)
and [sing-box](https://github.com/SagerNet/sing-box)
and [others](https://github.com/2dust/v2rayN/wiki/List-of-supported-cores)

[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/2dust/v2rayN)](https://github.com/2dust/v2rayN/commits/master)
[![CodeFactor](https://www.codefactor.io/repository/github/2dust/v2rayn/badge)](https://www.codefactor.io/repository/github/2dust/v2rayn)
[![GitHub Releases](https://img.shields.io/github/downloads/2dust/v2rayN/latest/total?logo=github)](https://github.com/2dust/v2rayN/releases)
[![Chat on Telegram](https://img.shields.io/badge/Chat%20on-Telegram-brightgreen.svg)](https://t.me/v2rayn)

## How to use

Read the [Wiki](https://github.com/2dust/v2rayN/wiki) for details.

## Telegram Channel

[github_2dust](https://t.me/github_2dust)
