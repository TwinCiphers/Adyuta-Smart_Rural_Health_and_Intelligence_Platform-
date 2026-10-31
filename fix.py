import os
files = [
  'phase 3/adyuta_main/lib/features/authentication/providers/auth_provider.dart',
  'phase 3/adyuta_main/lib/features/dashboard/providers/dashboard_provider.dart',
  'phase 3/adyuta_main/lib/features/profile/providers/profile_provider.dart',
  'phase 3/adyuta_main/lib/features/authentication/screens/mfa_verify_screen.dart'
]
for f in files:
    with open(f, 'r', encoding='utf-8') as file:
        c = file.read()
    c = c.replace(\"Uri.parse('_baseUrl\", \"Uri.parse('\\")
    c = c.replace(\"Uri.parse('/dashboard')\", \"Uri.parse('\/dashboard')\")
    c = c.replace(\"Uri.parse('/signup')\", \"Uri.parse('\/signup')\")
    c = c.replace(\"Uri.parse('/login')\", \"Uri.parse('\/login')\")
    c = c.replace(\"Uri.parse('/logout')\", \"Uri.parse('\/logout')\")
    c = c.replace(\"Uri.parse('/profile')\", \"Uri.parse('\/profile')\")
    c = c.replace(\"'Bearer '\", \"'Bearer \'\")
    c = c.replace(\"Exception('Signup failed: {response.body}')\", \"Exception('Signup failed: \')\")
    c = c.replace(\"Exception('Login failed: {response.body}')\", \"Exception('Login failed: \')\")
    with open(f, 'w', encoding='utf-8') as file:
        file.write(c)
