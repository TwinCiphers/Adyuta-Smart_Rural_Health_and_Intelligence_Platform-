import pandas as pd
import numpy as np
import tensorflow as tf
from sklearn.preprocessing import LabelEncoder
import json

print("Loading data...")
df = pd.read_csv('data/safety_queries.csv')
texts = np.array(df['text'].astype(str).tolist())
labels = df['label'].values

label_encoder = LabelEncoder()
encoded_labels = label_encoder.fit_transform(labels)
num_classes = len(label_encoder.classes_)

label_mapping = {int(i): label for i, label in enumerate(label_encoder.classes_)}
with open('label_mapping.json', 'w') as f:
    json.dump(label_mapping, f)

vocab_size = 1000
sequence_length = 20

vectorize_layer = tf.keras.layers.TextVectorization(
    max_tokens=vocab_size, output_mode='int', output_sequence_length=sequence_length)
vectorize_layer.adapt(texts)

print("Building model...")
model = tf.keras.Sequential([
    tf.keras.Input(shape=(1,), dtype=tf.string),
    vectorize_layer,
    tf.keras.layers.Embedding(vocab_size, 16),
    tf.keras.layers.GlobalAveragePooling1D(),
    tf.keras.layers.Dense(16, activation='relu'),
    tf.keras.layers.Dense(num_classes, activation='softmax')
])

model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
print("Training model...")

early_stop = tf.keras.callbacks.EarlyStopping(monitor='loss', patience=3, restore_best_weights=True)
model.fit(texts, encoded_labels, epochs=100, verbose=1, callbacks=[early_stop])


print("Converting to TFLite...")
converter = tf.lite.TFLiteConverter.from_keras_model(model)

# Apply Post-Training Quantization for Low Latency / Low Bandwidth
converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_ops = [
tf.lite.OpsSet.TFLITE_BUILTINS, tf.lite.OpsSet.SELECT_TF_OPS]
tflite_model = converter.convert()

with open('safety_classifier.tflite', 'wb') as f:
    f.write(tflite_model)

print("✅ Model successfully trained and exported to safety_classifier.tflite")
