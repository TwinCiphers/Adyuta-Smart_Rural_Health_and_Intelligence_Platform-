import os
import re

directories = [
    "phase 3/adyuta_main",
    "phase 3/agri_module",
    "phase 3/education_module",
    "phase 3/governance_module",
    "phase 3/health_module",
    "phase 3/safety_module"
]

base_dir = r"c:\Users\dk-32\OneDrive\Desktop\Adyuta-MP"

def update_pubspec():
    for d in directories:
        pubspec_path = os.path.join(base_dir, d, "pubspec.yaml")
        if os.path.exists(pubspec_path):
            with open(pubspec_path, 'r', encoding='utf-8') as f:
                content = f.read()
            if "flutter_screenutil:" not in content:
                content = content.replace("dependencies:\n", "dependencies:\n  flutter_screenutil: ^5.9.3\n")
                with open(pubspec_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"Updated pubspec in {d}")

def add_screen_util_init():
    main_dart_path = os.path.join(base_dir, "phase 3/adyuta_main/lib/main.dart")
    if os.path.exists(main_dart_path):
        with open(main_dart_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        if "ScreenUtilInit" not in content:
            # Need to wrap MaterialApp.router with ScreenUtilInit
            content = content.replace(
                "return MaterialApp.router(",
                "return ScreenUtilInit(\n      designSize: const Size(360, 690),\n      minTextAdapt: true,\n      splitScreenMode: true,\n      builder: (context, child) {\n        return MaterialApp.router("
            )
            # Find the closing of MaterialApp.router and close ScreenUtilInit
            # This is tricky with regex, we can just replace the builder child in MaterialApp
            pass
            
            # actually let's just do a manual replacement in main.dart
            print("Main.dart needs manual update for ScreenUtilInit.")

def process_dart_files():
    # Regexes for dimension replacements
    regex_h = re.compile(r'(height:\s*)([0-9]+(\.[0-9]+)?)(?!\w|\.)')
    regex_w = re.compile(r'(width:\s*)([0-9]+(\.[0-9]+)?)(?!\w|\.)')
    regex_sp = re.compile(r'(fontSize:\s*)([0-9]+(\.[0-9]+)?)(?!\w|\.)')
    regex_r = re.compile(r'(radius:\s*)([0-9]+(\.[0-9]+)?)(?!\w|\.)')
    
    for d in directories:
        lib_dir = os.path.join(base_dir, d, "lib")
        if not os.path.exists(lib_dir): continue
        for root, _, files in os.walk(lib_dir):
            for file in files:
                if file.endswith('.dart'):
                    file_path = os.path.join(root, file)
                    with open(file_path, 'r', encoding='utf-8') as f:
                        original_content = f.read()
                    
                    content = original_content
                    # Replace
                    content = regex_h.sub(r'\1\2.h', content)
                    content = regex_w.sub(r'\1\2.w', content)
                    content = regex_sp.sub(r'\1\2.sp', content)
                    content = regex_r.sub(r'\1\2.r', content)
                    
                    # If changes made, add import
                    if content != original_content:
                        if "flutter_screenutil.dart" not in content:
                            # insert import at top
                            import_stmt = "import 'package:flutter_screenutil/flutter_screenutil.dart';\n"
                            # find first import
                            match = re.search(r'^import .*?;', content, re.MULTILINE)
                            if match:
                                content = content[:match.start()] + import_stmt + content[match.start():]
                            else:
                                content = import_stmt + content
                        
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(content)
                        print(f"Updated {file_path}")

if __name__ == '__main__':
    update_pubspec()
