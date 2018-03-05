# MNInstallers
Installation of Masternodes is quite simple, but it can still be even simpler with these scripts!

During the time of creating masternodes i have found that many don`t have any good scripts to automate this processs.
Therefor i decided to create MNInstallers which is a small script to ease installation of wallets on Ubuntu 16.04 with the possibility to preconfigure wallet to run as a masternode.
MNInstallers comes without any warranties at all.

You can use these scripts to:
- Install wallet with masternode function
- Install as regular wallet
- Install as service
- Create new configs

This is a guided scripts, and your selections depends on what from above you would like this script to do for you. I only recommend a cold wallet, where you have your coins in your local wallet and masternode external on a VPS or Dedicated server with a static IP.
These scripts are only designed for Ubuntu 16.04.

# Supported Coins
Following coins are currently supported:
- Bankitt (v1.1.0.1) - Direct link: https://raw.githubusercontent.com/cod3gen/mninstallers/master/Bankitt/install.sh
- Shekel (v1.3.0.0) - Direct link: https://raw.githubusercontent.com/cod3gen/mninstallers/master/Shekel/install.sh
- Xuma (v1.0.3) - Direct link: https://raw.githubusercontent.com/cod3gen/mninstallers/master/Xuma/install.sh

# Howto install:

Log in as root user.

Use wget to download the script:
- wget Direct Link

Then you need to set correct permissions:
- chmod +x install.sh

Finally run the script:
- ./install.sh OR ./install.sh YOUR_PRIVATE_MN_KEY
- Follow scripts instructions.

When installation is finished, you can check wallet`s cli to verify blocks, or masternode. Example with Xuma wallet:
- xuma-cli getinfo -> Will display information about the wallet, including last block indexed.
- xuma-cli masternode status -> Will display status of masternode. If ok you should usually see "Masternode successfully started" as status.

# Get in touch

Get in touch at Discord - cod3gen#5466

Like this script? It would be awesome if you could donate me a beer!
ETH: 0x57A9F99645dC74F9373409A8Ba18Bc0F92566af3
LTC: MGWHyZpZytPeKwvKLGZseuHAS8C2Ak3Xqe
BTC: 3CVEThoqDY3RqS4fwnJWcUR6zd9Mfa2VLo
