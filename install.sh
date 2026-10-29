#!/bin/sh
set -eu
for command in node ffmpeg wl-paste wl-copy systemctl; do
  command -v "$command" >/dev/null || { printf '缺少依赖：%s\n' "$command" >&2; exit 1; }
done
node_path=$(command -v node)
paste_path=$(command -v wl-paste)
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mkdir -p "$HOME/.local/bin" "$HOME/.config/systemd/user"
install -m 755 "$script_dir/wechat-clipboard-image" "$HOME/.local/bin/wechat-clipboard-image"
cat > "$HOME/.config/systemd/user/wechat-clipboard-image.service" <<EOF
[Unit]
Description=Convert copied WeChat temporary images to clipboard images
PartOf=graphical-session.target
After=graphical-session.target

[Service]
ExecStart="$paste_path" --type text/uri-list --watch "$node_path" "%h/.local/bin/wechat-clipboard-image"
Restart=on-failure
RestartSec=2

[Install]
WantedBy=graphical-session.target
EOF
systemctl --user daemon-reload
systemctl --user enable wechat-clipboard-image.service
systemctl --user restart wechat-clipboard-image.service
printf '安装完成。请在微信复制图片后尝试粘贴。\n'
