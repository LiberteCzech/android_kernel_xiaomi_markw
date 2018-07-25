#
# Copyright © 2017, "lordarcadius" <vipuljha08@gmail.com>
# Copyright © 2017, "arn4v"
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it

# Color Codes
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White


echo -e "$White***********************************************"
echo "         Compiling RedStar Kernel             "
echo -e "***********************************************$nocol"

LC_ALL=C date +%Y-%m-%d
kernel_dir=$PWD
build=$kernel_dir/out
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE="/home/sonic/kernels/toolchains/aarch64-linux-android-opt/bin/aarch64-opt-linux-android-"
kernel="RedStar"
version="1.0"
vendor="xiaomi"
android="TREBLE"
device="markw"
zip=zip
date=`date +"%Y%m%d-%H%M"`
config=markw_defconfig
kerneltype="Image.gz-dtb"
jobcount="-j$(grep -c ^processor /proc/cpuinfo)"
zip_name="$kernel"-"$version"-"$date"-"$android"-"$device".zip
export KBUILD_BUILD_USER=SonicBSV
export KBUILD_BUILD_HOST=RUS

echo "Checking for build..."
if [ -d arch/arm64/boot/"$kerneltype" ]; then
	read -p "Previous build found, clean working directory..(y/n)? : " cchoice
	case "$cchoice" in
		y|Y )
			rm -rf out
			mkdir out
			make clean && make mrproper
			echo "Working directory cleaned...";;
		n|N )
			echo "Starting dirty build!";;
		* )
			echo "Invalid...";;
	esac
	read -p "Begin build now..(y/n)? : " dchoice
	case "$dchoice" in
		y|Y)
			make "$config"
			make "$jobcount"
			exit 0;;

		n|N )
			exit 0;;
		* )
			echo "Invalid...";;
	esac
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$Green Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
fi
echo "Extracting files..."
if [ -f arch/arm64/boot/"$kerneltype" ]; then
	cp arch/arm64/boot/"$kerneltype" "$zip"/"$kerneltype"
else
	echo "Nothing has been made..."
	read -p "Clean working directory..(y/n)? : " achoice
	case "$achoice" in
		y|Y )
                        rm -rf out
                        mkdir out
                        make clean && make mrproper
                        echo "Working directory cleaned...";;
		n|N )
			echo "Starting dirty build!";;
		* )
			echo "Invalid...";;
	esac
	read -p "Begin build now..(y/n)? : " bchoice
	case "$bchoice" in
		y|Y)
			make "$config"
			make "$jobcount"
			exit 0;;
		n|N )
			exit 0;;
		* )
			echo "Invalid...";;
	esac
fi

echo "Zipping..."
if [ -f "$zip"/"$kerneltype" ]; then
	cd "$zip"
	zip -r ../$zip_name .
	mv ../$zip_name $build
	rm "$kerneltype"
	cd ..
	rm -rf arch/arm64/boot/"$kerneltype"
	export outdir=""$build""
        export out=""$build""
        export OUT=""$build""
	echo "$BluePackage complete: "$build"/"$zip_name"$nocol"
	exit 0;
else
	echo "No $kerneltype found..."
	exit 0;
fi
# Export script by Savoca
# Thank You Savoca!
