#!/bin/bash
# Raspberry Pi FPGA Programmer - Automated Installation Script
# For Digilent Adept Runtime and Utilities on ARM64/ARMHF Raspberry Pi
# 
# Usage: curl -fsSL https://raw.githubusercontent.com/TheVoltageVikingRam/rpi-fpga-programmer/main/install.sh | bash

set -e

echo "🚀 Raspberry Pi FPGA Programming Station Setup"
echo "=============================================="
echo "Installing Digilent Adept Runtime and Utilities"
echo ""

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
sudo apt --fix-broken install -y >/dev/null 2>&1

# Remove problematic Docker repository if it exists
if [ -f /etc/apt/sources.list.d/docker.list ]; then
    echo "🗑️  Removing problematic Docker repository..."
    sudo rm -f /etc/apt/sources.list.d/docker.list
fi

sudo apt update

# Install dependencies
echo "📦 Installing dependencies..."
sudo apt install -y \
    wget \
    libusb-1.0-0 \
    libftdi1-2 \
    libc6 2>/dev/null || true

# For armhf on arm64, install multiarch support
if [[ "$ARCH" == "arm64" ]]; then
    echo "📦 Enabling multiarch support for better compatibility..."
    sudo dpkg --add-architecture armhf
    sudo apt update
    sudo apt install -y libc6:armhf libstdc++6:armhf libusb-1.0-0:armhf 2>/dev/null || true
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "⬇️  Searching for available Digilent packages..."

# Function to find working runtime version
find_working_runtime() {
    local arch=$1
    local versions=("2.27.9" "2.26.1" "2.25.0" "2.24.1" "2.23.1" "2.22.0" "2.21.2" "2.20.1" "2.19.2" "2.18.3" "2.17.1" "2.16.6" "2.16.1")
    
    for ver in "${versions[@]}"; do
        local url="https://digilent.s3.amazonaws.com/Software/Adept2Runtime/$ver/digilent.adept.runtime_$ver-$arch.deb"
        if wget --spider -q "$url" 2>/dev/null; then
            echo "$ver"
            return 0
        fi
    done
    return 1
}

# Download appropriate packages based on architecture
if [[ "$ARCH" == "arm64" ]]; then
    echo "🔍 Finding available runtime version for arm64..."
    
    # First try to find arm64 runtime
    RUNTIME_VERSION=$(find_working_runtime "arm64")
    
    if [ -n "$RUNTIME_VERSION" ]; then
        echo "✅ Found arm64 runtime version: $RUNTIME_VERSION"
        RUNTIME_URL="https://digilent.s3.amazonaws.com/Software/Adept2Runtime/$RUNTIME_VERSION/digilent.adept.runtime_$RUNTIME_VERSION-arm64.deb"
        RUNTIME_FILE="digilent.adept.runtime_$RUNTIME_VERSION-arm64.deb"
        UTILITIES_URL="https://digilent.s3.amazonaws.com/Software/AdeptUtilities/2.7.1/digilent.adept.utilities_2.7.1-arm64.deb"
        UTILITIES_FILE="digilent.adept.utilities_2.7.1-arm64.deb"
    else
        echo "⚠️  No arm64 runtime found. Using armhf packages with multiarch..."
        RUNTIME_VERSION=$(find_working_runtime "armhf")
        
        if [ -z "$RUNTIME_VERSION" ]; then
            echo "❌ No compatible runtime version found for ARM"
            exit 1
        fi
        
        echo "✅ Found armhf runtime version: $RUNTIME_VERSION"
        RUNTIME_URL="https://digilent.s3.amazonaws.com/Software/Adept2Runtime/$RUNTIME_VERSION/digilent.adept.runtime_$RUNTIME_VERSION-armhf.deb"
        RUNTIME_FILE="digilent.adept.runtime_$RUNTIME_VERSION-armhf.deb"
        UTILITIES_URL="https://digilent.s3.amazonaws.com/Software/AdeptUtilities/2.7.1/digilent.adept.utilities_2.7.1-armhf.deb"
        UTILITIES_FILE="digilent.adept.utilities_2.7.1-armhf.deb"
    fi
else
    # armhf architecture
    echo "🔍 Finding available runtime version for armhf..."
    RUNTIME_VERSION=$(find_working_runtime "armhf")
    
    if [ -z "$RUNTIME_VERSION" ]; then
        echo "❌ No compatible runtime version found for armhf"
        exit 1
    fi
    
    echo "✅ Found armhf runtime version: $RUNTIME_VERSION"
    RUNTIME_URL="https://digilent.s3.amazonaws.com/Software/Adept2Runtime/$RUNTIME_VERSION/digilent.adept.runtime_$RUNTIME_VERSION-armhf.deb"
    RUNTIME_FILE="digilent.adept.runtime_$RUNTIME_VERSION-armhf.deb"
    UTILITIES_URL="https://digilent.s3.amazonaws.com/Software/AdeptUtilities/2.7.1/digilent.adept.utilities_2.7.1-armhf.deb"
    UTILITIES_FILE="digilent.adept.utilities_2.7.1-armhf.deb"
fi

# Download packages with progress
echo "  📥 Downloading Adept Runtime v$RUNTIME_VERSION..."
wget -q --show-progress -O "$RUNTIME_FILE" "$RUNTIME_URL"

echo "  📥 Downloading Adept Utilities v2.7.1..."
wget -q --show-progress -O "$UTILITIES_FILE" "$UTILITIES_URL"

# Install packages
echo "📦 Installing Adept Runtime..."
sudo dpkg -i "$RUNTIME_FILE" || {
    echo "⚠️  Fixing dependencies..."
    sudo apt install -f -y
    sudo dpkg -i "$RUNTIME_FILE"
}

echo "📦 Installing Adept Utilities..."
sudo dpkg -i "$UTILITIES_FILE" || {
    echo "⚠️  Fixing dependencies..."
    sudo apt install -f -y
    sudo dpkg -i "$UTILITIES_FILE"
}

# Update library cache
sudo ldconfig

# Set up USB permissions
echo "🔐 Setting up USB permissions..."
sudo usermod -a -G dialout "$USER" 2>/dev/null || true

# Create udev rules
echo "📋 Creating udev rules..."
sudo tee /etc/udev/rules.d/99-digilent.rules > /dev/null << 'RULES_EOF'
# Digilent FPGA boards
SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0666", GROUP="dialout"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="0666", GROUP="dialout"
SUBSYSTEM=="usb", ATTRS{idVendor}=="1443", MODE="0666", GROUP="dialout"
# Digilent USB Serial
SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666", GROUP="dialout"
RULES_EOF

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# Clean up
cd /
rm -rf "$TEMP_DIR"

# Test installation
echo ""
echo "🧪 Testing installation..."
if command -v djtgcfg >/dev/null 2>&1; then
    echo "✅ djtgcfg installed successfully!"
    djtgcfg --version 2>/dev/null || echo "   (Version check requires USB permissions - reboot needed)"
else
    echo "❌ Installation verification failed"
    exit 1
fi

echo ""
echo "✅ Installation completed successfully!"
echo ""
echo "📋 Next Steps:"
echo "1. 🔄 Reboot your Raspberry Pi to apply USB permissions:"
echo "   sudo reboot"
echo ""
echo "2. 🧪 After reboot, test the installation:"
echo "   djtgcfg enum"
echo ""
echo "3. 🔌 Connect your Digilent FPGA board and verify detection"
echo ""
echo "4. 🎯 Program .bit files with:"
echo "   djtgcfg prog -d [DeviceName] -i 0 -f your_design.bit"
echo ""
echo "📚 Common device names:"
echo "   • Arty S7:    ArtyS7"
echo "   • Arty A7:    ArtyA7" 
echo "   • Basys 3:    Basys3"
echo "   • Nexys A7:   NexysA7"
echo "   • Cmod A7:    CmodA7"
echo ""
echo "📖 For more options: djtgcfg --help"
echo ""
echo "🎉 Your Raspberry Pi FPGA Programming Station is ready!"
echo ""

# Ask about reboot
read -p "🔄 Reboot now to apply changes? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔄 Rebooting..."
    sudo reboot
else
    echo "⚠️  Remember to reboot before using: sudo reboot"
fi
