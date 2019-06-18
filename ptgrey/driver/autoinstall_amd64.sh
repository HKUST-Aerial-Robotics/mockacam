DRIVER_PATH=`pwd`
sudo apt-get update
cd $DRIVER_PATH/usb/
tar jxvf libusb-1.0.21.tar.bz2
cd libusb-1.0.21/
./configure
make
sudo make install
cd $DRIVER_PATH/amd64/
tar zxvf flycapture2-2.11.3.121-amd64-pkg.tgz
cd flycapture2-2.11.3.121-amd64/
sudo apt-get install libraw1394-11 libgtkmm-2.4-dev libglademm-2.4-dev libgtkglextmm-x11-1.2-dev libusb-1.0-0 -y
sudo sh install_flycapture.sh
