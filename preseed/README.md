# preseed

> debian automated install

## Usage

### network

- serve preseed.cfg over local networks
    - http-server preseed/
    - at grub selection, select expert automated install then press "e"
    - auto=true priority=high url=http://<YOUR_LOCAL_IP>:<PORT>/preseed.cfg

### local

- copy preseed.cfg to the usb
    - at grub selection, select expert automated install then press "e"
    - auto=true priority=high preseed/file=/cdrom/preseed.cfg
- Press F10 or Ctrl+X to start.