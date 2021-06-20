# PROJECT 6 - Web Solution With WordPress
In this project you will be tasked to prepare storage infrastructure on two Linux servers and implement a basic web solution using WordPress. WordPress is a free and open-source content management system written in PHP and paired with MySQL or MariaDB as its backend Relational Database Management System (RDBMS).

## Step 1 — Prepare a Web Server
* Launch an EC2 instance that will serve as “Web Server”. Create 3 volumes in the same AZ as your Web Server EC2, each of 10 GiB.

![create volumes](images/Project6/Project6-Step1-createvolumes.png)

* Attach all three volumes one by one to your Web Server EC2 instance

![attach volumes](images/Project6/Project6-Step1-attachvolumes.png)

---
* Open up the Linux terminal to begin configuration

* Use lsblk command to inspect what block devices are attached to the server. Notice names of your newly created devices. All devices in Linux reside in /dev/ directory. Inspect it with ls /dev/ and make sure you see all 3 newly created block devices there - their names will likely be xvdf, xvdh, xvdg.

![lsblk](images/Project6/Project6-Step1-lsblk.png)

* Use `df -h` command to see all mounts and free space on your server.

![dfh](images/Project6/Project6-Step1-dfh.png)

* Use gdisk utility to create a single partition on each of the 3 disks.
```
sudo gdisk /dev/xvdf
```
![gdisk](images/Project6/Project6-Step1-sudogdisk.png)

* Use `lsblk` utility to view the newly configured partition on each of the 3 disks. 

![partitions](images/Project6/Project6-Step1-partitions.png)

---
* Install `lvm2` package using `sudo yum install lvm2`. 

![yum install lvm2](images/Project6/Project6-Step1-installlvm2.png)

* Run `sudo lvmdiskscan` command to check for available partitions.

![lvmdiskscan](images/Project6/Project6-Step1-lvmdiskscan.png)

---
* Use `pvcreate` utility to mark each of 3 disks as physical volumes (PVs) to be used by LVM
```
sudo pvcreate /dev/xvdf1
sudo pvcreate /dev/xvdg1
sudo pvcreate /dev/xvdh1
```
* Verify that your Physical volume has been created successfully by running `sudo pvs`
---
* Use `vgcreate` utility to add all 3 PVs to a volume group (VG). Name the VG 'webdata-vg'
```
sudo vgcreate webdata-vg /dev/xvdh1 /dev/xvdg1 /dev/xvdf1
```
* Verify that your VG has been created successfully by running `sudo vgs`
---
* Use `lvcreate` utility to create 2 logical volumes. 'apps-lv' (Use half of the PV size), and 'logs-lv' Use the remaining space of the PV size.
```
sudo lvcreate -n apps-lv -L 14G webdata-vg
sudo lvcreate -n logs-lv -L 14G webdata-vg
```
apps-lv will be used to store data for the Website while, logs-lv will be used to store data for logs.

* Verify that your Logical Volume has been created successfully by running `sudo lvs`

![pvcreate](images/Project6/Project6-Step1-pvcreate.png)

---
* Verify the entire setup
```
sudo vgdisplay -v #view complete setup - VG, PV, and LV
sudo lsblk 
```
![complete setup](images/Project6/Project6-Step1-completesetup.png)

---

* Use `mkfs.ext4` to format the logical volumes with ext4 filesystem
```
sudo mkfs -t ext4 /dev/webdata-vg/apps-lv
sudo mkfs -t ext4 /dev/webdata-vg/logs-lv
```
![sudo mkfs](images/Project6/Project6-Step1-sudomkfs.png)

---
* Create `/var/www/html` directory to store website files
```
sudo mkdir -p /var/www/html
```
* Create `/home/recovery/`logs to store backup of log data
```
sudo mkdir -p /home/recovery/logs
```
* Mount `/var/www/html` on 'apps-lv' logical volume
```
sudo mount /dev/webdata-vg/apps-lv /var/www/html/
```
![sudo mkdir html](images/Project6/Project6-Step1-mkdirhtml.png)

---

* Use `rsync` utility to backup all the files in the log directory `/var/log` into `/home/recovery/logs` (This is required before mounting the file system)
```
sudo rsync -av /var/log/. /home/recovery/logs/
```
* Mount `/var/log` on `logs-lv` logical volume. (Note that all the existing data on /var/log will be deleted. That is why step above is very important)
```
sudo mount /dev/webdata-vg/logs-lv /var/log
```
* Restore log files back into `/var/log` directory
```
sudo rsync -av /home/recovery/logs/. /var/log
```
![sudo rsync](images/Project6/Project6-Step1-rsync.png)

The UUID of the device will be used to update the /etc/fstab file;

* Update `/etc/fstab` file so that the mount configuration will persist after restart of the server.
```
sudo blkid
```
![sudo blkid](images/Project6/Project6-Step1-blkid.png)

* Update `/etc/fstab` in this format using your own UUID and remember to remove the leading and ending quotes.
```
sudo vi /etc/fstab
```
![vi fstab](images/Project6/Project6-Step1-fstab.png)

---
* Test the configuration and reload the daemon
```
sudo mount -a
sudo systemctl daemon-reload
```
* Verify your setup by running `df -h`, output must look like this:

![test config](images/Project6/Project6-Step1-testconfig.png)

---

## Step 2 — Prepare the Database Server
Launch a second RedHat EC2 instance that will have a role - ‘DB Server’ Repeat the same steps as for the Web Server, but instead of apps-lv create db-lv and mount it to /db directory instead of /var/www/html/.


![DB volumes](images/Project6/Project6-Step2-dbvolumes.png)

![DB volume attach](images/Project6/Project6-Step2-dbvolumeattach.png)

---
```
lsblk 
```
![DB lsblk](images/Project6/Project6-Step2-dblsblk.png)
```
df -h
```

![DB df -h](images/Project6/Project6-Step2-dbdfh.png)
```
sudo gdisk /dev/xvdf
sudo gdisk /dev/xvdg
sudo gdisk /dev/xvdfh
```
![DB gdisk](images/Project6/Project6-Step2-dbgdisk.png)
```
lsblk
```

![DB partitions](images/Project6/Project6-Step2-dbpartitions.png)

---
```
sudo yum install lvm2
```


![DB install lvm2](images/Project6/Project6-Step2-dbinstalllvm2.png)
```
sudo lvmdiskscan
```

![DB lvmdiskscan](images/Project6/Project6-Step2-dblvmdiskscan.png)

---
```
sudo pvcreate /dev/xvdf1
sudo pvcreate /dev/xvdg1
sudo pvcreate /dev/xvdh1
```
```
sudo pvs
```

![DB pvcreate](images/Project6/Project6-Step2-dbpvcreate.png)

---
```
sudo vgcreate webdata-vg /dev/xvdh1 /dev/xvdg1 /dev/xvdf1
```
```
sudo vgs
```
![DB vgcreate](images/Project6/Project6-Step2-dbvgcreate.jpg)

---
```
sudo lvcreate -n db-lv -L 14G webdata-vg
sudo lvcreate -n logs-lv -L 14G webdata-vg
```
```
sudo lvs
```
![DB lvcreate](images/Project6/Project6-Step2-dblvcreate.png)

---
```
sudo vgdisplay
sudo lsblk 
```

![DB vgdisplay](images/Project6/Project6-Step2-dbvgdisplay.png)

---
```
sudo mkfs -t ext4 /dev/webdata-vg/db-lv
sudo mkfs -t ext4 /dev/webdata-vg/logs-lv
```
![DB mkfs](images/Project6/Project6-Step2-dbmkfs.png)
```
sudo mkdir -p /db
sudo mkdir -p /home/recovery/logs
sudo mount /dev/webdata-vg/db-lv /db
```

![DB mount /db](images/Project6/Project6-Step2-dbmount.png)
```
sudo rsync -av /var/log/. /home/recovery/logs/
```

![DB rsync /log](images/Project6/Project6-Step2-dbrsynclogs.png)
```
sudo mount /dev/webdata-vg/logs-lv /var/log
sudo rsync -av /home/recovery/logs/log/. /var/log 
```

![DB mount /log](images/Project6/Project6-Step2-dbmountlogs.png)

---
```
sudo blkid
```
![DB blkid](images/Project6/Project6-Step2-dbblkid.png)
```
sudo vi /etc/fstab
```

![DB fstab](images/Project6/Project6-Step2-dbfstab.png)
```
sudo mount -a
sudo systemctl daemon-reload  
df -h
```

![DB output](images/Project6/Project6-Step2-dboutput.png)

---
## Step 3 — Install Wordpress on your Web Server EC2
* Update the repository
```
sudo yum -y update
```
![yum update](images/Project6/Project6-Step3-yumupdate.png)

* Install wget, Apache and its dependencies
```
sudo yum -y install wget httpd php php-mysqlnd php-fpm php-json
```
![Install wget](images/Project6/Project6-Step3-installwget.png)

* Start Apache
```
sudo systemctl enable httpd
sudo systemctl start httpd
```
![start apache](images/Project6/Project6-Step3-startapache.png)

---
* Install PHP and its dependencies
```
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
```
![install epel](images/Project6/Project6-Step3-installepel.png)
```
sudo yum install yum-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
```
![install remi](images/Project6/Project6-Step3-installremi.png)
```
sudo yum module list php
sudo yum module reset php
sudo yum module enable php:remi-7.4
```
![module list](images/Project6/Project6-Step3-modulelist.png)
```
sudo yum install php php-opcache php-gd php-curl php-mysqlnd
```
![install php](images/Project6/Project6-Step3-installphp.png)
```
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
setsebool -P httpd_execmem 1
```
![start php](images/Project6/Project6-Step3-startphp.png)

* Restart Apache
```
sudo systemctl restart httpd
```
---
* Download wordpress and copy wordpress to `var/www/html`
```
mkdir wordpress
cd   wordpress
sudo wget http://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz

```
![mkdir wordpress](images/Project6/Project6-Step3-mkdirwordpress.png)
```
sudo rm -rf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php
cp -R wordpress /var/www/html/
```
![sudo rm](images/Project6/Project6-Step3-sudorm.png)

* Configure SELinux Policies
```
sudo chown -R apache:apache /var/www/html/wordpress
sudo chcon -t httpd_sys_rw_content_t /var/www/html/wordpress -R
sudo setsebool -P httpd_can_network_connect=1
 ```

 ![sudo chown](images/Project6/Project6-Step3-sudochown.png)

 ---
## Step 4 — Install MySQL on your DB Server EC2
* Connect to database server and install MySQL
```
sudo yum update
sudo yum install mysql-server
```
 ![yum update](images/Project6/Project6-Step4-yumupdate.png)

 ![install mysql](images/Project6/Project6-Step4-installmysql.png)

* Verify that the service is up and running by using `sudo systemctl status mysqld`, if it is not running, restart the service and enable it so it will be running even after reboot:
```
sudo systemctl restart mysqld
sudo systemctl enable mysqld
```
![status mysqld](images/Project6/Project6-Step4-statusmysqld.png)

---
## Step 5 — Configure DB to work with WordPress

* Start mysql service and create database and user
```
sudo mysql
CREATE DATABASE wordpress;
CREATE USER `myuser`@`<Web-Server-Private-IP-Address>` IDENTIFIED BY 'mypass';
GRANT ALL ON wordpress.* TO 'myuser'@'<Web-Server-Private-IP-Address>';
FLUSH PRIVILEGES;
SHOW DATABASES;
exit
```
![configure DB](images/Project6/Project6-Step5-configuredb.jpg)

---
## Step 6 — Configure WordPress to connect to remote database
* Do not forget to open MySQL port 3306 on DB Server EC2. For extra security, you shall allow access to the DB server ONLY from your Web Server’s IP address, so in the Inbound Rule configuration specify source as /32

![port 3306](images/Project6/Project6-Step6-port3306.png)

* Install MySQL client and test that you can connect from your Web Server to your DB server by using `mysql-client`
```
sudo yum install mysql
sudo mysql -u admin -p -h <DB-Server-Private-IP-address>
```
![mysql client](images/Project6/Project6-Step6-mysqlclient.png)

* Verify if you can successfully execute SHOW DATABASES; command and see a list of existing databases.

![show db](images/Project6/Project6-Step6-showdb.png)

* Change permissions and configuration so Apache could use WordPress:
```
sudo mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf_backup
sudo chown -R apache:apache /var/www/html/wordpress
sudo chcon -t httpd_sys_rw_content_t /var/www/html/wordpress -R
sudo setsebool -P httpd_can_network_connect=1
sudo setsebool -P httpd_can_network_connect_db=1
```

![permissions](images/Project6/Project6-Step6-permissions.png)

* Enter database details into `wp-config.php`
```
sudo vi /var/www/html/wordpress/wp-config.php
```
![wp-config.php](images/Project6/Project6-Step6-wpconfigphp.jpg)

* Enable TCP port 80 in Inbound Rules configuration for your Web Server EC2 (enable from everywhere 0.0.0.0/0 or from your workstation’s IP)

![webserver sg](images/Project6/Project6-Step6-websg.png)
 
* Try to access from your browser the link to your WordPress `http://<Web-Server-Public-IP-Address>/wordpress/` and fill out your credentials

![wordpress credentials](images/Project6/Project6-Step6-wpcreds.png)

If you see this page - it means your WordPress has successfully connected to your remote MySQL database

![wordpress dashboard](images/Project6/Project6-Step6-wpdashboard.png)

## You have learned how to configure Linux storage susbystem and have also deployed a full-scale Web Solution using WordPress CMS and MySQL RDBMS!