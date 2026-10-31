import re

with open('lib/home_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

content = "import 'package:adyuta_main/chat/ui/chat_screen.dart';\n" + content
content = content.replace('_showAIChatbotModal(context)', 'Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()))')
content = re.sub(r"user\?\.userMetadata\?\['phone'\] \?\? user\?\.phone \?\?", "'' == '' ?", content)
content = content.replace("Image.asset('assets/images/adyuta_logo.png', height: 120),", "Image.asset('assets/images/aroha_banner.jpg', height: 120),")

with open('lib/home_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Done!")
