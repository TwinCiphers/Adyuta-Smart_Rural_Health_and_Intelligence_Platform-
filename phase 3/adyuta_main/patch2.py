with open('lib/home_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("user?.userMetadata?['full_name'] ?? user?.userMetadata?['name']", "user?.name")
content = content.replace("user?.phone", "''")

with open('lib/home_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
