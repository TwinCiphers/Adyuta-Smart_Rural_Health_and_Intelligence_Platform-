const fs = require('fs');
let text = fs.readFileSync('phase 3/adyuta_main/lib/features/authentication/providers/auth_provider.dart', 'utf8');
text = text.replace(/Uri\.parse\(.*signup.*?\)/g, "Uri.parse(\/signup)");
text = text.replace(/Uri\.parse\(.*login.*?\)/g, "Uri.parse(\/login)");
text = text.replace(/Uri\.parse\(.*logout.*?\)/g, "Uri.parse(\/logout)");
text = text.replace(/Bearer.*?token.*?/g, "Bearer \");
text = text.replace(/Exception.*Signup failed.*/g, "Exception(Signup failed: \)");
text = text.replace(/Exception.*Login failed.*/g, "Exception(Login failed: \)");
// Fix weird interpolation issue from before
text = text.replace(/Bearer \\\/g, "Bearer \");
text = text.replace(/\\\/g, "\");
text = text.replace(/\\\/g, "\");
// Strip all backticks to single quotes, except where interpolation happens (dart doesn't use backticks for strings)
text = text.replace(/\$\{(.*?)\}(.*?)/g, "'\1'");

fs.writeFileSync('phase 3/adyuta_main/lib/features/authentication/providers/auth_provider.dart', text);

text = fs.readFileSync('phase 3/adyuta_main/lib/features/dashboard/providers/dashboard_provider.dart', 'utf8');
text = text.replace(/Uri\.parse\(.*dashboard.*?\)/g, "Uri.parse('\/dashboard')");
text = text.replace(/Bearer.*token.*/g, "'Bearer \'");
fs.writeFileSync('phase 3/adyuta_main/lib/features/dashboard/providers/dashboard_provider.dart', text);

text = fs.readFileSync('phase 3/adyuta_main/lib/features/profile/providers/profile_provider.dart', 'utf8');
text = text.replace(/Uri\.parse\(.*profile.*?\)/g, "Uri.parse('\/profile')");
text = text.replace(/Bearer.*token.*/g, "'Bearer \'");
fs.writeFileSync('phase 3/adyuta_main/lib/features/profile/providers/profile_provider.dart', text);

text = fs.readFileSync('phase 3/adyuta_main/lib/features/authentication/screens/mfa_verify_screen.dart', 'utf8');
text = text.replace(/Bearer.*token.*/g, "'Bearer \'");
fs.writeFileSync('phase 3/adyuta_main/lib/features/authentication/screens/mfa_verify_screen.dart', text);
