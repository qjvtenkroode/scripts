!#/bin/sh

echo "### Getting vmlinux and initrd.img ###"
curl -o /boot/vmlinuz http://mirror.zetup.net/CentOS/7/os/x86_64/isolinux/vmlinuz
curl -o /boot/initrd.img http://mirror.zetup.net/CentOS/7/os/x86_64/isolinux/initrd.img

echo "### Setting content in /etc/grub.d/40_custom ###"
echo """menuentry "Install CentOS 7" {
    set root=(hd0,1)
        linux /vmlinuz ks=/home/quincey/projects/scripts/server/kickstart/centos7-ks.cfg
            initrd /initrd.img
        }
    """ >> /etc/grub.d/40_custom

echo "### Setting grub default"
sed -i "s/GRUB_DEFAULT=\".*\"/GRUB_DEFAULT=\"Install CentOS 7\"/g" /etc/default/grub

echo "### Make grub2 config ###"
grub2-mkconfig --output=/boot/grub2/grub.cfg
