# 微信图片剪贴板转换

Linux 微信右键复制图片时，有时只会将图片文件地址放入剪贴板，导致需要图片数据的应用无法粘贴。本工具监听剪贴板，将微信临时目录中的单张图片转换为 PNG 图片数据，方便粘贴到 Codex 等应用。

## 安装

适用于支持 `wl-paste --watch` 的 Wayland 桌面，需要安装 `wl-clipboard`、`ffmpeg`、Node.js 和用户级 systemd。运行：

```sh
./install.sh
```

安装后服务会立即启动，并随图形会话自动启动。默认识别 `~/文档/xwechat_files` 下 `temp/RWTemp` 目录中的 JPEG、PNG、WebP 和 BMP 图片；其他路径和多文件复制不会转换。微信文件目录不同时，需要调整脚本中的路径。

转换会将剪贴板中的文件地址替换为 PNG 图片数据；需要作为文件复制时，可在微信中使用“另存为”。转换过程中如果剪贴板内容已改变，程序不会覆盖新的内容。

## 状态和卸载

```sh
systemctl --user status wechat-clipboard-image.service
systemctl --user disable --now wechat-clipboard-image.service
rm ~/.config/systemd/user/wechat-clipboard-image.service ~/.local/bin/wechat-clipboard-image
systemctl --user daemon-reload
```

转换在本机进行，不上传图片。
