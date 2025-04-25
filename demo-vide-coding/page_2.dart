import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

void main() {
  runApp(MyPortfolioApp());
}

class MyPortfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luong Do Minh Hung - Romantic Developer',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey.shade900,
        scaffoldBackgroundColor: Colors.grey.shade900,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: Colors.white70,
          displayColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _heroController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeInOut),
    );

    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(
              fadeAnimation: _fadeAnimation,
              slideAnimation: _slideAnimation,
              rotateAnimation: _rotateAnimation,
            ),
            SkillsSection(),
            PortfolioSection(),
            ContactFooter(),
          ],
        ),
      ),
    );
  }
}

// Hero Section
class HeroSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> rotateAnimation;

  HeroSection({
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.rotateAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: rotateAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: rotateAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 120,
                          backgroundImage: NetworkImage('https://picsum.photos/400/400'),
                          backgroundColor: Colors.grey.shade800,
                          child: ClipOval(
                            child: Image.network(
                              'https://picsum.photos/400/400',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.person,
                                size: 120,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                Text(
                  'Luong Do Minh Hung',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'Romantic Developer | Principal Software Engineer | Flutter Expert',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Download CV',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Skills Section
class SkillsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final skills = [
      {'name': 'Flutter', 'icon': Icons.developer_mode},
      {'name': 'React Native', 'icon': Icons.phone_android},
      {'name': 'Payment Systems', 'icon': Icons.payment},
      {'name': 'Clean Architecture', 'icon': Icons.architecture},
      {'name': 'CI/CD', 'icon': Icons.build},
      {'name': 'Agile Methodologies', 'icon': Icons.group_work},
      {'name': 'Team Leadership', 'icon': Icons.person},
      {'name': 'ReactJS', 'icon': Icons.web},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: Colors.grey.shade900,
      child: Column(
        children: [
          Text(
            'My Skills',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 40),
          AnimationLimiter(
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: skills.asMap().entries.map((entry) {
                int index = entry.key;
                var skill = entry.value;
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 800),
                  columnCount: skills.length,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: Container(
                        width: 160,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade800.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blueGrey.shade600),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              skill['icon'] as IconData,
                              size: 40,
                              color: Colors.orange.shade400,
                            ),
                            SizedBox(height: 10),
                            Text(
                              skill['name'] as String,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Portfolio Section
class PortfolioSection extends StatefulWidget {
  @override
  _PortfolioSectionState createState() => _PortfolioSectionState();
}

class _PortfolioSectionState extends State<PortfolioSection> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(Context context) {
    final projects = [
      {
        'title': 'Global Mobile App (GMA)',
        'description':
        'Led development of Digital Payment & Transaction Stream for Home Credit Vietnam, including mobile top-up, bill payment, and QR payment. Transitioned native apps to Flutter, saving €10K annually.',
        'image': 'https://picsum.photos/500/300?random=1',
        'link': 'https://www.homecredit.vn/ung-dung-home-credit',
        'responsibilities': [
          'Transitioned native mobile developers to Flutter.',
          'Developed key features like mobile top-up, bill payment, QR payment, and Home PayLater.',
          'Set standards and guidelines for Mobile Application Development.',
          'Supported hiring and coaching mobile developers.',
          'Proposed technical standards to save costs and accelerate development.',
          'Investigated and resolved security issues.',
        ],
        'achievements': [
          'Saved €10K annually by replacing an ineffective SDK.',
          'Reduced app size by 20-50%.',
          'Transitioned native apps to a Flutter plugin.',
          'Scaled GMA VN team from 3 to 5 cross-functional teams of 10 members each.',
          'Presented at Home Credit’s first TechTalk event.',
          'Recognized as a DNA Star for leadership qualities.',
        ],
      },
      {
        'title': 'Sendo E-Commerce App',
        'description':
        'Transformed Sendo’s mobile app to Flutter, introducing features like SenPay e-wallet, flash sales, and mini-games. Scaled team to 10 cross-functional units.',
        'image': 'https://picsum.photos/500/300?random=2',
        'link': 'https://www.sendo.vn/su-kien/gioi-thieu-sendo-app/',
        'responsibilities': [
          'Transformed native mobile developers to Flutter.',
          'Developed digital payment services (phone top-up, bill payments, air tickets).',
          'Introduced event templates, flash sales, and mini-games.',
          'Set standards and guidelines for Mobile Application Development.',
          'Supported hiring and coaching mobile developers.',
          'Proposed technical standards to save costs.',
        ],
        'achievements': [
          'Trained Flutter engineers, including Flutter Vietnam Admin.',
          'Released Vietnam’s first super-app using Flutter.',
          'Scaled to 10 cross-functional teams.',
          'Presented at internal TechTalk sessions.',
        ],
      },
      {
        'title': 'SenPay E-Wallet',
        'description':
        'Built and published SenPay Android app from scratch, integrating digital payment services like phone top-up and bill payments.',
        'image': 'https://picsum.photos/500/300?random=3',
        'link': 'https://senpay.vn/',
        'responsibilities': [
          'Built architecture and solutions for the Android app.',
          'Published SenPay Android app on Google Play Store.',
          'Developed digital payment services (phone top-up, bill payments).',
          'Supported hiring and coaching mobile developers.',
          'Proposed technical standards to save costs.',
        ],
        'achievements': [
          'Promoted to lead Sendo Android developers.',
          'Advanced to Mobile Team Leader at Sendo.',
        ],
      },
      {
        'title': 'iCareBenefits',
        'description':
        'Developed multiple Android apps for iCareBenefits, including e-commerce and delivery tracking solutions, contributing to digital transformation.',
        'image': 'https://picsum.photos/500/300?random=4',
        'link': '',
        'responsibilities': [
          'Built architecture and solutions for Android apps.',
          'Developed apps like iCareMember, FieldSale, and Delivery Tracking.',
          'Published iCareBenefits Android app on Google Play Store.',
        ],
        'achievements': [
          'Published multiple internal apps for digital transformation.',
          'Released the first version of iCareBenefits Android app.',
        ],
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: Colors.blueGrey.shade900,
      child: Column(
        children: [
          Text(
            'My Works',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 40),
          AnimationLimiter(
            child: Column(
              children: projects.asMap().entries.map((entry) {
                int index = entry.key;
                var project = entry.value;
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 1000),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: PortfolioCard(project: project),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class PortfolioCard extends StatefulWidget {
  final Map<String, dynamic> project;

  PortfolioCard({required this.project});

  @override
  _PortfolioCardState createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<PortfolioCard> with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _bounceController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _bounceController.reverse();
      },
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_bounceAnimation.value),
            child: Container(
              width: 600,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade800.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueGrey.shade600),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      widget.project['image'] as String,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: Colors.grey.shade800,
                        child: Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.project['title'] as String,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.project['description'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 15),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectDetailPage(project: widget.project),
                              ),
                            );
                          },
                          child: Text(
                            'View Project',
                            style: TextStyle(
                              fontSize: 16,
                              color: _isHovered ? Colors.orange.shade400 : Colors.orange.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Project Detail Page
class ProjectDetailPage extends StatefulWidget {
  final Map<String, dynamic> project;

  ProjectDetailPage({required this.project});

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: Text(widget.project['title'] as String),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.project['image'] as String,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 300,
                        color: Colors.grey.shade800,
                        child: Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.project['title'] as String,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.project['description'] as String,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Responsibilities',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  ...?((widget.project['responsibilities'] as List<String>?)?.map((resp) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: Colors.orange.shade600, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            resp,
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ))),
                  SizedBox(height: 20),
                  Text(
                    'Achievements',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  ...?((widget.project['achievements'] as List<String>?)?.map((ach) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.star, color: Colors.orange.shade600, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            ach,
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ))),
                  SizedBox(height: 20),
                  if ((widget.project['link'] as String).isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        // Implement url_launcher here
                      },
                      child: Text(
                        'Visit Project Website',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Contact Footer
class ContactFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade800],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Get in Touch',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30),
          AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 600),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  Text(
                    'Email: minhhung2556@gmail.com',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone: +84 775005110',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'GitHub: github.com/<your-username>',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Medium: medium.com/<your-username>',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(Icons.email, Colors.orange.shade600),
              _buildIconButton(Icons.code, Colors.orange.shade600),
              _buildIconButton(Icons.article, Colors.orange.shade600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey.shade800.withOpacity(0.5),
              border: Border.all(color: Colors.blueGrey.shade600),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
        ),
      ),
    );
  }
}