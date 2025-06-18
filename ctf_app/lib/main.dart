import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/ctf_writeup.dart';

void main() {
  runApp(const CTFWriteupsApp());
}

class CTFWriteupsApp extends StatelessWidget {
  const CTFWriteupsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CTF Write-ups by Tham Le',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: GoogleFonts.pressStart2pTextTheme().copyWith(
          bodyLarge: GoogleFonts.robotoMono(fontSize: 14, height: 1.6),
          bodyMedium: GoogleFonts.robotoMono(fontSize: 12, height: 1.5),
          headlineLarge: GoogleFonts.pressStart2p(fontSize: 24),
          headlineMedium: GoogleFonts.pressStart2p(fontSize: 18),
          headlineSmall: GoogleFonts.pressStart2p(fontSize: 14),
        ),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB19CD9), // Soft lavender
          brightness: Brightness.light,
          primary: const Color(0xFFB19CD9), // Soft lavender
          secondary: const Color(0xFFFFB7C5), // Pastel pink
          tertiary: const Color(0xFFC4E1FF), // Pastel blue
          surface: const Color(0xFFF8F4FF), // Very light lavender
          onSurface: const Color(0xFF2D2D2D), // Dark grey for text
        ),
        cardTheme: CardTheme(
          elevation: 8,
          shadowColor: Colors.purple.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: const Color(0xFFB19CD9).withOpacity(0.3), width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 8,
            shadowColor: Colors.purple.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFB19CD9), width: 2),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        textTheme: GoogleFonts.pressStart2pTextTheme(ThemeData.dark().textTheme).copyWith(
          bodyLarge: GoogleFonts.robotoMono(fontSize: 14, height: 1.6, color: Colors.white),
          bodyMedium: GoogleFonts.robotoMono(fontSize: 12, height: 1.5, color: Colors.white70),
          headlineLarge: GoogleFonts.pressStart2p(fontSize: 24, color: Colors.white),
          headlineMedium: GoogleFonts.pressStart2p(fontSize: 18, color: Colors.white),
          headlineSmall: GoogleFonts.pressStart2p(fontSize: 14, color: Colors.white),
        ),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A4C93), // Deep purple
          brightness: Brightness.dark,
          primary: const Color(0xFF6A4C93), // Deep purple
          secondary: const Color(0xFFFF6B9D), // Bright pink
          tertiary: const Color(0xFF4ECDC4), // Mint green
          surface: const Color(0xFF1A1A2E), // Dark navy
          onSurface: const Color(0xFFF0F0F0), // Light grey for text
        ),
      ),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
        ],
      ),
      home: const HomePage(),
      routes: {
        '/writeup': (context) => const WriteupDetailPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<CTFWriteup> writeups = [];
  bool isLoading = true;
  String selectedCategory = 'All';
  String selectedDifficulty = 'All';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    loadWriteups();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadWriteups() async {
    try {
      final String markdown = await rootBundle.loadString('assets/writeups/sample-web-challenge.md');
      final writeup = CTFWriteup.fromMarkdown(markdown, 'sample-web-challenge.md');
      
      setState(() {
        writeups = [writeup];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading writeups: $e');
    }
  }

  List<CTFWriteup> get filteredWriteups {
    return writeups.where((writeup) {
      final categoryMatch = selectedCategory == 'All' || writeup.category == selectedCategory;
      final difficultyMatch = selectedDifficulty == 'All' || writeup.difficulty == selectedDifficulty;
      return categoryMatch && difficultyMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  '🏆 CTF ZONE 🏆',
                  style: GoogleFonts.pressStart2p(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        offset: const Offset(2, 2),
                        blurRadius: 0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFB19CD9), // Soft lavender
                      const Color(0xFFFFB7C5), // Pastel pink
                      const Color(0xFFC4E1FF), // Pastel blue
                      const Color(0xFFBEE5BF), // Pastel green
                    ],
                    stops: const [0.0, 0.33, 0.66, 1.0],
                  ),
                ),
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black, width: 3),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(4, 4),
                                blurRadius: 0,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                '🎮 THAM.EXE 🎮',
                                style: GoogleFonts.pressStart2p(
                                  fontSize: 14,
                                  color: const Color(0xFF6A4C93),
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(1, 1),
                                      blurRadius: 0,
                                      color: Colors.cyan.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'CYBER SECURITY ADVENTURES',
                                style: GoogleFonts.pressStart2p(
                                  fontSize: 8,
                                  color: const Color(0xFF2D2D2D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildPixelFilterSection(),
                  const SizedBox(height: 32),
                  if (isLoading)
                    _buildPixelLoader()
                  else if (filteredWriteups.isEmpty)
                    _buildPixelEmptyState()
                  else
                    _buildPixelWriteupsList(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: [
            BoxShadow(
              offset: const Offset(4, 4),
              blurRadius: 0,
              color: Colors.black.withOpacity(0.8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final url = Uri.parse('https://thamle.live');
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
          backgroundColor: const Color(0xFFFFB7C5),
          foregroundColor: const Color(0xFF2D2D2D),
          icon: const Text('🏠', style: TextStyle(fontSize: 16)),
          label: Text(
            'BACK TO BASE',
            style: GoogleFonts.pressStart2p(fontSize: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildPixelFilterSection() {
    final categories = ['All', 'Web', 'Crypto', 'Pwn', 'Reverse', 'Forensics', 'Misc'];
    final difficulties = ['All', 'Easy', 'Medium', 'Hard'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: [
          BoxShadow(
            offset: const Offset(6, 6),
            blurRadius: 0,
            color: const Color(0xFFB19CD9).withOpacity(0.8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🎯', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'FILTER ZONE',
                style: GoogleFonts.pressStart2p(
                  fontSize: 16,
                  color: const Color(0xFF6A4C93),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CATEGORY:',
                      style: GoogleFonts.pressStart2p(fontSize: 10),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFC4E1FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        style: GoogleFonts.robotoMono(
                          color: const Color(0xFF2D2D2D),
                          fontSize: 12,
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DIFFICULTY:',
                      style: GoogleFonts.pressStart2p(fontSize: 10),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFBEE5BF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedDifficulty,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        style: GoogleFonts.robotoMono(
                          color: const Color(0xFF2D2D2D),
                          fontSize: 12,
                        ),
                        items: difficulties.map((difficulty) {
                          return DropdownMenuItem(
                            value: difficulty,
                            child: Text(difficulty),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDifficulty = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPixelLoader() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text('⚡', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'LOADING...',
            style: GoogleFonts.pressStart2p(
              fontSize: 14,
              color: const Color(0xFF6A4C93),
            ),
          ),
          const SizedBox(height: 16),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB19CD9)),
            strokeWidth: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildPixelEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text('💾', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 20),
          Text(
            'NO DATA FOUND',
            style: GoogleFonts.pressStart2p(
              fontSize: 16,
              color: const Color(0xFF6A4C93),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'TRY DIFFERENT FILTERS!',
            style: GoogleFonts.pressStart2p(
              fontSize: 10,
              color: const Color(0xFF888888),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPixelWriteupsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredWriteups.length,
      itemBuilder: (context, index) {
        final writeup = filteredWriteups[index];
        return _buildPixelWriteupCard(writeup);
      },
    );
  }

  Widget _buildPixelWriteupCard(CTFWriteup writeup) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: [
          BoxShadow(
            offset: const Offset(8, 8),
            blurRadius: 0,
            color: writeup.categoryColor.withOpacity(0.6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/writeup',
              arguments: writeup,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        writeup.title.toUpperCase(),
                        style: GoogleFonts.pressStart2p(
                          fontSize: 14,
                          color: const Color(0xFF2D2D2D),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: writeup.difficultyColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(2, 2),
                            blurRadius: 0,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ],
                      ),
                      child: Text(
                        writeup.difficulty.toUpperCase(),
                        style: GoogleFonts.pressStart2p(
                          fontSize: 8,
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('📅', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      '${writeup.ctf} • ${writeup.date.day}/${writeup.date.month}/${writeup.date.year}',
                      style: GoogleFonts.robotoMono(
                        fontSize: 12,
                        color: const Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text('⭐', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      '${writeup.points} PTS',
                      style: GoogleFonts.robotoMono(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: writeup.categoryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: writeup.categoryColor, width: 2),
                      ),
                      child: Text(
                        writeup.category.toUpperCase(),
                        style: GoogleFonts.pressStart2p(
                          fontSize: 8,
                          color: writeup.categoryColor,
                        ),
                      ),
                    ),
                    ...writeup.tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFCCCCCC), width: 1),
                      ),
                      child: Text(
                        '#${tag.toUpperCase()}',
                        style: GoogleFonts.robotoMono(
                          fontSize: 10,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WriteupDetailPage extends StatelessWidget {
  const WriteupDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final writeup = ModalRoute.of(context)!.settings.arguments as CTFWriteup;

    return Scaffold(
      appBar: AppBar(
        title: Text(writeup.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ResponsiveRowColumn(
          layout: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 3,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: MarkdownBody(
                    data: writeup.content,
                    styleSheet: MarkdownStyleSheet(
                      h1: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      h2: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      h3: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      p: GoogleFonts.inter(fontSize: 16, height: 1.6),
                      code: GoogleFonts.jetBrainsMono(
                        backgroundColor: Colors.grey[100],
                        fontSize: 14,
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const ResponsiveRowColumnItem(
              child: SizedBox(width: 24, height: 24),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Challenge Info',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('CTF', writeup.ctf),
                      _buildInfoRow('Category', writeup.category),
                      _buildInfoRow('Difficulty', writeup.difficulty),
                      _buildInfoRow('Points', '${writeup.points}'),
                      _buildInfoRow('Date', '${writeup.date.day}/${writeup.date.month}/${writeup.date.year}'),
                      _buildInfoRow('Author', writeup.author),
                      const SizedBox(height: 16),
                      Text(
                        'Tags',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: writeup.tags.map((tag) => Chip(
                          label: Text('#$tag'),
                          backgroundColor: Colors.grey[200],
                          labelStyle: const TextStyle(fontSize: 12),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(),
            ),
          ),
        ],
      ),
    );
  }
}
