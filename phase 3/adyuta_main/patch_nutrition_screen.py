import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module\lib\features\nutrition\screens\nutrition_screen.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

code = code.replace("import 'food_detail_screen.dart';", "import 'food_detail_screen.dart';\nimport 'food_atlas_research_screen.dart';")

atlas_button = """
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodAtlasResearchScreen())),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.biotech, color: Colors.white, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Clinical Research', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text('Powered by FoodAtlas AI', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
"""

code = re.sub(r'(\)\,\s*\)\,\s*const SizedBox\(height: 32\),)', r'\1' + atlas_button, code, count=1)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
