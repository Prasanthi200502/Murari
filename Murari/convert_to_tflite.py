import tensorflow as tf
import os

def convert():
    model_path = os.path.join("emotion_model", "emotion_model.h5")
    tflite_path = os.path.join("emotion_model", "emotion_model.tflite")

    if not os.path.exists(model_path):
        print(f"❌ Error: Could not find {model_path}")
        return

    print("⏳ Loading Keras model...")
    model = tf.keras.models.load_model(model_path)

    print("⚙️ Converting to TensorFlow Lite (optimized for Raspberry Pi)...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    
    # Optional: Quantize the model for even more performance on Pi
    # converter.optimizations = [tf.lite.Optimize.DEFAULT]
    
    tflite_model = converter.convert()

    with open(tflite_path, "wb") as f:
        f.write(tflite_model)

    print(f"✅ Success! Optimized model saved to: {tflite_path}")
    print("💡 Update emotion_detector.py on your Pi to load this .tflite file using tflite_runtime for faster inference.")

if __name__ == "__main__":
    convert()
