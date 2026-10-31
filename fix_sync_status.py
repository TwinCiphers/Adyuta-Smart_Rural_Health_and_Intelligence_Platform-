import re

file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\adyuta_main\lib\home_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace _buildSyncStatus entirely
target_pattern = r"Widget _buildSyncStatus\(BuildContext context\) \{.*?\}(?=\s*Widget _buildServiceGrid)"

replacement = """Widget _buildSyncStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Flexible(
                  child: GlobalBhashiniText(
                    'Live Data Mode',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_done, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  Flexible(
                    child: GlobalBhashiniText(
                      'Connected & Synced',
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }"""

new_content = re.sub(target_pattern, replacement, content, flags=re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(new_content)

print("Replaced _buildSyncStatus")
