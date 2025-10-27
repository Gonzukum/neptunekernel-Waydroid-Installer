cp extras/Android_Waydroid_Cage.sh extras/Waydroid-Toolbox.sh extras/Waydroid-Updater.sh extras/Android_Waydroid_Cage-experimental.sh ~/Android_Waydroid
chmod +x ~/Android_Waydroid/*.sh

# desktop shortcuts for toolbox + updater
ln -s ~/Android_Waydroid/Waydroid-Toolbox.sh ~/Desktop/Waydroid-Toolbox &> /dev/null
ln -s ~/Android_Waydroid/Waydroid-Updater.sh ~/Desktop/Waydroid-Updater &> /dev/null

# lets check if this is a reinstall
grep redfin /var/lib/waydroid/waydroid_base.prop &> /dev/null || grep PH7M_EU_5596 /var/lib/waydroid/waydroid_base.prop &> /dev/null
if [ $? -eq 0 ]
then
	echo This seems to be a reinstall. Lets just make sure the symlinks are in place!
	if [ ! -d /etc/waydroid-extra ]
	then
		echo -e "$current_password\n" | sudo -S mkdir /etc/waydroid-extra
		echo -e "$current_password\n" | sudo -S ln -s ~/waydroid/custom /etc/waydroid-extra/images &> /dev/null
	fi

	# all done lets re-enable the readonly
	echo -e "$current_password\n" | sudo -S steamos-readonly enable
	echo Waydroid has been successfully installed!
else
	echo Downloading waydroid image from sourceforge.
	echo This can take a few seconds to a few minutes depending on the internet connection and the speed of the sourceforge mirror.
	echo Sometimes it connects to a slow sourceforge mirror and the downloads are slow -. This is beyond my control!
	echo If the downloads are slow due to a slow sourceforge mirror - cancel the script \(CTL-C\) and run it again.

	# lets initialize waydroid
	mkdir -p ~/waydroid/{images,custom,cache_http,host-permissions,lxc,overlay,overlay_rw,rootfs}
	echo -e "$current_password\n" | sudo mkdir /var/lib/waydroid &> /dev/null
	echo -e "$current_password\n" | sudo -S ln -s ~/waydroid/images /var/lib/waydroid/images &> /dev/null
	echo -e "$current_password\n" | sudo -S ln -s ~/waydroid/cache_http /var/lib/waydroid/cache_http &> /dev/null

	# place custom overlay files here - key layout, hosts, audio.rc etc etc
	# copy fixed key layout for Steam Controller
	echo -e "$current_password\n" | sudo -S mkdir -p /var/lib/waydroid/overlay/system/usr/keylayout
	echo -e "$current_password\n" | sudo -S cp extras/Vendor_28de_Product_11ff.kl /var/lib/waydroid/overlay/system/usr/keylayout/

	# copy custom audio.rc patch to lower the audio latency
	echo -e "$current_password\n" | sudo -S mkdir -p /var/lib/waydroid/overlay/system/etc/init
	echo -e "$current_password\n" | sudo -S cp extras/audio.rc /var/lib/waydroid/overlay/system/etc/init/

	# copy custom hosts file from StevenBlack to block ads (adware + malware + fakenews + gambling + pr0n)
	echo -e "$current_password\n" | sudo -S mkdir -p /var/lib/waydroid/overlay/system/etc
	echo -e "$current_password\n" | sudo -S cp extras/hosts /var/lib/waydroid/overlay/system/etc

	# copy nodataperm.sh - this is to fix the scoped storage issue in Android 11
	chmod +x extras/nodataperm.sh
	echo -e "$current_password\n" | sudo -S cp extras/nodataperm.sh /var/lib/waydroid/overlay/system/etc

	Choice=$(zenity --width 1040 --height 320 --list --radiolist --multiple \
		--title "SteamOS Waydroid Installer  - https://github.com/ryanrudolfoba/SteamOS-Waydroid-Installer"\
		--column "Select One" \
		--column "Option" \
		--column="Description - Read this carefully!"\
		TRUE A13_GAPPS "Download official Android 13 image with Google Play Store."\
		FALSE A13_NO_GAPPS "Download official Android 13 image without Google Play Store."\
		FALSE TV13_NO_GAPPS "Download unofficial Android 13 TV image without Google Play Store - thanks SupeChicken666 for the build instructions!" \
		FALSE EXIT "***** Exit this script *****")

		if [ $? -eq 1 ] || [ "$Choice" == "EXIT" ]
		then
			echo User pressed CANCEL / EXIT. Goodbye!
			cleanup_exit

		elif [ "$Choice" == "A13_GAPPS" ]
		then
			echo Initializing Waydroid.
			echo -e "$current_password\n" | sudo -S waydroid init -s GAPPS
			check_waydroid_init

		elif [ "$Choice" == "A13_NO_GAPPS" ]
		then
			echo Initializing Waydroid.
			echo -e "$current_password\n" | sudo -S waydroid init
			check_waydroid_init

		elif [ "$Choice" == "TV13_NO_GAPPS" ]
		then
			prepare_custom_image_location
			download_image $ANDROID13_TV_IMG $ANDROID13_TV_IMG_HASH ~/waydroid/custom/android13tv "Android 13 TV"

			echo Applying fix for Leanback Keyboard.
			echo -e "$current_password\n" | sudo -S cp extras/ATV-Generic.kl /var/lib/waydroid/overlay/system/usr/keylayout/Generic.kl

			echo Initializing Waydroid.
 			echo -e "$current_password\n" | sudo -S waydroid init
			check_waydroid_init
			
		fi
	
	# run casualsnek / aleasto waydroid_script
	echo Install libndk, widevine and fingerprint spoof.
	install_android_extras

	# change GPU rendering to use minigbm_gbm_mesa
	echo -e $PASSWORD\n | sudo -S sed -i "s/ro.hardware.gralloc=.*/ro.hardware.gralloc=minigbm_gbm_mesa/g" /var/lib/waydroid/waydroid_base.prop

	echo "Adding shortcuts to Game Mode. Please wait..."

	logged_in_user=$(whoami)
	logged_in_home=$(eval echo "~$logged_in_user")
	launcher_script="${logged_in_home}/Android_Waydroid/Android_Waydroid_Cage.sh"
	icon_path="/usr/share/icons/hicolor/512x512/apps/waydroid.png"

	if [ -f "$launcher_script" ]; then
		chmod +x "$launcher_script"
	else
		echo "Error: Launcher script '$launcher_script' not found."
	fi

	TMP_DESKTOP="/tmp/waydroid-temp.desktop"
	cat > "$TMP_DESKTOP" << EOF
[Desktop Entry]
Name=Waydroid
Exec=${launcher_script}
Path=${logged_in_home}/Android_Waydroid
Type=Application
Terminal=false
Icon=application-default-icon
EOF

	chmod +x "$TMP_DESKTOP"
	steamos-add-to-steam "$TMP_DESKTOP"
	sleep 3
	echo Waydroid shortcut has been added to Game Mode.

	steamos-add-to-steam /usr/bin/steamos-nested-desktop  &> /dev/null
	sleep 15
	echo steamos-nested-desktop shortcut has been added to Game Mode.

python3 - << 'EOF'
#!/usr/bin/env python3
import os
import re
import struct
import sys

ICON_PATH = "/usr/share/icons/hicolor/512x512/apps/waydroid.png"

def read_cstring(fp):
    chars = []
    while (c := fp.read(1)) and c != b'\x00':
        chars.append(c)
    return b''.join(chars).decode('utf-8', errors='replace')

def parse_binary_vdf(fp):
    stack = [{}]
    while True:
        t = fp.read(1)
        if not t:
            break
        if t == b'\x08':
            if len(stack) > 1:
                stack.pop()
            else:
                break
            continue
        key = read_cstring(fp)
        cur = stack[-1]
        if t == b'\x00':
            new = {}
            cur[key] = new
            stack.append(new)
        elif t == b'\x01':
            cur[key] = read_cstring(fp)
        elif t == b'\x02':
            cur[key] = struct.unpack('<i', fp.read(4))[0]
        elif t == b'\x03':
            cur[key] = struct.unpack('<f', fp.read(4))[0]
        elif t == b'\x07':
            cur[key] = struct.unpack('<Q', fp.read(8))[0]
        elif t == b'\x0A':
            cur[key] = struct.unpack('<q', fp.read(8))[0]
        else:
            raise ValueError(f"Unknown type byte {t} for key '{key}'")
    return stack[0]

def write_cstring(fp, s):
    fp.write(s.encode('utf-8') + b'\x00')

def write_binary_vdf(fp, d):
    for k, v in d.items():
        if isinstance(v, dict):
            fp.write(b'\x00')
            write_cstring(fp, k)
            write_binary_vdf(fp, v)
            fp.write(b'\x08')
        elif isinstance(v, str):
            fp.write(b'\x01')
            write_cstring(fp, k)
            write_cstring(fp, v)
        elif isinstance(v, int):
            fp.write(b'\x02')
            write_cstring(fp, k)
            fp.write(struct.pack('<i', v))
        elif isinstance(v, float):
            fp.write(b'\x03')
            write_cstring(fp, k)
            fp.write(struct.pack('<f', v))
        else:
            raise ValueError(f"Unsupported value type: {type(v)} for key {k}")

def get_steamid3():
    home = os.path.expanduser("~")
    login_paths = [
        os.path.join(home, ".steam", "root", "config", "loginusers.vdf"),
        os.path.join(home, ".local", "share", "Steam", "config", "loginusers.vdf"),
    ]
    print(f"ℹ Checking loginusers.vdf in: {login_paths}")
    vdf_login = next((p for p in login_paths if os.path.isfile(p)), None)
    if not vdf_login:
        print("Could not find loginusers.vdf")
        sys.exit(1)

    with open(vdf_login, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()

    matches = re.findall(r'"(\d{17})"\s*{([^}]+)}', content)
    best = {"steamid64": None, "timestamp": 0}
    for sid, blk in matches:
        ts_match = re.search(r'"Timestamp"\s+"(\d+)"', blk)
        ts = int(ts_match.group(1)) if ts_match else 0
        if re.search(r'"MostRecent"\s+"1"', blk) or ts > best["timestamp"]:
            best = {"steamid64": int(sid), "timestamp": ts}
    if not best["steamid64"]:
        print("No SteamID64 found")
        sys.exit(1)

    steamid3 = best["steamid64"] - 76561197960265728
    return steamid3

def update_icon(shortcuts_path, target_app="Waydroid", icon_path=ICON_PATH):
    print(f"ℹ Updating shortcuts.vdf: {shortcuts_path}")
    if not os.path.isfile(shortcuts_path):
        print(f"Missing shortcuts.vdf: {shortcuts_path}")
        sys.exit(1)

    # Check file permissions and owner
    st = os.stat(shortcuts_path)

    with open(shortcuts_path, "rb") as f:
        data = parse_binary_vdf(f)

    shortcuts = data.get("shortcuts", data)
    for idx, (key, sc) in enumerate(shortcuts.items()):
        if isinstance(sc, dict):
            icon = sc.get("icon", "<no Icon>")
            appname = sc.get("AppName", "<no AppName>")
            exe = sc.get("Exe", "<no Exe>")

    updated = False
    for key, sc in shortcuts.items():
        if isinstance(sc, dict) and sc.get("AppName") == target_app:
            old_icon = sc.get("icon", "<none>")
            sc["icon"] = icon_path
            print(f"   New Icon set to: {icon_path}")
            updated = True
            break

    if not updated:
        print(f"No matching shortcut found for '{target_app}'")
        return

    with open(shortcuts_path, "wb") as f:
        write_binary_vdf(f, data)
        f.write(b'\x08')
        f.flush()
        os.fsync(f.fileno())

    print("shortcuts.vdf successfully updated and saved.")

if __name__ == "__main__":
    steamid3 = get_steamid3()
    home = os.path.expanduser("~")
    shortcuts_vdf = os.path.join(home, f".steam/root/userdata/{steamid3}/config/shortcuts.vdf")
    update_icon(shortcuts_vdf)
EOF

	rm -f "$TMP_DESKTOP"


	# all done lets re-enable the readonly
	echo -e "$current_password\n" | sudo -S steamos-readonly enable
	echo Waydroid has been successfully installed!
fi

# sanity check - re-enable decky loader service if it's installed.
if [ -f $PLUGIN_LOADER ]
then
	echo Re-enabling the Decky Loader plugin loader service.
	echo -e "$current_password\n" | sudo -S systemctl start plugin_loader.service
fi

if zenity --question --text="Do you Want to Return to Gaming Mode?"; then
	steamos-session-select gamescope
fi
