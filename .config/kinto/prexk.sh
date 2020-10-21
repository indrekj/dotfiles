#!/bin/bash
if [ -f /home/indrek/.config/systemd/user/keyswap.timer ]; then
	systemctl --user stop keyswap.timer >/dev/null 2>&1
	systemctl --user disable keyswap.timer >/dev/null 2>&1
fi
if [ -f /home/indrek/.config/systemd/user/keyswap.service ]; then
	systemctl --user stop keyswap >/dev/null 2>&1
	systemctl --user disable keyswap >/dev/null 2>&1
fi

# export DISPLAY=:0;/usr/bin/xhost +SI:localuser:root
mkdir -p /tmp/kinto/xkeysnail
cp /home/indrek/.config/kinto/kinto.py /tmp/kinto/xkeysnail/kinto.py
