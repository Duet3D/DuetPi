cd /usr/src/bossa

touch src/*.cpp
make -j$(nproc) bin/bossa
install -m 755 bin/bossa /usr/local/bin/

cd /
rm -rf /usr/src/bossa
# The GTK development stack behind libwxgtk3.2-dev is only needed to link bossa
apt-get purge -y libwxgtk3.2-dev libx11-dev
apt-get autoremove -y
