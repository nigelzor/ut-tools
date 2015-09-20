#!/bin/bash
set -e

wget -N http://archive.kernel.org/debian-archive/debian/pool/main/u/umodpack/umodpack_0.5b16-2_all.deb
type cpanm &> /dev/null || sudo aptitude install cpanminus
cpanm --sudo Win32::Registry::File
sudo gdebi umodpack_0.5b16-2_all.deb
sudo sed -i 's/Config::Ini/Win32::Registry::File/' /usr/bin/{,x}umod
sudo sed -i 's/Config::Ini/Win32::Registry::File/' /usr/share/perl5/Umod.pm
sudo sed -i 's/%hash->{/$hash{/' /usr/share/perl5/Umod.pm
