# Linux에서 Monitor 전환(Dell U2719DC)

> https://jeancharles.quillet.org/posts/2021-08-20-How-to-use-ddcutil-to-switch-input-of-a-Dell-screen.html

## DDCUtil 기본 명령어

```sh
# 모니터 정보 조회
sudo ddcutil detect --verbose

# 모니터 설정 정보
sudo ddcutil capabilities

# Switch to Display Port
sudo ddcutil setvcp 60 0x0f
# Switch to HDMI
sudo ddcutil setvcp 60 0x11
# Switch to USB-C
sudo ddcutil setvcp 60 0x1b
```

## 자동전환 스크립트(toggle.sh)

```sh
#!/usr/bin/env bash

set -o nounset
set -o errexit

# Get current input
current=$(ddcutil getvcp 60 | sed -n "s/.*(sl=\(.*\))/\1/p")

# Get the other input
case $current in

    # Usb
    0x1b)
        output=0x11
        ;;

    # HDMI port
    0x11)
        output=0x1b
        ;;

    *)
        echo "Unknown input"
        exit 1
        ;;
esac

# Set new input
ddcutil setvcp 60 $output
```
