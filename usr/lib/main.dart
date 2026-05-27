import 'package:flutter/material.dart';

void main() {
  runApp(const TranslationApp());
}

class TranslationApp extends StatelessWidget {
  const TranslationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TranslationHomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class TranslationHomePage extends StatefulWidget {
  const TranslationHomePage({super.key});

  @override
  State<TranslationHomePage> createState() => _TranslationHomePageState();
}

class _TranslationHomePageState extends State<TranslationHomePage> {
  String _sourceLanguage = 'English';
  String _targetLanguage = 'Spanish';
  final TextEditingController _sourceController = TextEditingController();
  String _translatedText = '';
  bool _isTranslating = false;

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
  ];

  void _translate() {
    if (_sourceController.text.trim().isEmpty) {
      setState(() {
        _translatedText = '';
      });
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    // Mock translation delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isTranslating = false;
          // Simple mock logic
          _translatedText =
              '[Mock $_targetLanguage Translation]\\n${_sourceController.text}';
        });
      }
    });
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;
      
      if (_translatedText.isNotEmpty && !_translatedText.startsWith('[Mock')) {
        _sourceController.text = _translatedText;
        _translatedText = '';
      } else {
        _sourceController.clear();
        _translatedText = '';
      }
    });
  }

  @override
  void dispose() {
    _sourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translator'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          if (isDesktop) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLanguageSelectors(),
          const SizedBox(height: 16),
          _buildSourceInput(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isTranslating ? null : _translate,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: _isTranslating
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Translate', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 16),
          _buildTargetOutput(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          _buildLanguageSelectors(),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildSourceInput()),
                const SizedBox(width: 32),
                Expanded(child: _buildTargetOutput()),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: _isTranslating ? null : _translate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: _isTranslating
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Translate', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelectors() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _sourceLanguage,
                isExpanded: true,
                items: _languages.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _sourceLanguage = newValue;
                    });
                  }
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            color: Theme.of(context).colorScheme.primary,
            onPressed: _swapLanguages,
            tooltip: 'Swap languages',
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _targetLanguage,
                isExpanded: true,
                alignment: AlignmentDirectional.centerEnd,
                items: _languages.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(value),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _targetLanguage = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceInput() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: TextField(
        controller: _sourceController,
        maxLines: null,
        expands: true,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: 'Enter text to translate',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: _sourceController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _sourceController.clear();
                      _translatedText = '';
                    });
                  },
                )
              : null,
        ),
        onChanged: (text) {
          setState(() {}); // Update to show/hide clear button
        },
      ),
    );
  }

  Widget _buildTargetOutput() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: SelectableText(
        _translatedText.isEmpty ? 'Translation will appear here' : _translatedText,
        style: TextStyle(
          fontSize: 16,
          color: _translatedText.isEmpty
              ? Theme.of(context).colorScheme.onSurfaceVariant
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
