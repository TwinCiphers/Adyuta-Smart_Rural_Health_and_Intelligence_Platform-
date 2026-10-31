import re
path = r'C:\Users\dk-32\OneDrive\Desktop\Adyuta-MP\phase 3\health_module\lib\core\widgets\soft_background_layout.dart'
with open(path, 'r', encoding='utf-8') as f:
    code = f.read()

correct = """  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Base Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE6F7F6), // Very light teal/cyan (+3% brightness from original)
                  Color(0xFFF4FDFD),
                  Color(0xFFE2F3F3),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          // Abstract Waves via CustomPainter
          Positioned.fill(
            child: CustomPaint(
              painter: _WavePainter(),
            ),
          ),

          // The main content
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: hasScrollBody
                  ? child
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: child,
                    ),
            ),
          ),
        ],
      ),
    );
  }"""

code = re.sub(r'  @override\s*Widget build\(BuildContext context\) \{[\s\S]*?  \}', correct, code)

with open(path, 'w', encoding='utf-8') as f:
    f.write(code)
