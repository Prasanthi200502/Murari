import urllib.request
import os

def download_file(url, filename):
    print(f"Downloading {filename}...")
    try:
        urllib.request.urlretrieve(url, filename)
        print(f"✅ Successfully downloaded {filename}")
    except Exception as e:
        print(f"❌ Failed to download {filename}: {e}")

if __name__ == "__main__":
    print("=========================================")
    print("Downloading offline Piper Voice for Murari")
    print("=========================================")
    
    download_file(
        "https://huggingface.co/rhasspy/piper-voices/resolve/main/te/te_IN/venkatesh/medium/te_IN-venkatesh-medium.onnx",
        "te_IN-venkatesh-medium.onnx"
    )
    
    download_file(
        "https://huggingface.co/rhasspy/piper-voices/resolve/main/te/te_IN/venkatesh/medium/te_IN-venkatesh-medium.onnx.json",
        "te_IN-venkatesh-medium.onnx.json"
    )
    
    print("All done! You can now run python app.py")
