# neptune kernel arch Android Waydroid Installer

note: use yay to install wlroots manually

also ignore warnings unless it kicks you out - i just removed some exits to get it installed.

its reccomended you install this: https://github.com/unlbslk/arch-deckify

and add these repos: 
[jupiter-3.7]
Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/jupiter>
SigLevel = Never

[holo-rel]
Server = https://steamdeck-packages.steamos.cloud/archlinux-mirror/$repo/o>
SigLevel = Never

located in: /etc/pacman.conf

add the latest neptune kernel and headers 

i forked this repo as i use rebornos and use some steamos things without it being steamos all while using neptune kernel newer then steamos

A collection of tools that is packaged into an easy to use script that is modifed to work with the Steam Deck running on other distros with arch and neptune kernel.
* The main program that does all the heavy lifting is [Waydroid - a container-based approach to boot a full Android system on a regular GNU/Linux system.](https://github.com/waydroid/waydroid)
* Waydroid Toolbox to easily toggle some configuration settings for Waydroid.
* [waydroid_script](https://github.com/casualsnek/waydroid_script) to easily add the libndk ARM translation layer and widevine.

**NOTE - this repository uses `main` and `testing` branches.**

| [SteamOS Waydroid Android Install Guide](https://www.youtube.com/watch?v=06T-h-jPVx8) | [SteamOS Waydroid Android Upgrade Guide](https://youtu.be/CJAMwIb_oI0) |
| ------------- | ------------- |
| [![image](https://github.com/user-attachments/assets/2f531480-2786-4ca7-9505-51a5b7443ff3)](https://youtu.be/06T-h-jPVx8)  | [![image](https://github.com/user-attachments/assets/88bb1e93-2f80-4ed0-82f1-1cbe78e04a2f)](https://youtu.be/CJAMwIb_oI0)  |

| [Android TV demo](https://youtu.be/gNFxrojouiM) | [Android 13 demo](https://youtu.be/5BZz8YynaUA) |
| ------------- | ------------- |
| [![image](https://github.com/user-attachments/assets/093bf362-10da-4ff6-ab3d-a3e50ea3c9f7)](https://youtu.be/gNFxrojouiM)  | [![image](https://github.com/user-attachments/assets/cdb47289-4ac6-4625-9fed-0903d624958a)](https://youtu.be/5BZz8YynaUA)  |


![image](https://github.com/user-attachments/assets/a9bc05cc-87ea-43f3-a628-56b0250ae88d)

**Android 13**
![image](https://github.com/user-attachments/assets/cc9d408b-b4af-4d39-8dd3-0507e15ef8a7)
![image](https://github.com/user-attachments/assets/a3ac44b6-68bf-4a1f-bf1a-e880b320dcf0)

**Android 13 TV**
![image](https://github.com/user-attachments/assets/141c2ec6-9918-40e8-bf87-2e199fbbb3f9)

# Disclaimer
1. Do this at your own risk!
2. This is for educational and research purposes only!
3. this is not officially supported

# [Video Tutorial - SteamOS Android Waydroid Installer](https://youtu.be/8S1RNSqFDu4?si=oCfwYNbs8u9sMKGr)
[Click the image below for a video tutorial and to see the functionalities of the script!](https://youtu.be/06T-h-jPVx8?si=pTWAlmcYyk9fHa38)
</b>
<p align="center">
<a href="https://youtu.be/06T-h-jPVx8?si=pTWAlmcYyk9fHa38"> <img src="https://github.com/ryanrudolfoba/SteamOS-Waydroid-Installer/blob/main/android.webp"/> </a>
</p>

# forked: made compat with other distros running yay and pacman and neptune kernel 

modded from: https://github.com/ryanrudolfoba/SteamOS-Waydroid-Installer
