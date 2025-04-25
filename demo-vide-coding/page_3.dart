import 'dart:convert';
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
      title: 'Portfolio',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
  Map<String, dynamic>? styles;
  Map<String, dynamic>? content;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOut),
    );

    _heroController.forward();
  }

  Future<Map<String, dynamic>> loadJson(String path) async {
    final String jsonString = await DefaultAssetBundle.of(context).loadString(path);
    return jsonDecode(jsonString);
  }

  @override
  void dispose() {
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        loadJson('assets/styles.json'),
        loadJson('assets/content.json'),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading assets'));
        }

        styles = snapshot.data![0] as Map<String, dynamic>;
        content = snapshot.data![1] as Map<String, dynamic>;

        return Scaffold(
          backgroundColor: Color(int.parse(styles!['colors']['backgroundColor'].replaceAll('#', '0xFF'))),
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(height: styles!['dimensions']['navBarHeight'].toDouble()),
                    HeroSection(
                      fadeAnimation: _fadeAnimation,
                      slideAnimation: _slideAnimation,
                      styles: styles!,
                      content: content!,
                    ),
                    SkillsSection(styles: styles!, content: content!),
                    PortfolioSection(styles: styles!, content: content!),
                    ContactFooter(styles: styles!, content: content!),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: NavBar(styles: styles!, content: content!, scrollController: _scrollController),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Navigation Bar
class NavBar extends StatelessWidget {
  final Map<String, dynamic> styles;
  final Map<String, dynamic> content;
  final ScrollController scrollController;

  NavBar({required this.styles, required this.content, required this.scrollController});

  void _scrollToSection(String section) {
    double offset = 0;
    if (section == 'skills') offset = 600;
    if (section == 'portfolio') offset = 1200;
    if (section == 'contact') offset = 2200;
    scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: styles['dimensions']['navBarHeight'].toDouble(),
      color: Color(int.parse(styles['colors']['primaryColor'].replaceAll('#', '0xFF'))),
      padding: EdgeInsets.symmetric(horizontal: styles['dimensions']['sectionPaddingHorizontal'].toDouble()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            content['profile']['name'],
            style: TextStyle(
              fontSize: styles['dimensions']['subtitleFontSize'].toDouble(),
              fontWeight: FontWeight.bold,
              color: Color(int.parse(styles['colors']['textColor'].replaceAll('#', '0xFF'))),
            ),
          ),
          Row(
            children: [
              _navItem('Home', () => scrollController.jumpTo(0)),
              _navItem('Skills', () => _scrollToSection('skills')),
              _navItem('Projects', () => _scrollToSection('portfolio')),
              _navItem('Contact', () => _scrollToSection('contact')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(String text, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            text,
            style: TextStyle(
              fontSize: styles['dimensions']['contactTextSize'].toDouble(),
              color: Color(int.parse(styles['colors']['textSecondaryColor'].replaceAll('#', '0xFF'))),
            ),
          ),
        ),
      ),
    );
  }
}

// Hero Section
class HeroSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Map<String, dynamic> styles;
  final Map<String, dynamic> content;

  HeroSection({
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.styles,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: styles['dimensions']['heroHeight'].toDouble(),
      color: Color(int.parse(styles['colors']['primaryColor'].replaceAll('#', '0xFF'))),
      child: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  content['profile']['name'],
                  style: TextStyle(
                    fontSize: styles['dimensions']['titleFontSize'].toDouble(),
                    fontWeight: FontWeight.bold,
                    color: Color(int.parse(styles['colors']['textColor'].replaceAll('#', '0xFF'))),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(int.parse(styles['colors']['accentColor'].replaceAll('#', '0xFF'))),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    content['profile']['title'],
                    style: TextStyle(
                      fontSize: styles['dimensions']['subtitleFontSize'].toDouble(),
                      color: Color(int.parse(styles['colors']['textSecondaryColor'].replaceAll('#', '0xFF'))),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(int.parse(styles['colors']['accentColor'].replaceAll('#', '0xFF'))),
                    foregroundColor: Color(int.parse(styles['colors']['textColor'].replaceAll('#', '0xFF'))),
                  ),
                  child: Text(
                    content['profile']['downloadCv'],
                    style: TextStyle(
                      fontSize: styles['dimensions']['contactTextSize'].toDouble(),
                      fontWeight: FontWeight.w600,
                    ),
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
  final Map<String, dynamic> styles;
  final Map<String, dynamic> content;

  SkillsSection({required this.styles, required this.content});

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'developer_mode':
        return Icons.developer_mode;
      case 'phone_android':
        return Icons.phone_android;
      case 'payment':
        return Icons.payment;
      case 'architecture':
        return Icons.architecture;
      case 'build':
        return Icons.build;
      case 'group_work':
        return Icons.group_work;
      case 'person':
        return Icons.person;
      case 'web':
        return Icons.web;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: styles['dimensions']['sectionPaddingVertical'].toDouble(),
        horizontal: styles['dimensions']['sectionPaddingHorizontal'].toDouble(),
      ),
      color: Color(int.parse(styles['colors']['secondaryColor'].replaceAll('#', '0xFF'))),
      child: Column(
        children: [
          Text(
            content['skillsSectionTitle'],
            style: TextStyle(
              fontSize: styles['dimensions']['titleFontSize'].toDouble(),
              fontWeight: FontWeight.bold,
              color: Color(int.parse(styles['colors']['textColor'].replaceAll('#', '0xFF'))),
            ),
          ),
          SizedBox(height: 40),
          AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: styles['dimensions']['skillCardWidth'] / styles['dimensions']['skillCardHeight'],
              ),
              itemCount: (content['skills'] as List).length,
              itemBuilder: (context, index) {
                var skill = content['skills'][index];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 100 * index),
                  columnCount: 4,
                  child: ScaleAnimation(
                    scale: 0.8,
                    child: FadeInAnimation(
                      child: MouseRegion(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(int.parse(styles['colors']['cardColor'].replaceAll('#', '0xFF'))).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(int.parse(styles['colors']['shadowColor'].replaceAll('#', '0xFF'))).withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(styles['dimensions']['skillCardPadding'].toDouble()),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _getIcon(skill['icon']),
                                    size: styles['dimensions']['skillIconSize'].toDouble(),
                                    color: Color(int.parse(styles['colors']['accentColor'].replaceAll('#', '0xFF'))),
                                  ),
                                  SizedBox(height: 12),
                                  Flexible(
                                    child: Text(
                                      skill['name'],
                                      style: TextStyle(
                                        fontSize: styles['dimensions']['skillTextSize'].toDouble(),
                                        fontWeight: FontWeight.w600,
                                        color: Color(int.parse(styles['colors']['textColor'].replaceAll('#', '0xFF'))),
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Portfolio Section
class PortfolioSection extends StatefulWidget {
  final Map<String, dynamic> styles;
  final Map<String, dynamic> content;

  PortfolioSection({required this.styles, required this.content});

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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: widget.styles['dimensions']['sectionPaddingVertical'].toDouble(),
        horizontal: widget.styles['dimensions']['sectionPaddingHorizontal'].toDouble(),
      ),
      color: Color(int.parse(widget.styles['colors']['primaryColor'].replaceAll('#', '0xFF'))),
      child: Column(
        children: [
          Text(
            widget.content['portfolioSectionTitle'],
            style: TextStyle(
              fontSize: widget.styles['dimensions']['titleFontSize'].toDouble(),
              fontWeight: FontWeight.bold,
              color: Color(int.parse(widget.styles['colors']['textColor'].replaceAll('#', '0xFF'))),
            ),
          ),
          SizedBox(height: 40),
          AnimationLimiter(
            child: Column(
              children: (widget.content['projects'] as List).asMap().entries.map((entry) {
                int index = entry.key;
                var project = entry.value;
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 800),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: PortfolioCard(
                          project: project,
                          styles: widget.styles,
                          content: widget.content,
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

class PortfolioCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final Map<String, dynamic> styles;
  final Map<String, dynamic> content;

  PortfolioCard({required this.project, required this.styles, required this.content});

  @override
  _PortfolioCardState createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<PortfolioCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _liftAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _liftAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _liftAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _liftAnimation.value),
            child: Container(
              width: widget.styles['dimensions']['portfolioCardWidth'].toDouble(),
              decoration: BoxDecoration(
                color: Color(int.parse(widget.styles['colors']['cardColor'].replaceAll('#', '0xFF'))).withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(int.parse(widget.styles['colors']['shadowColor'].replaceAll('#', '0xFF'))).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      widget.project['image'],
                      height: widget.styles['dimensions']['portfolioImageHeight'].toDouble(),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: widget.styles['dimensions']['portfolioImageHeight'].toDouble(),
                        color: Color(int.parse(widget.styles['colors']['cardColor'].replaceAll('#', '0xFF'))),
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Color(int.parse(widget.styles['colors']['textSecondaryColor'].replaceAll('#', '0xFF'))),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.project['title'],
                          style: TextStyle(
                            fontSize: widget.styles['dimensions']['portfolioTitleSize'].toDouble(),
                            fontWeight: FontWeight.bold,
                            color: Color(int.parse(widget.styles['colors']['textColor'].replaceAll('#', '0xFF'))),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          widget.project['description'],
                          style: TextStyle(
                            fontSize: widget.styles['dimensions']['portfolioTextSize'].toDouble(),
                            color: Color(int.parse(widget.styles['colors']['textSecondaryColor'].replaceAll('#', '0xFF'))),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectDetailPage(
                                  project: widget.project,
                                  styles: widget.styles,
                                  content: widget.content,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(int.parse(widget.styles['colors']['accentColor'].replaceAll('#', '0xFF'))),
                            foregroundColor: Color(int.parse(widget.styles['colors']['textColor'].replaceAll('#', '0xFF'))),
                          ),
                          child: Text(
                            widget.content['buttons']['viewProject'],
                            style: TextStyle(
                              fontSize: widget.styles['dimensions']['portfolioTextSize'].toDouble(),
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
  final Map<String, dynamic> styles;
  final Map<String, dynamic> content;

  ProjectDetailPage({required this.project, required this.styles, required this.content});

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
        backgroundColor: Color(int.parse(widget.styles['colors']['primaryColor'].replaceAll('#', '0xFF'))),
        title: Text(
          widget.project['title'],
          style: TextStyle(
            fontSize: widget.styles['dimensions']['subtitleFontSize'].toDouble(),
            color: Color(int.parse(widget.styles['colors']['textColor'].replaceAll('#', '0xFF'))),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(int.parse(widget.styles['colors']['textColor'].replaceAll('#', '0xFF')))),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Color(int.parse(widget.styles['colors']['backgroundColor'].replaceAll('#', '0xFF'))),
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.all(widget.styles['dimensions']['sectionPaddingHorizontal'].toDouble()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.project['image'],
                      height: widget.styles['dimensions']['detailImageHeight'].toDouble(),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: widget.styles['dimensions']['detailImageHeight'].toDouble(),
                        color: Color(int.parse(widget.styles['colors']['cardColor'].replaceAll('#', '0xFF'))),
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Color(int.parse(widget.styles['colors']['textSecondaryColor'].replaceAll('#', '0xFF'))),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    widget.project['title'],
                    style: TextStyle(
                      fontSize: widget.styles['dimensions']['detailTitleSize'].toDouble(),
                      fontWeight: FontWeight.bold,
                      color: Color(int.parse(widget.styles['colors']['textColor'].replaceAll('#', '0xFF'))),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.project['description'],
                    style: TextStyle(
                      fontSize: widget.styles['dimensions']['detailTextSize'].toDouble(),
                      color: Color(int.parse(widget.styles['colors']['textSecondaryColor'].replaceAll('#', '0xFF'))),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Responsibilities',
                    style: TextStyle(
                      fontSize: widget.styles['dimensions']['detailSubtitleSize'].toDouble(),
                      fontWeight: FontWeight.bold,
                      color: Color(int.parse(widget.styles['colors']['textColor'].replaceAll('#', '0xFF'))),
                    ),
                  ),
                  SizedBox(height: 12),
                  ...?(widget.project['responsibilities'] as List<dynamic>?)?.map((resp) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Color(int.parse(widget.styles['colors']['accentColor'].replaceAll('#', '0xFF'))),
                          size: 18,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            resp,
                            style: TextStyle(
                              fontSize: widget.styles['dimensions']['detailBulletSize'].toDouble(),
                              color: Color(int.parse(widget.styles['colors']['textSecondaryColor'].replaceAll('#', '0xFF'))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  SizedBox(height: 24),
                  Text(
                    'Achievements',
                    style: TextStyle(
                      fontSize: widget.styles['dimensions']['detailSubtitleSize'].toDouble(),
                      fontWeight: FontWeight.bold,
                      color: Color(int.parse(widget.styles['colors']['textColor'].replaceAll('#', '0xFF'))),
                    ),
                  ),
                  SizedBox(height: 12),
                  ...?(widget.project['achievements'] as List<dynamic>?)?.map((ach) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          color: Color(int.parse(widget.styles['colors']['accentColor'].replaceAll('#', '0xFF'))),
                          size: 18,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ach,
                            style: TextStyle(
                              fontSize: widget.styles['dimensions']['detailBulletSize'].toDouble(),
                              color: Color(int.parse(widget.styles['colors']['textSecondaryColor'].replaceAll('#', '0xFF'))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  SizedBox(height: 24),
                  if (widget.project['link'].isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        // Implement url_launcher here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(int.parse(widget.styles['colors']['accentColor'].replaceAll('#', '0xFF'))),
                        foregroundColor: Color(int.parse(widget.styles['colors']['textColor'].replaceAll('#', '0xFF'))),
                      ),
                      child: Text(
                        widget.content['buttons']['visitWebsite'],
                        style: TextStyle(
                          fontSize: widget.styles['dimensions']['detailBulletSize'].toDouble(),
                          fontWeight: FontWeight.w600,
                        ),
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
  final Map<String, dynamic> styles;
  final Map<String, dynamic> content;

  ContactFooter({required this.styles, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(styles['dimensions']['footerPadding'].toDouble()),
      color: Color(int.parse(styles['colors']['secondaryColor'].replaceAll('#', '0xFF'))),
      child: Column(
        children: [
          Text(
            content['contact']['title'],
            style: TextStyle(
              fontSize: styles['dimensions']['titleFontSize'].toDouble(),
              fontWeight: FontWeight.bold,
              color: Color(int.parse(styles['colors']['textColor'].replaceAll('#', '0xFF'))),
            ),
          ),
          SizedBox(height: 32),
          AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 600),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  Text(
                    'Email: ${content['contact']['email']}',
                    style: TextStyle(
                      fontSize: styles['dimensions']['contactTextSize'].toDouble(),
                      color: Color(int.parse(styles['colors']['textSecondaryColor'].replaceAll('#', '0xFF'))),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Phone: ${content['contact']['phone']}',
                    style: TextStyle(
                      fontSize: styles['dimensions']['contactTextSize'].toDouble(),
                      color: Color(int.parse(styles['colors']['textSecondaryColor'].replaceAll('#', '0xFF'))),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'GitHub: ${content['contact']['github']}',
                    style: TextStyle(
                      fontSize: styles['dimensions']['contactTextSize'].toDouble(),
                      color: Color(int.parse(styles['colors']['textSecondaryColor'].replaceAll('#', '0xFF'))),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Medium: ${content['contact']['medium']}',
                    style: TextStyle(
                      fontSize: styles['dimensions']['contactTextSize'].toDouble(),
                      color: Color(int.parse(styles['colors']['textSecondaryColor'].replaceAll('#', '0xFF'))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(Icons.email, 'mailto:${content['contact']['email']}'),
              _buildIconButton(Icons.code, 'https://${content['contact']['github']}'),
              _buildIconButton(Icons.article, 'https://${content['contact']['medium']}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String url) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // Implement url_launcher here
          },
          child: Container(
            padding: EdgeInsets.all(styles['dimensions']['iconButtonPadding'].toDouble()),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(int.parse(styles['colors']['accentColor'].replaceAll('#', '0xFF'))),
            ),
            child: Icon(
              icon,
              color: Color(int.parse(styles['colors']['textColor'].replaceAll('#', '0xFF'))),
              size: styles['dimensions']['iconButtonSize'].toDouble(),
            ),
          ),
        ),
      ),
    );
  }
}