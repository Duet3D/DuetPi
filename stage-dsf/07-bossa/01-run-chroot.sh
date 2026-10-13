cd /usr/src/bossa

# The applet sources are committed and only regenerated when the assembly is newer, which needs a cross assembler
touch src/*.cpp
make -j$(nproc) bin/bossac bin/bossash

# /usr/local/bin comes before /usr/bin in PATH, so these shadow the packaged binaries
install -m 755 bin/bossac bin/bossash /usr/local/bin/

cd /
rm -rf /usr/src/bossa
apt-get purge -y libreadline-dev
apt-get autoremove -y
