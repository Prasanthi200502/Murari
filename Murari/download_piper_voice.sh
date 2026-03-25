#!/bin/bash
echo "Downloading Piper TTS Telugu voice (te_IN-venkatesh-medium)..."
wget -q --show-progress -O te_IN-venkatesh-medium.onnx https://huggingface.co/rhasspy/piper-voices/resolve/main/te/te_IN/venkatesh/medium/te_IN-venkatesh-medium.onnx
wget -q --show-progress -O te_IN-venkatesh-medium.onnx.json https://huggingface.co/rhasspy/piper-voices/resolve/main/te/te_IN/venkatesh/medium/te_IN-venkatesh-medium.onnx.json
echo "✅ Voice downloaded successfully! app.py is ready to use it."
