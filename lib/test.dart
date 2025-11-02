
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ayush — Futuristic Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  late AnimationController _glowController;
  final Flutter3DController controller = Flutter3DController();

  final String displayName = 'Ayush Pandey';
  final String role = 'AI · Robotics · Space-Tech Developer';
  final String shortBio =
  '''Building intelligent systems that merge AI, robotics, and embedded technology.
       Passionate about coding in C++ and Python, exploring robotics hardware, 
       and innovating in quant trading. Driven to launch impactful companies and 
       design futuristic digital experiences that shape the future.''';

  final skills = [
    // Programming Languages
    'Python',
    'C++',

    // Robotics & AI
    'ROS (Robot Operating System)',
    'Robotics Development',
    '3D Modeling & Simulation',
    'TensorFlow',

    // Software & Platforms
    'Flutter / Dart',
    'Linux'
  ];


  final List<Map<String, String>> projects = [
    {
      'title': 'Aether Rover',
      'desc':
      'A Mars-inspired rover with autonomous navigation and real-time SLAM mapping using ROS2.',
      'link': 'https://github.com/demo/aether_rover'
    },
    {
      'title': 'NeuralPilot AI',
      'desc':
      'Drone autopilot system built in Rust with reinforcement learning flight control.',
      'link': 'https://github.com/demo/neuralpilot'
    },
    {
      'title': 'FarmYara',
      'desc':
      'Smart agriculture app for farmers, built with Flutter and Firebase, integrating IoT sensors.',
      'link': 'https://github.com/demo/farmyara'
    }
  ];

  @override
  void initState() {
    super.initState();
    _glowController =
    AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // -------------------- BUILD --------------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 700;
    final isTablet = size.width >= 700 && size.width < 1100;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            right: 20,
            child: Image.asset('assets/bg.png', fit: BoxFit.contain),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, _) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(-0.3, -0.5),
                      radius: 1.2,
                      colors: [
                        Colors.blueAccent
                            .withOpacity(0.06 + 0.03 * _glowController.value),
                        Colors.purpleAccent
                            .withOpacity(0.1 + 0.04 * (1 - _glowController.value)),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isMobile, isTablet),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 4,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, _) {
                          double value = 0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                          }
                          value = value.clamp(-1, 1);

                          final transform = Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(value * -1.2)
                            ..scale(1 - (value.abs() * 0.1));

                          return Transform(
                            alignment: Alignment.center,
                            transform: transform,
                            child: Opacity(
                              opacity: (1 - value.abs()).clamp(0.2, 1),
                              child: _buildPageByIndex(index, size, isMobile),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- HEADER --------------------
  Widget _buildHeader(bool isMobile, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNameRole(),
                _buildNavButtons(isMobile),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameRole(),
                const SizedBox(height: 10),
                _buildNavButtons(isMobile),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNameRole() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFF00F0FF), Color(0xFF7B61FF)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(Icons.adb_rounded, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayName,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(role,
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        )
      ],
    );
  }

  Widget _buildNavButtons(bool isMobile) {
    final buttons = [
      _navButton('About', 0),
      _navButton('Skills', 1),
      _navButton('Projects', 2),
      _navButton('Contact', 3),
    ];

    return isMobile
        ? Wrap(spacing: 6, runSpacing: 6, children: buttons)
        : Row(children: buttons);
  }

  Widget _navButton(String label, int pageIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white12,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
        onPressed: () => _pageController.animateToPage(pageIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  // -------------------- PAGES --------------------
  Widget _buildPageByIndex(int index, Size size, bool isMobile) {
    switch (index) {
      case 0:
        return _buildAboutPage(size, isMobile);
      case 1:
        return _buildSkillsPage();
      case 2:
        return _buildProjectsPage();
      case 3:
        return _buildContactPage();
      default:
        return const SizedBox.shrink();
    }
  }

  // -------------------- ABOUT PAGE --------------------
  Widget _buildAboutPage(Size size, bool isMobile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Center(
        child: isMobile
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * 0.8,
              height: size.height * 0.35,
              child: _build3DViewer(),
            ),
            const SizedBox(height: 20),
            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('About',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(shortBio,
                      style: const TextStyle(fontSize: 13, height: 1.5)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _statTile('Years', '3+'),
                      _statTile('Projects', '15'),
                      _statTile('Talks', '4'),
                    ],
                  )
                ],
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: size.width * 0.4,
                height: size.height * 0.7,
                child: _build3DViewer()),
            const SizedBox(width: 20),
            Expanded(
              child: _glassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('About',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(shortBio,
                        style: const TextStyle(fontSize: 14, height: 1.5)),
                    const SizedBox(height: 14),
                    const Text('Quick Stats',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _statTile('Years', '3+'),
                        _statTile('Projects', '15'),
                        _statTile('Talks', '4'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statTile(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _build3DViewer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: ModelViewer(
        src: 'assets/models/yush.glb',
        alt: "3D Portfolio Model",
        autoPlay: true,           // Automatically plays animation if present
        cameraControls: true,     // Allows mouse/touch rotation
        ar: false,                // Set to true if you want AR mode on mobile
        disableZoom: false,       // Allow zooming
        autoRotate: true,         // Slowly rotate the model for showcase
        backgroundColor: Colors.transparent,
      ),
    );
  }

  // -------------------- SKILLS PAGE --------------------
  Widget _buildSkillsPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: _glassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Skills',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                skills.map((s) => Chip(label: Text(s))).toList(growable: false),
              ),
              const SizedBox(height: 18),
              const Text('Tech Focus',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                  'Currently exploring: Quantum Robotics, Neural Hardware Acceleration, and Rust-based Embedded Systems.'),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------- PROJECTS PAGE --------------------
  Widget _buildProjectsPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: _glassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Projects',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...projects.map(
                    (p) => ListTile(
                  title: Text(p['title']!),
                  subtitle: Text(p['desc']!),
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () => _openUrl(p['link']!),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _openUrl('https://github.com/demo'),
                icon: const Icon(Icons.code),
                label: const Text('View more on GitHub'),
              )
            ],
          ),
        ),
      ),
    );
  }

  // -------------------- CONTACT PAGE --------------------
  Widget _buildContactPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: _glassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Contact',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                  '''Let’s collaborate on robotics, AI, and evolving software technologies. I love experimenting, solving technical challenges, and creating futuristic solutions alongside like-minded people.'''),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () =>
                    _openUrl('mailto:ayush@example.com?subject=Portfolio%20Inquiry'),
                icon: const Icon(Icons.email_outlined),
                label: const Text('Email Me'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _openUrl('https://linkedin.com/in/demo'),
                icon: const Icon(Icons.business_center),
                label: const Text('LinkedIn'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------- GLASS CARD --------------------
  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}

