# 멀티부트 환경에서 Bluetooth 페어링 공유 방법

## 참고자료

```
# Keyboard, Earphone는 LinkKey로 설정 가능
https://unix.stackexchange.com/questions/568521/simpler-method-of-pairing-bluetooth-devices-for-both-windows-linux

# Mouse는 IRK, CSRK, LTK, EDIV, ERAND 값을 모두 설정해야 함.
https://www.youtube.com/watch?v=BprSnu6KWTA&t=249s
```

### 마우스 적용 예시

```
Devide : D7:8A:FE:1C:3B:9D
리눅스에 페이렁된 Device 아이디가 다른 경우 폴더면 Rename
(pairing을 다시 하는 경우 Device 아디가 변경되는 장비가 있음)

IRK : (Hexa 값을 대문자로)
SRC : 00000000   c2 7c 77 0d 01 60 f4 f4 - 5e 89 4c 09 e4 79 7c 60
DEST : C27C770D0160F4F45E894C09E4797C60

CSRK : (Hexa 값을 대문자로)
SRC : 00000000   5b 67 f8 18 d6 de b5 5e - 0e 78 c8 f3 16 4f f4 ce
DEST : 5B67F818D6DEB55E0E78C8F3164FF4CE

LTK : (Hexa 값을 대문자로)
SRC : 00000000   31 ed bd e5 8f 25 21 8b - 9e a0 6e a4 fe 57 f1 ff
DEST : 31EDBDE58F25218B9EA06EA4FE57F1FF

EDIV : Hexa 값을 Descimal로
SRC :   Data:            0xc928(51496)
DEST : 51496

ERAND : Byte를 역순으로 바꾼 Hexa 값을 Descimal로
SRC : 00000000   f8 1e 84 0b 25 2c a1 bd
DEST : bda12c250b841ef8 -> 13664251282037415672

Ubuntu에 적용

/var/lib/bluetooth/C4:03:A8:9C:10:16/D7:8A:FE:1C:3B:A1/info
[IdentityResolvingKey]
Key=C27C770D0160F4F45E894C09E4797C60

[LocalSignatureKey]
Key=5B67F818D6DEB55E0E78C8F3164FF4CE
Counter=0
Authenticated=false

[LongTermKey]
Key=31EDBDE58F25218B9EA06EA4FE57F1FF
Authenticated=0
EncSize=16
EDiv=51496
Rand=13664251282037415672
```
