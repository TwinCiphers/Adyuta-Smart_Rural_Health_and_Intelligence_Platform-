import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module\lib\features\directory\repositories\realtime_directory_service.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

replacement = """        facilities.add(Facility(
          id: int.tryParse(el['id'].toString()) ?? 0,
          name: name,
          type: tags['amenity'] == 'clinic' ? 'Clinic' : 'Hospital',
          system: 'Allopathic',
          address: address,
          phone: tags['phone'] ?? '108',
          workingHours: tags['opening_hours'] ?? '24/7',
          is24x7: tags['emergency'] == 'yes' ? 1 : 0,
        ));"""

code = re.sub(r"facilities\.add\(Facility\([\s\S]*?\)\);", replacement, code)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
