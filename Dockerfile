FROM archlinux:latest

RUN pacman --noconfirm -Sy archlinux-keyring && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Su --noconfirm && \
    pacman -S --noconfirm wget vim xorg adobe-source-han-sans-cn-fonts noto-fonts-emoji git fakeroot binutils nss libxss gtk3 alsa-lib pulseaudio gjs libappindicator-gtk3 fcitx5-gtk xdg-utils libvips openjpeg2 && \
    pacman -Scc --noconfirm

# ARG USER_ID
# ARG TIMEZONE

RUN env && useradd -m user 
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

USER user
RUN ["/bin/bash", "-c", "wget -qO- -t1 -T2 \"https://api.github.com/repos/ntdgy/linuxqq/releases/latest\" | grep \"browser_download_url\" | grep \"wechat\" | sed -r -n 's/.*\"browser_download_url\": *\"(.*)\".*/\\1/p' | xargs wget -O ~/wechat.pkg.tar.zst"]


USER root
RUN pacman --noconfirm -U /home/user/wechat.pkg.tar.zst

USER user
RUN rm -rf ~/wechat.pkg.tar.zst && mkdir -p ~/.config/wechat