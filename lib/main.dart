import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://ylqlpedreecldnbxcmur.supabase.co", 
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlscWxwZWRyZWVjbGRuYnhjbXVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgyMjA4ODYsImV4cCI6MjA3Mzc5Njg4Nn0.SVkx9jPH6YaFd3STkoT4vV3AjPqqWflSSLnoNtx0hZU", 
 authOptions: const FlutterAuthClientOptions(
      autoRefreshToken: true,    
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,

      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) =>  SplashScreen(toggleTheme:toggleTheme));
          case '/signin':
            return MaterialPageRoute(builder: (_) =>  SignInPage(toggleTheme: toggleTheme));
          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignUpPage());
          case '/forgot':
            return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
          case '/home':
            return MaterialPageRoute(
              builder: (_) => HomePage(toggleTheme: toggleTheme),
            );
          case '/vendors':
            return MaterialPageRoute(builder: (_) => const VendorsPage());
          default:
            return null;
        }
      },
    );
  }
}



// 🟣 Splash Screen
class SplashScreen extends StatefulWidget {
   final VoidCallback toggleTheme; 
  const SplashScreen({super.key, required this.toggleTheme});

 

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 3)); 

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomePage(toggleTheme: widget.toggleTheme),
    ),
  );
} else {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => OnboardingPage2(toggleTheme:widget.toggleTheme)),
  );
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Image.asset(
          "assets/images/logo1.png",
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}

// 🟢 Onboarding Pages
class OnboardingPage2 extends StatelessWidget {
 final VoidCallback toggleTheme;
  const OnboardingPage2({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      imagePath: "assets/images/image1.png",
      title: "Now reading books will be easier",
      description:
          "Discover new worlds, join a vibrant reading community. Start your reading adventure effortlessly with us.",
      currentIndex: 0,
      onContinue: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  OnboardingPage3(toggleTheme:toggleTheme)),
        );
      },
    );
  }
}

class OnboardingPage3 extends StatelessWidget {
    final VoidCallback toggleTheme;
  const OnboardingPage3({super.key, required this.toggleTheme});


  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      imagePath: "assets/images/image2.png",
      title: "Your Bookish Soulmate Awaits",
      description:
          "Let us be your guide to the perfect read. Discover books tailored to your tastes for a truly rewarding experience.",
      currentIndex: 1,
      onContinue: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OnboardingPage4(toggleTheme:toggleTheme)),
        );
      },
    );
  }
}

class OnboardingPage4 extends StatelessWidget {
  final VoidCallback toggleTheme;
  const OnboardingPage4({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return OnboardingTemplate(
      imagePath: "assets/images/image3.png",
      title: "Start your adventure.",
      description:
          "Ready to embark on a quest for inspiration and knowledge? Your adventure begins now. Let's go!",
      currentIndex: 2,
      isLastPage: true,
      onContinue: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage(toggleTheme:toggleTheme),),
        );
      },
    );
  }
}

// 🟣 Onboarding Template
class OnboardingTemplate extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final int currentIndex;
  final VoidCallback onContinue;
  final bool isLastPage;

  const OnboardingTemplate({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.currentIndex,
    required this.onContinue,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skip
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/signin');
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Image
            Center(
              child: Image.asset(
                imagePath,
                width: 300,
                height: 300,
              ),
            ),

            const SizedBox(height: 30),

            // Title
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),

            const Spacer(),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return _buildDot(index == currentIndex);
              }),
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  isLastPage ? "Get Started" : "Continue",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Sign In shortcut
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signin');
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  static Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.deepPurple : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

// 🟢 Sign In Page


class SignInPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const SignInPage({super.key, required this.toggleTheme});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final supabase = Supabase.instance.client;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool isLoading = false;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please enter a valid email")),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Password must be at least 6 characters")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Login successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(toggleTheme: widget.toggleTheme),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Invalid email or password")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "Sign in to your account",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Email
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Password
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: login, // ✅ appelle la fonction login
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Forgot Password
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/forgot'),
                child: const Text("Forgot Password?"),
              ),

              // Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final supabase = Supabase.instance.client;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoading = false;

  Future<void> register() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || !email.contains("@") || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill all fields correctly")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name, 
        },
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Account created! Please verify your email.")),
        );

       
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/signin');
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sign Up",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text("Create account and choose your favorite menu",
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),

            
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

   
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

            
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

     
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Register",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signin');
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

  
              const Center(
                child: Text(
                  "By clicking Register you agree to our Terms & Privacy",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// forgot password 
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reset link sent to $email")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Please enter your email",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _sendResetLink,
                child: const Text("Send Reset Link"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




//home page 

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _pageController = PageController(initialPage: 0);

   
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < offers.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // 📚 Exemple de livres
  final List<Map<String, dynamic>> books = [
    {
      "image": "assets/images/novel1.jpg",
      "title": "The Alchemist",
      "price": "1500 DA"
    },
    {
      "image": "assets/images/book_b.jpg",
      "title": "The Subtle Art of Not Giving a F*ck",
      "price": "1400 DA"
    },
    {
      "image": "assets/images/book_c.jpg",
      "title": "The Da Vinci Code",
      "price": "1900 DA"
    },
  ];

  final List<Map<String, String>> offers = [
    {"text": "-20% for The Kite Runner", "image": "assets/images/book_a.jpg"},
    {"text": "-15% for The Alchemist", "image": "assets/images/novel1.jpg"},
    {"text": "-30% for The Da Vinci Code", "image": "assets/images/book_c.jpg"},
  ];

  // 🟣 Pages
  List<Widget> get _pages => [
  _buildHomeContent(), // Home
  CategoryContent(tabController: _tabController),
  const WishlistPage(),
  ProfilePage(toggleTheme: widget.toggleTheme),
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Category"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }


  Widget _buildHomeContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home",style: TextStyle(fontWeight:FontWeight.bold ),),
        centerTitle: true,
leading: 
IconButton(
  icon: const Icon(Icons.search),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchPage()),
    );
  },
),


        actions: [
         IconButton(
  icon: const Icon(Icons.notifications),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationPage()),
    );
  },
),

        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
         
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.deepPurple.shade50,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              offer["text"]!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            offer["image"]!,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("🏆 Best Vendors",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/vendors");
                    },
                    child: const Text("See All"),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildVendor("Paradise", "assets/images/paradise.jpg"),
                  _buildVendor("Reader's Haven", "assets/images/readershaven.png"),
                  _buildVendor("Atlas", "assets/images/elatlas.png"),
                  _buildVendor("Dar Al Kitab", "assets/images/elkitab.png"),
                ],
              ),
            ),

  
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("📚  New Books",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/categories");
                    },
                    child: const Text("See All"),
                  )
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Image.asset(book["image"],
                        width: 50, fit: BoxFit.cover),
                    title: Text(book["title"],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text("Price: ${book["price"]}"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                   
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

 
  Widget _buildVendor(String name, String image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage(image)),
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class CategoryContent extends StatelessWidget {
  final TabController tabController;
  CategoryContent({required this.tabController, super.key});
  static final List<Map<String, dynamic>> allBooks = [ 
  { "image": "assets/images/novel1.jpg", "title": "The Alchemist", "price": "1500", "category": "novels", "vendor": "Paradise ", "rating": 4.7, "description": "Un roman philosophique de Paulo Coelho sur Santiago, un berger andalou, qui part à la recherche de sa légende personnelle et découvre le vrai sens du bonheur." },
   { "image": "assets/images/novel2.jpg", "title": "The Road Back To You", "price": "1200", "category": "novels", "vendor": "Reader's Haven", "rating": 4.2, "description": "Un guide unique qui explore la personnalité humaine à travers l’ennéagramme, aidant à mieux se connaître et à améliorer ses relations." },
    { "image": "assets/images/romance1.jpg", "title": "The Knight in Shining Armor", "price": "1800", "category": "romance", "vendor": "Librairie El Kitab", "rating": 4.5, "description": "Un roman romantique captivant qui raconte l’histoire d’un amour intemporel, rempli de sacrifices et de passion." }, 
    { "image": "assets/images/romance2.jpg", "title": "When Rivals Lose", "price": "1300", "category": "romance", "vendor": "Librarie El Fajr", "rating": 4.0, "description": "Une romance moderne pleine de rebondissements où deux rivaux découvrent que la frontière entre haine et amour est parfois très fine." },
     { "image": "assets/images/science1.jpg", "title": "The Meaning of Science", "price": "2000", "category": "science", "vendor": "Dar Al Kitab", "rating": 4.8, "description": "Un ouvrage fascinant qui explore la signification et la portée de la science dans notre compréhension du monde moderne." },
      { "image": "assets/images/science2.jpg", "title": "Making Sense of Science", "price": "1700", "category": "science", "vendor": "Knowledge House", "rating": 4.3, "description": "Un guide accessible qui rend la science compréhensible pour tous, avec des exemples concrets et des explications claires." },
       { "image": "assets/images/selflove1.png", "title": "When Things Fall Apart", "price": "1900", "category": "self love", "vendor": "Self Love Hub", "rating": 4.6, "description": "Un livre puissant qui montre comment accepter la douleur et transformer les moments difficiles en opportunités de croissance personnelle." },
        { "image": "assets/images/book_a.jpg", "title": "The Kite Runner", "price": "2900", "category": "novels", "vendor": "B&Co", "rating": 4.9, "description": "Un roman bouleversant de Khaled Hosseini qui raconte l’histoire de l’amitié et de la rédemption dans un Afghanistan en pleine mutation." },
         { "image": "assets/images/book_b.jpg", "title": "The Subtle Art of Not Giving a F*ck", "price": "1400", "category": "self love", "vendor": "Atlas", "rating": 4.4, "description": "Un guide franc et direct qui apprend à se concentrer sur ce qui compte vraiment dans la vie et à lâcher prise sur le reste." },
          { "image": "assets/images/book_c.jpg", "title": "The Da Vinci Code", "price": "1900", "category": "novels", "vendor": "Reader's Haven", "rating": 4.6, "description": "Un thriller palpitant de Dan Brown mêlant art, religion et énigmes secrètes autour d’un mystère millénaire." },
           { "image": "assets/images/book_d.jpg", "title": "The Good Sister", "price": "1700", "category": "novels", "vendor": "Paradise", "rating": 4.1, "description": "Un roman psychologique émouvant qui explore les secrets de famille, la loyauté et les liens complexes entre deux sœurs." },
  
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> booksByCategory(String category) {
      if (category.toLowerCase() == "all") return allBooks;
      return allBooks
          .where((book) =>
              book["category"].toLowerCase() == category.toLowerCase())
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Category",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Self Love"),
            Tab(text: "Science"),
            Tab(text: "Novels"),
            Tab(text: "Romance"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          GridPage(books: booksByCategory("all")),
          GridPage(books: booksByCategory("self love")),
          GridPage(books: booksByCategory("science")),
          GridPage(books: booksByCategory("novels")),
          GridPage(books: booksByCategory("romance")),
        ],
      ),
    );
  }
}


class GridPage extends StatelessWidget {
  final List<Map<String, dynamic>> books;
  const GridPage({required this.books, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.58,
      ),
      itemBuilder: (context, index) {
        final book = books[index];
        return GestureDetector(
          onTap: () {
           
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookDetailPage(
                  title: book["title"],
                  image: book["image"],
                  vendor: book["vendor"],
        description: book["description"],
        price: double.parse(book["price"]),
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    book["image"],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                book["title"],
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${book["price"]} DA",
                style:
                    const TextStyle(fontSize: 12, color: Colors.deepPurple),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BookDetailPage extends StatefulWidget {
  final String title;
  final String image;
  final String vendor;
  final String description;
  final double price;

  const BookDetailPage({
    super.key,
    required this.title,
    required this.image,
    required this.vendor,
    required this.description,
    required this.price,
  });

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}
class _BookDetailPageState extends State<BookDetailPage> {
  int quantity = 1;
  bool isLiked = false; 

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        wishlist.add({
          "title": widget.title,
          "image": widget.image,
          "vendor": widget.vendor,
          "description": widget.description,
          "price": widget.price,
        });
      } else {
        wishlist.removeWhere((book) => book["title"] == widget.title);
      }
    });
  }
 void addToCart() {
    final index = cartItems.indexWhere((item) => item["title"] == widget.title);
    if (index >= 0) {
     
      cartItems[index]["quantity"] += quantity;
    } else {
     
      cartItems.add({
        "title": widget.title,
        "price": widget.price,
        "image": widget.image,
        "quantity": quantity,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Book added to cart !")),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.white,
            ),
            onPressed: toggleLike,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                widget.image,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "Vendor: ${widget.vendor}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),

           
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange),
                const Icon(Icons.star, color: Colors.orange),
                const Icon(Icons.star, color: Colors.orange),
                const Icon(Icons.star, color: Colors.orange),
                const Icon(Icons.star_half, color: Colors.orange),
                const SizedBox(width: 8),
                Text("(4.5)", style: TextStyle(color: Colors.grey[600])),
              ],
            ),

            const SizedBox(height: 20),

           
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${widget.price.toStringAsFixed(0)} DA",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                    ),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 25),
Row(
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: () {
          addToCart(); 
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text("Add to Cart"),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartPage()), 
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text("View Cart"),
      ),
    ),
  ],
),
          ]
        ),),);}}



class VendorsPage extends StatelessWidget {
  const VendorsPage({super.key});

  final List<Map<String, dynamic>> vendors = const [
    {"name": "Paradise", "image": "assets/images/paradise.jpg", "rating": 4.8},
    {"name": "Reader's Haven", "image": "assets/images/readershaven.png", "rating": 4.6},
    {"name": "Atlas", "image": "assets/images/elatlas.png", "rating": 4.4},
    {"name": "Dar Al Kitab", "image": "assets/images/elkitab.png", "rating": 4.7},
    {"name": "Self Love Hub", "image": "assets/images/selflovehub.png", "rating": 4.3},
    {"name": "B&Co", "image": "assets/images/bandco.png", "rating": 4.5},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vendors"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: vendors.length,
          itemBuilder: (context, index) {
            final vendor = vendors[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(vendor["image"]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vendor["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (starIndex) => Icon(
                        Icons.star,
                        size: 16,
                        color: starIndex <
                                vendor["rating"].round() 
                            ? Colors.amber
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
} 

List<Map<String, dynamic>> wishlist = [];

// Wishlist Page
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  void removeFromWishlist(String title) {
    setState(() {
      wishlist.removeWhere((book) => book["title"] == title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wishlist",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: wishlist.isEmpty
          ? const Center(
              child: Text(
                "Your wishlist is empty.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final book = wishlist[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        book["image"],
                        width: 60,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      book["title"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text("${book["price"].toString()} DA"),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => removeFromWishlist(book["title"]),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookDetailPage(
                            title: book["title"],
                            image: book["image"],
                            vendor: book["vendor"],
                            description: book["description"],
                            price: book["price"],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}




List<Map<String, dynamic>> cartItems = [];


// ---------------- ProfilePage ----------------
class ProfilePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const ProfilePage({super.key, required this.toggleTheme});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "Utilisateur";
  String email = "";

  String location = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        userName = user.userMetadata?['full_name'] ?? "Utilisateur";
        location = user.userMetadata?['location'] ?? "";
        phone = user.userMetadata?['phone'] ?? "";
      });
    }
  }

  Widget buildOption(BuildContext context, String title, IconData icon,
      {VoidCallback? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),

            buildOption(context, "Modify my profil", Icons.person, onTap: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(
                    name: userName,
                    email: email,
                    location: location,
                    phone: phone,
                  ),
                ),
              );

              if (updated != null && updated is Map) {
                setState(() {
                  userName = updated["name"];
                  location = updated["location"];
                  phone = updated["phone"];
                
                });
              }
            }),

            SwitchListTile(
              title: const Text("Dark mode"),
              secondary: const Icon(Icons.dark_mode),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (val) => widget.toggleTheme(),
            ),

            buildOption(context, "Notifications", Icons.notifications,
                onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const NotificationSettingsPage()));
            }),

            buildOption(context, "My orders", Icons.book, onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()));
            }),

            buildOption(context, "Logout", Icons.logout, onTap: () async {
              await Supabase.instance.client.auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => SignInPage(toggleTheme: widget.toggleTheme)),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ---------------- EditProfilePage ----------------
class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String location;
  final String phone;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.location,
    required this.phone,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _locationController = TextEditingController(text: widget.location);
    _phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Information")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
          
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: TextEditingController(text: widget.email),
              decoration: const InputDecoration(labelText: "Email"),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "name": _nameController.text,
                  "location": _locationController.text,
                  "phone": _phoneController.text,
                });
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}



//  Notification Settings Page
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool notificationsEnabled = true;
  bool newBooks = true;
  bool promotions = false;
  bool messages = true;
  bool appUpdates = true;

  @override
  Widget build(BuildContext context) {
    Widget buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: Switch(value: value, onChanged: onChanged, focusColor: Colors.deepPurple),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSwitch("Active all notifications", notificationsEnabled, (val) {
              setState(() {
                notificationsEnabled = val;
                if (!val) newBooks = promotions = messages = appUpdates = false;
              });
            }),
            buildSwitch("New books", newBooks, (val) => setState(() => newBooks = val)),
            buildSwitch("Offers", promotions, (val) => setState(() => promotions = val)),
            buildSwitch("update my app", appUpdates, (val) => setState(() => appUpdates = val)),
          ],
        ),
      ),
    );
  }
}

//  Cart Page
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item["price"] * item["quantity"]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My orders ")),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your basket is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.asset(item["image"], width: 50, fit: BoxFit.cover),
                          title: Text(item["title"]),
                          subtitle: Text("${item["price"]} DA"),
                          trailing: SizedBox(
                            width: 130,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      if (item["quantity"] > 1) item["quantity"]--;
                                    });
                                  },
                                ),
                                Text(item["quantity"].toString()),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      item["quantity"]++;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      cartItems.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total: $totalPrice DA",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Order placed !")),
                          );
                        },
                        child: const Text("Order"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
//search page
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> results = [];

  @override
  void initState() {
    super.initState();
    results = CategoryContent.allBooks;
  }

  void _search(String query) {
    setState(() {
      if (query.isEmpty) {
        results = CategoryContent.allBooks;
      } else {
        results = CategoryContent.allBooks
            .where((book) =>
                book["title"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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
        title: const Text("Search Books"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type book title...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _search(_controller.text),
                ),
              ),
              onChanged: _search,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: results.isEmpty
                  ? const Center(child: Text("No results found"))
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final book = results[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Image.asset(
                              book["image"],
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(book["title"]),
                      
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookDetailPage(
                                    title: book["title"],
                                    image: book["image"],
                                    vendor: book["vendor"],
                                    description: book["description"],
                                    price: double.parse(book["price"]),
                                  ),
                                ),
                              );
                            },
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
}

// 🌟 Notification Page
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  // Liste de notifications fictives
  final List<Map<String, String>> notifications = const [
    {"title": "New Book Added", "message": "Check out 'The Alchemist' in our catalog."},
    {"title": "Discount Alert", "message": "Get 20% off on selected self-love books."},
    {"title": "Vendor Update", "message": "Reader's Haven has new arrivals."},
    {"title": "Reminder", "message": "You have 2 items in your cart waiting to be purchased."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text("No notifications yet."),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.notifications, color: Colors.deepPurple),
                    title: Text(
                      notif["title"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(notif["message"]!),
                    onTap: () {
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Tapped: ${notif["title"]}")),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
