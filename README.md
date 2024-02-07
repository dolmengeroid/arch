# 사전 준비 작업

### 1. [EFI 파티션 용량 확장(UEFI GPT EFI Partition Expand) GParted]  
https://jimnong.tistory.com/1876

### 2. ARCH LINUX 최신 이미지  
https://archlinux.org/download/


# How-to installation

### 1. connect wifi  
iwctl  
device list  
station wlan0 scan  
station wlan0 get-networks  
station wlan0 connect {{network name}}  
 
### 2. pacman  
pacman -S git  
 
### 3. install file  
git clone https://github.com/dolmengeroid/arch  
  
### 4. launch install.sh 


# 초기 셋팅 
 
### 1. iBus 한글 입력 설정  
sudo nano ~/.bashrc  
-- 아래 내용 추가 --   
export GTK_IM_MODULE=ibus  
export XMODIFIERS=@im=ibus  
export QT_IM_MODULE=ibus  
  
ibus-daemon -drx  

### 해야할 것들!!  
KDE 로그인 페이지 테마 수정  
task bar 정리  
단축키 정리  
flatpak
allup 생성 --noconfirm  
dbeaver 
vscode  




 
