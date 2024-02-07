사전 준비 작업

1. [EFI 파티션 용량 확장(UEFI GPT EFI Partition Expand) GParted]  
https://jimnong.tistory.com/1876

2. ARCH LINUX 최신 이미지  
https://archlinux.org/download/


How-to installation

1. connect wifi  
iwctl  
device list  
station wlan0 scan  
station wlan0 get-networks  
station wlan0 connect {{network name}}  
 
2. pacman  
pacman -S git  
 
3. install file  
git clone https://github.com/dolmengeroid/arch  
  
4. launch install.sh


 
