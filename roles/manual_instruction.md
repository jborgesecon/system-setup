1. Install VirtualBox via DNF (already handled by 02_packages.yml — VirtualBox-7.0)

2. Build the kernel modules: 
sudo /sbin/vboxconfig

3. Ensure the vboxusers group exists: 
sudo groupadd vboxusers

4. Add your user to the group: 
sudo usermod -aG vboxusers <your_user>

5. Log out and back in for the group membership to take effect

6. Verify the kernel module loaded: 
lsmod | grep vboxdrv