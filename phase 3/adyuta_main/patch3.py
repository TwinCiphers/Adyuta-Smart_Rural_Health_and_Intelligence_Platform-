with open('lib/home_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("name?.isNotEmpty == true ? name : 'Citizen User'", "name?.isNotEmpty == true ? name! : 'Citizen User'")

with open('lib/home_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
