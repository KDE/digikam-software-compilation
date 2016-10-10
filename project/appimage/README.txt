To compile digiKam from Git as an AppImage:

- Create a fresh CentOS 6.x environment in a VM:
  Install from CentOS-6.8-x86_64-bin-DVD1.iso
  Yum install git
  git clone git://anongit.kde.org/digikam-software-compilation.git DK
  cd DK/project/appimage/
  bash build-linux.sh

- Install the dependencies
  bash build-extralibs.sh  # ~2-3h, 5-6GB

- Build digiKam:
  bash build-digikam.sh  # ~30mm

- Bundle the AppImage:
  bash build-appimage.sh  # ~5mn

Your appimage is ready in ./appimage/digikam-version-x86_64.appimage
