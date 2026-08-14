import os

modules = [
    "health_classifier", 
    "safety_classifier", 
    "governance_classifier", 
    "education_classifier"
]

for mod in modules:
    file_path = f"{mod}/train.py"
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 1. Add EarlyStopping
    content = content.replace("model.fit(texts, encoded_labels, epochs=30, verbose=1)",
"""
early_stop = tf.keras.callbacks.EarlyStopping(monitor='loss', patience=3, restore_best_weights=True)
model.fit(texts, encoded_labels, epochs=50, verbose=1, callbacks=[early_stop])
""")
    
    # 2. Add Quantization
    content = content.replace("converter.target_spec.supported_ops = [",
"""
# Apply Post-Training Quantization for Low Latency / Low Bandwidth
converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.target_spec.supported_ops = [
""")

    # 3. Fix pandas 3.0 incompatibility just in case
    content = content.replace("texts = df['text'].values", "texts = df['text'].astype(str).values.tolist()")

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

# 4. Update Agriculture script for Quantization
ag_path = "agriculture_classifier/train.py"
with open(ag_path, 'r', encoding='utf-8') as f:
    ag_content = f.read()

ag_content = ag_content.replace("converter = tf.lite.TFLiteConverter.from_keras_model(model)",
"""
converter = tf.lite.TFLiteConverter.from_keras_model(model)
# Apply Post-Training Quantization for Low Latency / Low Bandwidth
converter.optimizations = [tf.lite.Optimize.DEFAULT]
""")
ag_content = ag_content.replace("epochs=3", "epochs=5") # slightly more training

with open(ag_path, 'w', encoding='utf-8') as f:
    f.write(ag_content)

print("✅ All training scripts updated with PTQ Quantization and advanced training parameters!")
