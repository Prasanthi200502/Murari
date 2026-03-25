#!/bin/bash
# ======================================================================
# Murari AI - One-Click Raspberry Pi Installer
# This script turns your Raspberry Pi into a dedicated standalone "Murari OS".
# It completely automates the installation of the AI brain, voice,
# camera dependencies, and configures it to start automatically on boot.
# ======================================================================

echo "=========================================================="
echo "  🚀 Starting Murari AI Auto-Install for Raspberry Pi 🚀  "
echo "=========================================================="

# 1. Update system & Install core dependencies
echo ""
echo "[1/6] Updating system and installing required packages..."
sudo apt-get update
sudo apt-get install -y python3-pip python3-venv wget curl libgl1-mesa-glx libglib2.0-0

# 2. Install Ollama (The AI Brain)
echo ""
echo "[2/6] Installing Ollama Engine..."
if ! command -v ollama &> /dev/null; then
    curl -fsSL https://ollama.com/install.sh | sh
else
    echo "✅ Ollama is already installed."
fi

# 3. Start Ollama and download the LLM
echo ""
echo "[3/6] Downloading Qwen 1.5B AI Brain (This may take a few minutes)..."
sudo systemctl start ollama
sleep 3
# Run and pass 'bye' to exit immediately after downloading
echo "/bye" | ollama run qwen2.5:1.5b

# 4. Download Piper Voice (Telugu)
echo ""
echo "[4/6] Downloading offline Telugu Voice..."
wget -q --show-progress -O te_IN-venkatesh-medium.onnx https://huggingface.co/rhasspy/piper-voices/resolve/main/te/te_IN/venkatesh/medium/te_IN-venkatesh-medium.onnx
wget -q --show-progress -O te_IN-venkatesh-medium.onnx.json https://huggingface.co/rhasspy/piper-voices/resolve/main/te/te_IN/venkatesh/medium/te_IN-venkatesh-medium.onnx.json

# 5. Set up Python Environment
echo ""
echo "[5/6] Creating Python Virtual Environment & Installing libraries..."
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 6. Setup Auto-Start (systemd service)
echo ""
echo "[6/6] Configuring Murari to start automatically when Raspberry Pi turns on..."
SERVICE_PATH="/etc/systemd/system/murari.service"
CURRENT_DIR=$(pwd)
USER_NAME=$(whoami)

sudo bash -c "cat > $SERVICE_PATH" << EOL
[Unit]
Description=Murari AI Standalone Server
After=network.target ollama.service

[Service]
User=$USER_NAME
WorkingDirectory=$CURRENT_DIR
Environment="PATH=$CURRENT_DIR/venv/bin:/usr/bin"
# Run Gunicorn for better stability on Raspberry Pi instead of just python app.py
ExecStart=$CURRENT_DIR/venv/bin/gunicorn -b 0.0.0.0:5000 app:app --workers 1 --timeout 120
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Reload and enable the service
sudo systemctl daemon-reload
sudo systemctl enable murari.service
sudo systemctl restart murari.service

echo ""
echo "=========================================================="
echo " 🎉 INSTALLATION COMPLETE! 🎉"
echo "=========================================================="
echo "Your Raspberry Pi is now essentially a standalone 'Murari' device."
echo "Whenever you plug it in and turn it on, Murari AI will start in the background."
echo ""
echo "📱 You can access it on this device at: http://localhost:5000"
echo "🌐 Or from any device on your Wi-Fi at: http://$(hostname -I | awk '{print $1}'):5000"
echo "=========================================================="
