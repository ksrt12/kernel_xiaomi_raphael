#!/bin/bash
rm .version
# Bash Color
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
export CLANG_PATH=${HOME}/tools/clang/aosp/clang-r353983e/bin
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=${HOME}/tools/gcc/aosp/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=${HOME}/tools/gcc/aosp/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
export LD_LIBRARY_PATH=${HOME}/tools/clang/aosp/clang-r353983e/lib64:$LD_LIBRARY_PATH
DEFCONFIG="raphael_defconfig"

# Kernel Details
VER="R3"

# Paths
KERNEL_DIR=`pwd`
REPACK_DIR="${HOME}/tools/Anykernel3/"
ZIP_MOVE="${HOME}/tools/AK-releases"

# Functions
function clean_all {
		rm -rf $REPACK_DIR/dtbs/*
		rm -rf $REPACK_DIR/Image*
		cd $KERNEL_DIR
		echo
		make clean && make mrproper
}

function make_kernel {
		echo
		make CC=clang $DEFCONFIG
		make CC=clang -j$(grep -c ^processor /proc/cpuinfo)

}


function make_boot {
		cp out/arch/arm64/boot/Image.gz $REPACK_DIR
        	cp out/arch/arm64/boot/dts/qcom/sm8150-v2.dtb $REPACK_DIR/dtbs
		cp out/arch/arm64/boot/dts/qcom/sm8150p.dtb $REPACK_DIR/dtbs
		cp out/arch/arm64/boot/dts/qcom/sm8150.dtb $REPACK_DIR/dtbs
        	cp out/arch/arm64/boot/dts/qcom/sm8150p-v2.dtb $REPACK_DIR/dtbs
}


function make_zip {
		cd $REPACK_DIR
		zip -r9 `echo $ZIP_NAME`.zip *
		mv  `echo $ZIP_NAME`*.zip $ZIP_MOVE
		cd $KERNEL_DIR
}


DATE_START=$(date +"%s")


echo -e "${green}"
echo "-----------------"
echo "Making Kernel:"
echo "-----------------"
echo -e "${restore}"


# Vars
BASE_AK_VER="SOVIET-STAR-"
DATE=`date +"%Y%m%d-%H%M"`
AK_VER="$BASE_AK_VER$VER"
ZIP_NAME="$AK_VER"-"$DATE"
#export LOCALVERSION=~`echo $AK_VER`
#export LOCALVERSION=~`echo $AK_VER`
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=NATO66613
export KBUILD_BUILD_HOST=KREMLIN

echo

while read -p "Do you want to clean stuffs (y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
		clean_all
		echo
		echo "All Cleaned now."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

echo

while read -p "Do you want to build?" dchoice
do
case "$dchoice" in
	y|Y )
		make_kernel
		make_boot
        make_zip
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done


echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo

