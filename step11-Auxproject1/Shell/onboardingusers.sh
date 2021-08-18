#!/bin/bash
userfile=$(cat names.csv)
PASSWORD=password

  if [ $(id -u) -eq 0 ]; then

# Reading the CSV file
    for user in $userfile;
    do
        echo $user
    if [ $(getent passwd $user) ];
    then
        echo "User exists"
    else
# Create new user
    useradd -m -G developers -s /bin/bash $user
    echo "New user created"
    echo
# Create ssh folder in user home folder
    echo ".ssh directory created for new user"
    echo
# Set user permission for ssh folder
    su - -c "chmod 700 ~/.ssh" $user
    echo "User permission for .ssh directory set"
    echo
# Create authorized_keys file
    su - -c "touch ~/.ssh/authorized_keys" $user
    echo "Authorized Key file created"
    echo
# Set permission for authorized_keys file
    su - -c "chmod 600 ~/.ssh/authorized_keys" $user
    echo "User permission for Authorized Key file set"
    echo
# Create and set public key for users in the server
    cp -R "/home/ubuntu/Shell/id_rsa.pub" "/home/$user/.ssh/authorized_keys"
    echo "Copied Public Key to New User account on the server"
    echo

    echo "User created"
# Generate a password
sudo echo -e "$PASSWORD\n$PASSWORD" | sudo passwd "$user"
sudo passwd -x 5 $user
        fi
    done
    else
    echo "Only Admin can onboard a user"
    fi