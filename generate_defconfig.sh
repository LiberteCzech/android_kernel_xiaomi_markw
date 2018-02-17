export ARCH=arm64
export SUBARCH=arm64
make mido_defconfig
cp .config arch/arm64/configs/mido_defconfig
