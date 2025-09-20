#!/bin/bash
# Raspberry Pi FPGA Programmer - Automated Installation Script
# For Digilent Adept Runtime and Utilities on ARM64 Raspberry Pi

set -e

echo "🚀 Raspberry Pi FPGA Programming Station Setup"
echo "=============================================="

# Check if running on Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/device-tree/model 2>/dev/null; then
    echo "⚠️  Warning: This script is designed for Raspberry Pi"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check architecture
ARCH=$(dpkg --print-architecture)
echo "📋 Detected architecture: $ARCH"

if [[ "$ARCH" != "arm64" && "$ARCH" != "armhf" ]]; then
    echo "❌ Unsupported architecture: $ARCH"
    echo "   This script supports arm64 and armhf only."
    exit 1
fi

# Clean up any broken installations
echo "🧹 Cleaning up previous installations..."
sudo dpkg --remove --force-remove-reinstreq digilent.waveforms digilent.adept.runtime digilent.adept.utilities 2>/dev/null || true
sudo apt --fix-broken install -y
sudo apt update

# Install dependencies
echo "📦 Installing dependencies..."
sudo apt install -y \
    wget \
    libqt5multimedia5 \
    libqt5multimedia5-plugins \
    libqt5scripttools5 \
    libqt5serialport5 \
    libqt5widgets5 \
    libqt5gui5 \
    libqt5core5a \
    libqt5svg5 \
    libqt5printsupport5 \
    libqt5network5

# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "⬇️  Downloading Digilent packages..."

# Download appropriate packages based on architecture
if [[ "$ARCH" == "arm64" ]]; then
    RUNTIME_URL="https://digilent.s3.amazonaws.com/Software/Adept2Runtime/2.27.9/digilent.adept.runtime_2.27.9-arm64.deb"
    UTILITIES_URL="https://digilent.s3.amazonaws.com/Software/AdeptUtilities/2.7.1/digilent.adept.utilities_2.7.1-arm64.deb"
    RUNTIME_FILE="digilent.adept.runtime_2.27.9-arm64.deb"
    UTILITIES_FILE="digilent.adept.utilities_2.7.1-arm64.deb"
else
    RUNTIME_URL="https://digilent.s3.amazonaws.com/Software/Adept2Runtime/2.27.9/digilent.adept.runtime_2.27.9-armhf.deb"
    UTILITIES_URL="https://digilent.s3.amazonaws.com/Software/AdeptUtilities/2.7.1/digilent.adept.utilities_2.7.1-armhf.deb"
    RUNTIME_FILE="digilent.adept.runtime_2.27.9-armhf.deb"
    UTILITIES_FILE="digilent.adept.utilities_2.7.1-armhf.deb"
fi

# Download packages
wget -O "$RUNTIME_FILE" "$RUNTIME_URL"
wget -O "$UTILITIES_FILE" "$UTILITIES_URL"

# Install packages
echo "📦 Installing Adept Runtime..."
sudo dpkg -i "$RUNTIME_FILE"

echo "📦 Installing Adept Utilities..."
sudo dpkg -i "$UTILITIES_FILE"

# Fix any dependency issues
sudo apt install -f -y

# Set up USB permissions
echo "🔐 Setting up USB permissions..."
sudo usermod -a -G dialout "$USER"

# Create udev rules
sudo tee /etc/udev/rules.d/99-digilent.rules > /dev/null << 'EOF'
# Digilent FPGA boards
SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0666", GROUP="dialout"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="0666", GROUP="dialout"
SUBSYSTEM=="usb", ATTRS{idVendor}=="1443", MODE="0666", GROUP="dialout"
# Digilent USB Serial
SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666", GROUP="dialout"
EOF

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# Clean up
cd /
rm -rf "$TEMP_DIR"

echo "✅ Installation completed successfully!"
echo ""
echo "📋 Next Steps:"
echo "1. Reboot your Raspberry Pi to apply USB permissions:"
echo "   sudo reboot"
echo ""
echo "2. After reboot, test the installation:"
echo "   djtgcfg enum"
echo ""
echo "3. Connect your Digilent FPGA board and verify detection"
echo ""
echo "4. Program .bit files with:"
echo "   djtgcfg prog -d [DeviceName] -i 0 -f your_design.bit -v"
echo ""
echo "🎉 Your Raspberry Pi FPGA Programming Station is ready!"

# Ask about reboot
echo ""
read -p "Reboot now to apply changes? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo reboot
fi
