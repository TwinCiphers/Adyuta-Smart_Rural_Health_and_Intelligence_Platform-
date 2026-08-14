import pandas as pd
import numpy as np
import tensorflow as tf
from sklearn.preprocessing import LabelEncoder
import json

# 1. Load Data
print("Loading data...")
df = pd.read_csv('data/symptoms.csv')
texts = np.array(df['text'].astype(str).tolist())
labels = df['label'].values

# 2. Encode Labels
label_encoder = LabelEncoder()
encoded_labels = label_encoder.fit_transform(labels)
num_classes = len(label_encoder.classes_)

# Save the label mapping for Android integration
label_mapping = {int(i): label for i, label in enumerate(label_encoder.classes_)}
with open('label_mapping.json', 'w') as f:
    json.dump(label_mapping, f)
print(f"Labels mapped: {label_mapping}")

# 3. Text Vectorization (Important for TFLite)
# We use a simple TextVectorization layer that can be exported with the model
vocab_size = 1000
sequence_length = 20

vectorize_layer = tf.keras.layers.TextVectorization(
    max_tokens=vocab_size,
    output_mode='int',
    output_sequence_length=sequence_length
)
vectorize_layer.adapt(texts)

# 4. Build Model
print("Building model...")
model = tf.keras.Sequential([
    tf.keras.Input(shape=(1,), dtype=tf.string),
    vectorize_layer,
    tf.keras.layers.Embedding(vocab_size, 16),
    tf.keras.layers.GlobalAveragePooling1D(),
    tf.keras.layers.Dense(16, activation='relu'),
    tf.keras.layers.Dense(num_classes, activation='softmax')
])

model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

# 5. Train Model
print("Training model...")
# For this synthetic dataset, we train on all data. In production, split into train/val.

early_stop = tf.keras.callbacks.EarlyStopping(monitor='loss', patience=3, restore_best_weights=True)
model.fit(texts, encoded_labels, epochs=100, verbose=1, callbacks=[early_stop])


# 6. Export to TensorFlow Lite
print("Converting to TFLite...")
converter = tf.lite.TFLiteConverter.from_keras_model(model)
# Enable Select TF ops to support TextVectorization in TFLite

# Apply Post-Training Quantization for Low Latency / Low Bandwidth
converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_ops = [

    tf.lite.OpsSet.TFLITE_BUILTINS, 
    tf.lite.OpsSet.SELECT_TF_OPS
]
tflite_model = converter.convert()

with open('health_classifier.tflite', 'wb') as f:
    f.write(tflite_model)

print("✅ Model successfully trained and exported to health_classifier.tflite")
print("✅ Label mapping saved to label_mapping.json")
