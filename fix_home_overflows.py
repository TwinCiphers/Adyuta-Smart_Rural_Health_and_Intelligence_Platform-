import re

file_path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\adyuta_main\lib\home_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix 1: _buildSyncStatus Live Data Mode
target1 = """            Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                GlobalBhashiniText('Live Data Mode', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
              ],
            ),"""
replacement1 = """            Expanded(
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
            ),"""
content = content.replace(target1, replacement1)

# Fix 2: _buildSyncStatus Connected & Synced
target2 = """              child: Row(
                children: [
                  const Icon(Icons.cloud_done, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  GlobalBhashiniText('Connected & Synced', style: GoogleFonts.inter(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),"""
replacement2 = """              child: Row(
                mainAxisSize: MainAxisSize.min,
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
              ),"""
content = content.replace(target2, replacement2)

# Fix 3: Recent Notifications title
target3 = """          title: Row(
            children: [
              const Icon(Icons.notifications_active, color: Color(0xFFE65100)),
              const SizedBox(width: 10),
              GlobalBhashiniText('Recent Notifications', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),"""
replacement3 = """          title: Row(
            children: [
              const Icon(Icons.notifications_active, color: Color(0xFFE65100)),
              const SizedBox(width: 10),
              Expanded(child: GlobalBhashiniText('Recent Notifications', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18), overflow: TextOverflow.ellipsis)),
            ],
          ),"""
content = content.replace(target3, replacement3)

# Fix 4: _NotificationItem title and time
target4 = """            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlobalBhashiniText(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                GlobalBhashiniText(time, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),"""
replacement4 = """            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: GlobalBhashiniText(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 8),
                GlobalBhashiniText(time, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),"""
content = content.replace(target4, replacement4)

# Fix 5: b.t('Recent Activity') and b.t('Our Services') if they are in unconstrained rows?
target5 = """                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlobalBhashiniText(b.t('Recent Activity'), style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Icon(Icons.history, color: Colors.grey.shade600, size: 20),
                  ],
                ),"""
replacement5 = """                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: GlobalBhashiniText(b.t('Recent Activity'), style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87), overflow: TextOverflow.ellipsis)),
                    Icon(Icons.history, color: Colors.grey.shade600, size: 20),
                  ],
                ),"""
content = content.replace(target5, replacement5)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed flex layout overflows.")
