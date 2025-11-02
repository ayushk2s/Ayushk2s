import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:my_portfolio/skill_extra.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ayush',
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
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  late AnimationController _glowController;
  final Flutter3DController controller = Flutter3DController();


  // Boot overlay
  int _bootStep = 0;

  // hologram scan animation
  late AnimationController _scanController;

  final String displayName = 'Ayush Pandey';
  final String role = 'AI · Robotics · Space-Tech Developer';
  final String shortBio =
  '''Ayush Pandey — 18-year-old Innovator (2025)
Building intelligent systems that merge AI, robotics, and embedded technology. Passionate about C++ and Python, developing autonomous hardware, and innovating in quantitative trading. Entrepreneur at heart — already building apps, experimenting with defense-tech concepts, and creating futuristic digital experiences. Driven to launch impactful companies and shape a world where technology empowers human potential.''';


  final List<Map<String, String>> projects = [
    {
      'title': 'FarmYara',
      'desc':
      'A smart agriculture platform built with Flutter, Dart & Firebase — empowering farmers with crop insights, resource optimization & integrated Google Maps support.',
      'link': 'https://play.google.com/store/apps/details?id=com.global.farmyara&hl=en_IN',
    },
    {
      'title': 'DCA-Leverage Algorithm Simulator',
      'desc':
      'A dynamic averaging & leverage optimization algorithm designed to reduce liquidation risk and improve overall position safety in volatile crypto markets.',
      'link': 'https://github.com/ayushk2s/Best-Averaging-And-Leveraging',
    },
    {
      'title': 'RoDo',
      'desc':
      'An autonomous human-detection robot capable of real-time distance measurement — geared towards surveillance, robotics research & safety automation.',
      'link': 'https://github.com/ayushk2s/RoDo',
    },
    {
      'title': 'VryptDex',
      'desc':
      'A next-gen cryptocurrency exchange (in development) focused on ultra-low-latency order execution, institutional-grade security & high-frequency trading support.',
      'link': 'https://github.com/demo/vryptdex',
    },
    {
      'title': 'MoviePaglu',
      'desc':
      'A fast & user-friendly movie discovery platform — enabling advanced search and direct downloads across multiple genres and languages.',
      'link': 'https://github.com/ayushk2s/moviepaglu',
    },
    {
      'title': 'XRP Arbitrage Bot',
      'desc':
      'A fully automated arbitrage system for XRP, capturing real-time inefficiencies between spot-to-spot and futures-to-futures markets.',
      'link': 'https://github.com/ayushk2s/spot_trade_xrp',
    },
    {
      'title': 'MEXC · Deribit · HitBTC API Suite',
      'desc':
      'A secure & efficient multi-exchange API toolkit providing order execution, account automation & market data access.',
      'link': 'https://github.com/ayushk2s/MEXC-Deribit-HitBTC-',
    },
    {
      'title': 'Bollinger Bands Trading Strategy',
      'desc':
      'A precision-based automated trading bot leveraging Bollinger Bands for optimal long/short entry decisions with risk-managed exits.',
      'link': 'https://github.com/ayushk2s/Bollinger-Band-Trading-Stratagy',
    },
    {
      'title': 'Python Trading Strategy Suite',
      'desc':
      'A collection of Python-based algorithmic strategies using technical indicators for high-accuracy execution & backtesting.',
      'link': 'https://github.com/ayushk2s/Python-trading-strategy',
    },
    {
      'title': 'Wisdom Capital API + Algo Strategies',
      'desc':
      'Robust API utilities and semi-automated algorithmic strategies developed for the Wisdom Capital brokerage ecosystem.',
      'link': 'https://github.com/ayushk2s/Wisdom-Capital-',
    },
  ];

  @override
  void initState() {
    super.initState();

    _glowController =
    AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);

    _scanController =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();


  }


  @override
  void dispose() {
    _pageController.dispose();
    _glowController.dispose();
    _scanController.dispose();
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
          // Background image
          Positioned.fill(
            right: 20,
            child: Image.asset('assets/bg.png', fit: BoxFit.contain),
          ),

          // Glow gradient
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
                        Colors.cyanAccent
                            .withOpacity(0.08 + 0.03 * (1 - _glowController.value)),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Particle field (subtle)
          const Positioned.fill(child: ParticleField()),

          // Safe area + main layout
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isMobile, isTablet),
                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: 4,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (i) {
                          // play small sound & trigger scan
                          _scanController.forward(from: 0);
                        },
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
                                  child: Stack(
                                    children: [
                                      _buildPageByIndex(index, size, isMobile),
                                      // hologram scan overlay for page
                                      Positioned.fill(
                                        child: HologramScan(
                                          controller: _scanController,
                                          active: (_pageController.hasClients &&
                                              (_pageController.page ?? 0).round() == index),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      // Floating assistant bot
                      FloatingBot(onTap: _onBotTap),

                      // Boot overlay (when app opens)
                    ],
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

    return isMobile ? Wrap(spacing: 6, runSpacing: 6, children: buttons) : Row(children: buttons);
  }

  Widget _navButton(String label, int pageIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
        onPressed: () {
          _pageController.animateToPage(pageIndex, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
        },
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
              width: size.width * 0.9,
              height: size.height * 0.36,
              child: _build3DViewer(),
            ),
            const SizedBox(height: 20),
            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('About',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(shortBio, style: const TextStyle(fontSize: 13, height: 1.5)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _statTile('Years', '4+'),
                      _statTile('Projects', '15+'),
                      _statTile('Startups Built', '2')
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
            SizedBox(width: size.width * 0.42, height: size.height * 0.68, child: _build3DViewer()),
            const SizedBox(width: 20),
            Expanded(
              child: _glassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('About',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(shortBio, style: const TextStyle(fontSize: 14, height: 1.5)),
                    const SizedBox(height: 14),
                    const Text('Quick Stats', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _statTile('Years', '4+'),
                        _statTile('Projects', '10+'),
                        _statTile('Startups Built', '2')
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
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
      child: Center(
        child: ModelViewer(
          src: 'assets/models/Ayush.glb',
          alt: "3D Portfolio Model",
          autoPlay: true,
          cameraControls: true,
          ar: false,
          disableZoom: false,
          autoRotate: true,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }


// ------------------- Updated _buildSkillsPage() -------------------
  Widget _buildSkillsPage() {
    // inside _HomePageState class
    final List<String> _skillsData = [
      'Python','C++','ROS','Robotis','3D Modeling',
      'TensorFlow','Flutter / Dart','Linux','Rust','Quant Trading'
    ];

    final List<double> _skillsProgress = [
      0.95, 0.58, 0.22, 0.26, 0.32,
      0.60, 0.98, 0.43, 0.25, 0.72
    ];

    final List<IconData> _skillsIcons = [
      Icons.code, Icons.memory, Icons.settings, Icons.smart_toy, Icons.threed_rotation,
      Icons.auto_graph, Icons.phone_android, Icons.laptop, Icons.build, Icons.show_chart
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Skills', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),

            // Responsive grid that keeps each card the same size across devices
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  const minCardWidth = 95;
                  const double maxCardHeight = 140; // ✅ Big enough but won't overflow screen

                  // ✅ Auto calculate number of columns by screen width
                  int crossAxisCount = (width / minCardWidth).floor().clamp(2, 6);

                  // ✅ Ensure good width distribution
                  double cardWidth =
                  (width / crossAxisCount - 14).clamp(minCardWidth, width).toDouble();

                  return Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: List.generate(_skillsData.length, (i) {
                        return SizedBox(
                          width: cardWidth,
                          height: maxCardHeight, // ✅ Fixed — no more increasing too much
                          child: FlipSkillCard(
                            icon: _skillsIcons[i],
                            title: _skillsData[i],
                            progress: _skillsProgress[i],
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
          ],
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
              const Text(
                'Projects',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // ✅ Scrollable list inside fixed container
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 90,
                  physics: const FixedExtentScrollPhysics(),
                  perspective: 0.002,
                  onSelectedItemChanged: (index) {},

                  // ✅ Circular Loop effect
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: projects.map(
                          (p) => ListTile(
                        title: Text(p['title']!),
                        subtitle: Text(
                          p['desc']!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.open_in_new),
                          onPressed: () => _openUrl(p['link']!),
                        ),
                      ),
                    ).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Center(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _openUrl('https://github.com/ayushk2s'),
                  splashColor: Colors.cyanAccent.withOpacity(0.3),
                  highlightColor: Colors.purpleAccent.withOpacity(0.3),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00F0FF),
                          Color(0xFF7B61FF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.25),
                          blurRadius: 20,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.code, color: Colors.black, size: 21),
                        SizedBox(width: 10),
                        Text(
                          'View more on GitHub',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),

        ),
      ),
    );
  }

// -------------------- CONTACT PAGE --------------------
  Widget _buildContactPage() {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;

    double maxWidth = isDesktop
        ? 600
        : isTablet
        ? 450
        : size.width * 0.9;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: size.height - 40,
          ),
          child: _glassCard(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: isDesktop ? 28 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                          "Feel free to message me!",
                      style: TextStyle(height: 1.4),
                    ),
                    const SizedBox(height: 18),

                    // Social Buttons — Auto Wrap
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _socialButton(Icons.email_outlined,
                            'Email', 'mailto:ayushk2s@icloud.com'),
                        _socialButton(Icons.camera_alt_outlined,
                            'Instagram', 'https://instagram.com/ayushk2s'),
                        _socialButton(Icons.forum_outlined,
                            'Threads', 'https://threads.net/@ayushk2s'),
                        _socialButton(Icons.alternate_email,
                            'X (Twitter)', 'https://x.com/ayushk2s'),
                        _socialButton(Icons.business_center,
                            'LinkedIn', 'https://linkedin.com/in/ayushk2s'),
                        _socialButton(Icons.snapchat,
                            'Snapchat', 'https://www.snapchat.com/@ayushk2s'),
                      ],
                    ),

                    const SizedBox(height: 18),

                    const Text('Send me a message 👇',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    // Text Inputs scale with width
                    _inputBox(_nameController, 'Your Name'),
                    const SizedBox(height: 10),
                    _inputBox(_emailController, 'Your Email'),
                    const SizedBox(height: 10),
                    Expanded(child: _inputBox(_messageController, 'Your Message', maxLines: 4)),

                    const SizedBox(height: 16),

                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send_rounded),
                        label: const Text('Send Message'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 32 : 22,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Widget _inputBox(TextEditingController c, String label, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, String text, String url) {
    return ElevatedButton.icon(
      onPressed: () => _openUrl(url),
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white12,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _sendMessage() {
    final subject = Uri.encodeComponent("Portfolio Contact");
    final body = Uri.encodeComponent(
      "Name: ${_nameController.text}\n"
          "Email: ${_emailController.text}\n"
          "Message: ${_messageController.text}",
    );
    _openUrl("mailto:ayushk2s@icloud.com?subject=$subject&body=$body");
  }



  // -------------------- GLASS CARD --------------------
  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withOpacity(0.06),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }

  // -------------------- BOT HANDLER --------------------
  void _onBotTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: Wrap(
            children: [
              Row(
                children: [
                  const Icon(Icons.smart_toy, color: Colors.cyan),
                  const SizedBox(width: 8),
                  const Text('AURIX — Robotic Assistant', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _pageController.animateToPage(3, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                    },
                    icon: const Icon(Icons.email_outlined),
                    color: Colors.white70,
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Text('Hello, Commander. I can guide you through the lab modules. What would you like to do?', style: TextStyle(height: 1.4)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _pageController.jumpToPage(1);
                    },
                    icon: const Icon(Icons.auto_fix_high),
                    label: const Text('Show Skills'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _pageController.jumpToPage(2);
                    },
                    icon: const Icon(Icons.build),
                    label: const Text('Open Projects'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _openUrl('mailto:ayush@example.com?subject=Portfolio%20Inquiry');
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Contact Ayush'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }


}

// -------------------- Floating Bot Widget --------------------
class FloatingBot extends StatefulWidget {
  final VoidCallback onTap;
  const FloatingBot({required this.onTap, super.key});

  @override
  State<FloatingBot> createState() => _FloatingBotState();
}

class _FloatingBotState extends State<FloatingBot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 18,
      bottom: 28,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final bob = sin(_controller.value * 2 * pi) * 6;
              return Transform.translate(
                offset: Offset(0, -bob),
                child: child,
              );
            },
            child: Container(
              width: _isHovered ? 74 : 64,
              height: _isHovered ? 74 : 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [Color(0xFF00E6FF), Color(0xFF0055FF)]),
                boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.4), blurRadius: 20, spreadRadius: 2)],
                border: Border.all(color: Colors.white12),
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 32),
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------- Skill Module Tile --------------------
class SkillModule extends StatelessWidget {
  final String label;
  final double progress;
  final VoidCallback onTap;
  const SkillModule({required this.label, required this.progress, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress, minHeight: 8),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('${(progress * 100).round()}%', style: const TextStyle(fontSize: 12)),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 18),
              ],
            )
          ],
        ),
      ),
    );
  }
}


// -------------------- Boot Overlay --------------------
class BootOverlay extends StatelessWidget {
  final int step;
  const BootOverlay({required this.step, super.key});

  @override
  Widget build(BuildContext context) {
    final lines = [
      '[BOOTING SYSTEM...]',
      '> AI Modules Online',
      '> Robotics Suite Active',
      '> Welcome Commander',
    ];
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.catching_pokemon, size: 56, color: Colors.cyan),
            const SizedBox(height: 14),
            Text(lines.take(step).join('\n'), style: const TextStyle(fontFamily: 'monospace', color: Colors.cyanAccent, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 18),
            if (step < lines.length)
              const SizedBox(
                height: 6,
                width: 120,
                child: LinearProgressIndicator(value: null, backgroundColor: Colors.white10, color: Colors.cyan),
              ),
          ],
        ),
      ),
    );
  }
}

// -------------------- Hologram Scan Overlay --------------------
class HologramScan extends StatelessWidget {
  final AnimationController controller;
  final bool active;
  const HologramScan({required this.controller, required this.active, super.key});

  @override
  Widget build(BuildContext context) {
    if (!active) return const SizedBox.shrink();
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final y = (controller.value * 2) - 0.5; // -0.5..1.5
          return Align(
            alignment: Alignment(0, y),
            child: Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyan.withOpacity(0.08), Colors.cyan.withOpacity(0.02)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.cyan.withOpacity(0.12)),
              ),
            ),
          );
        },
      ),
    );
  }
}

// -------------------- Particle Field --------------------
class ParticleField extends StatefulWidget {
  const ParticleField({super.key});
  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _rnd = Random();
  final List<_Dot> _dots = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 28; i++) {
      _dots.add(_Dot(
        x: _rnd.nextDouble(),
        y: _rnd.nextDouble(),
        size: 1 + _rnd.nextDouble() * 2.8,
        speed: 0.2 + _rnd.nextDouble() * 0.8,
        o: 0.08 + _rnd.nextDouble() * 0.18,
      ));
    }
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(painter: _ParticlePainter(_dots, _controller.value), size: Size.infinite);
        },
      ),
    );
  }
}

class _Dot {
  double x, y, size, speed, o;
  _Dot({required this.x, required this.y, required this.size, required this.speed, required this.o});
}

class _ParticlePainter extends CustomPainter {
  final List<_Dot> dots;
  final double t;
  _ParticlePainter(this.dots, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var d in dots) {
      final dx = (d.x * size.width + sin((t + d.x) * 2 * pi) * 8 * d.speed);
      final dy = (d.y * size.height + cos((t + d.y) * 2 * pi) * 8 * d.speed);
      paint.color = Colors.cyan.withOpacity(d.o * (0.6 + 0.4 * sin(t * 2 * pi)));
      canvas.drawCircle(Offset(dx, dy), d.size, paint);
    }

    // decorative wiring lines (static-ish)
    final wire = Paint()
      ..color = Colors.cyan.withOpacity(0.06)
      ..strokeWidth = 1.1;
    final w = size.width;
    final h = size.height;
    canvas.drawLine(Offset(w * 0.12, h * 0.08), Offset(w * 0.36, h * 0.2), wire);
    canvas.drawLine(Offset(w * 0.8, h * 0.18), Offset(w * 0.62, h * 0.34), wire);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
