#!/bin/bash
set -e

wget -N http://archive.kernel.org/debian-archive/debian/pool/main/u/umodpack/umodpack_0.5b16-2_all.deb
sudo dpkg -i umodpack_0.5b16-2_all.deb
sudo cpan install Win32::Registry::File
sudo sed -i 's/Config::Ini/Win32::Registry::File/' /usr/bin/{,x}umod
sudo sed -i 's/Config::Ini/Win32::Registry::File/' /usr/share/perl5/Umod.pm
sudo sed -i 's/%hash->{/$hash{/' /usr/share/perl5/Umod.pm
