P2P=1661
RPC=6116
USER=bktuser
TEMPDIR=tempBTK
COIN=Bankitt
COIND=bankittd
COINDS=bankittd_screen
COINCLI=bankitt-cli
COINCONF=bankitt.conf
COINCORE=.bankittcore
COINS="BKT:"
COINDEV="BqqRdh8C7erxonKvpJN2j9LdQh2s1pSfxb"
ADDCOINCONF="addnode=159.65.4.213:1661\naddnode=159.65.4.238:1661\naddnode=148.251.244.141:1661\naddnode=186.55.79.148:1661\naddnode=193.124.176.128:1661\naddnode=194.166.140.209:1661\naddnode=201.185.74.67:1661\naddnode=219.115.192.147:1661\naddnode=65.60.245.79:1661\naddnode=95.65.39.101:1661\naddnode=51.254.63.208:1661"
RPCALLOWIP=127.0.0.1
MAXCONN=256
MNKEY=$1
echo -e "Ubuntu 16.04 Installation file for $COIN"
echo -e "\nTO ENSURE A COMPLETE INSTALLATION, ADD YOUR PRIVATE MASTERNODE KEY TO COMMAND WHEN RUNNING THIS SCRIPT. ./Install.sh YOURKEY\n"
echo -e "\nInstallation of $COIN will be based on following settings: \nP2P Port $P2P, RPC Port $RPC.\nRPC User is set to $USER\nYour Private Masternode Key: $MNKEY\nThis script will generate a random rpc password, and will allocate IP from eth0.\n\n"
echo -e "Installation will take from 10min to an hour depending on your server specs, and will use apt to install multiple new packages needed. Usage of this script comes without any warranties at all!\n"
echo -n "Would you like to continue installation? (y/n)?"
old_stty_cfg=$(stty -g)
stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
  echo -e "\nOK.\n"
else
  echo -e "\n"
  exit
fi
echo -n "Would you like to install update and required packages? (y/n)?"
old_stty_cfg=$(stty -g)
stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
  echo -e "\nOK.\n"
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get dist-upgrade -y
  sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils software-properties-common libgmp3-dev nano htop git wget libboost-all-dev pwgen -y
  sudo add-apt-repository ppa:bitcoin/bitcoin -y
  sudo apt-get update -y
  sudo apt-get install libdb4.8-dev libdb4.8++-dev libminiupnpc-dev -y
else
  echo -e "\n"
fi
PASS=`pwgen -1 20 -n`
EXIP=`wget -qO- eth0.me`
echo -n "Would you like to install $COIN? (y/n)?"
old_stty_cfg=$(stty -g)
stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
  echo -e "\nOK.\n"
  mkdir $HOME/$TEMPDIR
  chmod -R 777 $HOME/$TEMPDIR
  sudo git clone https://github.com/bankitt/bankitt.git $HOME/$TEMPDIR
  cd $HOME/$TEMPDIR
  chmod 777 autogen.sh
  ./autogen.sh
  ./configure
  chmod +x share/genbuild.sh
  sudo make
  sudo make install
  cd $HOME
  mkdir $HOME/$COINCORE
  chmod -R 777 $HOME/$COINCORE
else
  echo -e "\n"
fi
echo -n "Do you wish to configure this installation as a cold masternode? (No will allow you run as a ordinary Wallet) (y/n)"
old_stty_cfg=$(stty -g)
stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
  echo -e "\nGenerating configuration and saving to $HOME/$COINCORE/$COINCONF\n"
  printf "rpcuser=$USER\nrpcpassword=$PASS\nrpcport=$RPC\ndaemon=1\nlisten=1\nserver=1\nmaxconnections=$MAXCONN\nrpcallowip=$RPCALLOWIP\nexternalip=$EXIP:$P2P\nmasternode=1\nmasternodeprivkey=$MNKEY\n$ADDCOINCONF\n" > /$HOME/$COINCORE/$COINCONF
else
  echo -e "\nGenerating configuration and saving to $HOME/$COINCORE/$COINCONF\n"
  printf "rpcuser=$USER\nrpcpassword=$PASS\nrpcport=$RPC\ndaemon=1\nlisten=1\nserver=1\nmaxconnections=$MAXCONN\nrpcallowip=$RPCALLOWIP\n$ADDCOINCONF\n" > /$HOME/$COINCORE/$COINCONF
fi
echo -n "Do you wish to setup $COIN daemon as a system service? (y/n)?"
old_stty_cfg=$(stty -g)
stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo -e "\nAdding to services....\n"
    printf "[Unit]\nDescription=Script for system controlled start of $COIN daemon\nAfter=network.target\n\n[Service]\nType=forking\nUser=root\nGroup=root\nKillMode=none\nExecStart=/usr/bin/screen -d -m -fa -S $COINDS /usr/local/bin/$COIND -daemon\nExecStop=/usr/bin/screen -X -S $COINDS quit\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/$COIND.service
    systemctl daemon-reload
    echo -n "Would you like $COIN daemon to start automatically on boot? (y/n)?"
    old_stty_cfg=$(stty -g)
    stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg
    if echo "$answer" | grep -iq "^y" ;then
      echo -e "\nOK, Enabling.\n"
      systemctl enable $COIND.service
    else
      echo -e "\nDaemon will not start on boot.\n"
    fi
    echo -n "\nWould you like to allow port $P2P in UFW(if installed)? (y/n)?"
    old_stty_cfg=$(stty -g)
    stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg
    if echo "$answer" | grep -iq "^y" ;then
      echo -e "\nOK, Enabling.\n"
      sudo ufw allow $P2P
    else
      echo -e "\nPort will not be allowed. If you have a firewall, you will need to open this port manually.\n"
    fi
    echo -n "Would you like $COIN daemon to start now? (y/n)?"
    old_stty_cfg=$(stty -g)
    stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg
    if echo "$answer" | grep -iq "^y" ;then
      echo -e "OK, Trying to start.\n"
      systemctl start $COIND.service
      echo "Getting $COIN Client Info....."
      /usr/local/bin/$COINCLI getinfo 2>&1 >> OUTPUT
      echo "$OUTPUT"
    else
      echo -e "\nDaemon will not start on boot.\n"
    fi
else
    echo -e "\n$COIN daemon is not added as system service. You can manually start it by command << $COIND -daemon >>\n"
fi
rm -Rf $HOME/$TEMPDIR
echo -e "If this installation was completed as a masternode installation please allow some time for the service to update its database then you can try to activate your masternode on your local wallet and use command << $COINCLI masternode status >> on your server to verify that it have been started. You can also verify amount of blocks synced by using command << bankitt-cli getinfo >>\n\n"
echo -e "Installation is of $COIN Completed.\n\n\nLike this script? It would be awesome if you could donate me a beer!\n$COINS $COINDEV\nETH: 0x57A9F99645dC74F9373409A8Ba18Bc0F92566af3\nLTC: MGWHyZpZytPeKwvKLGZseuHAS8C2Ak3Xqe\nBTC: 3CVEThoqDY3RqS4fwnJWcUR6zd9Mfa2VLo\n\nMNInstaller script is created by cod3gen to ease installation of $COIN on Ubuntu 16.04."
