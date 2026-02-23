import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nexus_gym/core/theme/app_colors.dart';
import 'package:nexus_gym/core/theme/app_text_styles.dart';
import 'package:nexus_gym/core/widgets/neumorphic_button.dart';
import 'package:nexus_gym/core/widgets/neumorphic_container.dart';
import 'package:nexus_gym/core/widgets/shared_widgets.dart';
import 'package:nexus_gym/features/nutrition/data/services/food_recognition_service.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isAnalyzing = false;
  final _recognitionService = FoodRecognitionService();
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Food Scan Logic
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _showScanOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard.withValues(alpha: 0.95),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: const Border(
                top: BorderSide(color: AppColors.glassBorder, width: 1.5),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.glassBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (b) => AppColors.emeraldGradient
                      .createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
                  child: const Icon(LucideIcons.scanLine,
                      size: 36, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  'Scan Your Food',
                  style:
                      AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  'Take a photo or choose from gallery\nto estimate calories and macros instantly.',
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyles.bodyM.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: _scanOption(
                        icon: LucideIcons.camera,
                        label: 'Camera',
                        gradient: AppColors.emeraldGradient,
                        onTap: () {
                          Navigator.pop(context);
                          _pickAndAnalyze(ImageSource.camera);
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _scanOption(
                        icon: LucideIcons.image,
                        label: 'Gallery',
                        gradient: AppColors.primaryGradient,
                        onTap: () {
                          Navigator.pop(context);
                          _pickAndAnalyze(ImageSource.gallery);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scanOption({
    required IconData icon,
    required String label,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(label,
                style: AppTextStyles.labelL.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndAnalyze(ImageSource source) async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
      );
      if (picked == null || !mounted) return;

      setState(() => _isAnalyzing = true);

      final result = await _recognitionService.analyzeFood(File(picked.path));

      if (!mounted) return;
      setState(() => _isAnalyzing = false);

      if (result.isSuccessful) {
        _showFoodResultSheet(result);
      } else {
        _showErrorSnackbar(result.errorMessage ?? 'Analysis failed.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isAnalyzing = false);
      _showErrorSnackbar('Could not open camera/gallery. Check permissions.');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.alertCircle,
                color: AppColors.accentRose, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message,
                  style: AppTextStyles.bodyS
                      .copyWith(color: AppColors.textPrimary)),
            ),
          ],
        ),
        backgroundColor: AppColors.backgroundCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showFoodResultSheet(FoodRecognitionResult result) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (_, scrollCtrl) => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundCard.withValues(alpha: 0.97),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                border: const Border(
                  top: BorderSide(color: AppColors.glassBorder, width: 1.5),
                ),
              ),
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.glassBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppColors.emeraldGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentEmerald
                                  .withValues(alpha: 0.35),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: const Icon(LucideIcons.salad,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Food Detected',
                                style: AppTextStyles.labelS
                                    .copyWith(color: AppColors.accentEmerald)),
                            Text(
                              result.dishName,
                              style: AppTextStyles.h3
                                  .copyWith(color: AppColors.textPrimary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    result.portionEstimate,
                    style: AppTextStyles.bodyS
                        .copyWith(color: AppColors.textMuted),
                  ),

                  const SizedBox(height: 24),

                  // Calorie big number
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accentEmerald.withValues(alpha: 0.12),
                          AppColors.primaryCyan.withValues(alpha: 0.06),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accentEmerald.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (b) => AppColors.emeraldGradient
                              .createShader(
                                  Rect.fromLTWH(0, 0, b.width, b.height)),
                          child: const Icon(LucideIcons.flame,
                              size: 32, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${result.calories}',
                          style: AppTextStyles.displayL.copyWith(
                            color: AppColors.textPrimary,
                            fontFamily: 'Rajdhani',
                          ),
                        ),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            'kcal',
                            style: AppTextStyles.h4
                                .copyWith(color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Macros
                  Text('Macronutrients',
                      style: AppTextStyles.labelL
                          .copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),

                  _resultMacroBar(
                    label: 'Protein',
                    value: result.proteinG,
                    unit: 'g',
                    color: AppColors.primaryViolet,
                    icon: LucideIcons.beef,
                  ),
                  const SizedBox(height: 10),
                  _resultMacroBar(
                    label: 'Carbs',
                    value: result.carbsG,
                    unit: 'g',
                    color: AppColors.accentGold,
                    icon: LucideIcons.wheat,
                  ),
                  const SizedBox(height: 10),
                  _resultMacroBar(
                    label: 'Fats',
                    value: result.fatsG,
                    unit: 'g',
                    color: AppColors.accentCoral,
                    icon: LucideIcons.droplets,
                  ),

                  if (result.ingredients.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Detected Ingredients',
                        style: AppTextStyles.labelL
                            .copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: result.ingredients.map((ing) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSurface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Text(
                            ing,
                            style: AppTextStyles.labelS
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // Log meal button
                  NeumorphicButton(
                    label: 'Log This Meal',
                    onPressed: () => Navigator.pop(context),
                    style: NeuButtonStyle.primary,
                    icon: LucideIcons.clipboardCheck,
                    isFullWidth: true,
                    height: 54,
                  ),

                  const SizedBox(height: 12),

                  NeumorphicButton(
                    label: 'Scan Again',
                    onPressed: () {
                      Navigator.pop(context);
                      _showScanOptions();
                    },
                    style: NeuButtonStyle.ghost,
                    icon: LucideIcons.refreshCw,
                    isFullWidth: true,
                    height: 48,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultMacroBar({
    required String label,
    required double value,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    // Rough max values for bar proportion display
    final maxMap = {'Protein': 200.0, 'Carbs': 300.0, 'Fats': 100.0};
    final fraction = (value / (maxMap[label] ?? 200)).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(label,
                  style: AppTextStyles.labelS
                      .copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              Text(
                '${value.toStringAsFixed(1)}$unit',
                style: AppTextStyles.labelM
                    .copyWith(color: color, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: AppColors.backgroundCard,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      floatingActionButton: _buildScanFab(),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            backgroundColor: AppColors.backgroundDark,
            title: GradientText(
              'Smart Nutrition',
              style: AppTextStyles.h2.copyWith(color: Colors.white),
              gradient: AppColors.emeraldGradient,
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.accentEmerald,
              tabs: const [
                Tab(text: 'Today'),
                Tab(text: 'Meal Plan'),
                Tab(text: 'Calculator'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTodayTab(),
            _buildMealPlanTab(),
            _buildCalculatorTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildScanFab() {
    return GestureDetector(
      onTap: _isAnalyzing ? null : _showScanOptions,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: _isAnalyzing ? null : AppColors.emeraldGradient,
          color: _isAnalyzing ? AppColors.backgroundCard : null,
          borderRadius: BorderRadius.circular(28),
          boxShadow: _isAnalyzing
              ? []
              : [
                  BoxShadow(
                    color: AppColors.accentEmerald.withValues(alpha: 0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
          border:
              _isAnalyzing ? Border.all(color: AppColors.glassBorder) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isAnalyzing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.accentEmerald),
                    ),
                  )
                : const Icon(LucideIcons.scanLine,
                    color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              _isAnalyzing ? 'Analyzing...' : 'Scan Food',
              style: AppTextStyles.labelL.copyWith(
                color: _isAnalyzing ? AppColors.accentEmerald : Colors.white,
              ),
            ),
          ],
        ),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
          duration: 3000.ms,
          color: Colors.white.withValues(alpha: 0.1),
        );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Today Tab
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildTodayTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMacroRing(),
          const SizedBox(height: 24),
          _buildMacroBreakdown(),
          const SizedBox(height: 24),
          _buildMealsList(),
        ],
      ),
    );
  }

  Widget _buildMacroRing() {
    return NeumorphicContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 16,
                      backgroundColor: AppColors.backgroundSurface,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.backgroundSurface),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: CircularProgressIndicator(
                      value: 0.72,
                      strokeWidth: 16,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.accentEmerald),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '1,840',
                        style: AppTextStyles.h2
                            .copyWith(color: AppColors.textPrimary),
                      ),
                      Text(
                        'kcal',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textMuted),
                      ),
                      Text(
                        '/ 2,550',
                        style: AppTextStyles.bodyS
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _macroRow('Protein', 148, 180, AppColors.primaryElectricBlue),
                  const SizedBox(height: 12),
                  _macroRow('Carbs', 200, 280, AppColors.accentGold),
                  const SizedBox(height: 12),
                  _macroRow('Fats', 62, 85, AppColors.accentCoral),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          NeumorphicButton(
            label: 'Generate AI Meal Plan',
            onPressed: () {},
            style: NeuButtonStyle.primary,
            icon: LucideIcons.sparkles,
            isFullWidth: true,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _macroRow(String label, int current, int target, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label,
                style: AppTextStyles.labelS
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${current}g / ${target}g',
          style: AppTextStyles.labelM.copyWith(color: color),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: current / target,
              backgroundColor: AppColors.backgroundSurface,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMacroBreakdown() {
    final foods = [
      ('Chicken Breast 200g', 330, 62, 0, 7, '🍗'),
      ('Brown Rice 150g', 195, 5, 40, 2, '🍚'),
      ('Broccoli 200g', 68, 6, 11, 1, '🥦'),
      ('Protein Shake', 180, 30, 10, 3, '🥤'),
      ('Greek Yogurt 200g', 146, 20, 11, 4, '🫙'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Food Log",
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        ...foods.asMap().entries.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowDark.withValues(alpha: 0.4),
                    offset: const Offset(3, 3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(e.value.$6, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(e.value.$1,
                        style: AppTextStyles.bodyM
                            .copyWith(color: AppColors.textPrimary)),
                  ),
                  Text('${e.value.$2} kcal',
                      style: AppTextStyles.labelM
                          .copyWith(color: AppColors.accentEmerald)),
                ],
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: e.key * 80))),
      ],
    );
  }

  Widget _buildMealsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Meal Schedule',
                style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
            NeumorphicButton(
              label: 'Add Meal',
              onPressed: () {},
              style: NeuButtonStyle.ghost,
              icon: LucideIcons.plus,
              width: 110,
              height: 36,
              borderRadius: 12,
              textStyle: AppTextStyles.labelM,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...[
          'Breakfast • 7:00 AM',
          'Pre-Workout • 12:00 PM',
          'Post-Workout • 3:00 PM',
          'Dinner • 7:00 PM'
        ].asMap().entries.map((e) => _mealSlot(e.value, e.key)),
      ],
    );
  }

  Widget _mealSlot(String label, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentEmerald.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(LucideIcons.utensils,
                color: AppColors.accentEmerald, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style:
                    AppTextStyles.bodyM.copyWith(color: AppColors.textPrimary)),
          ),
          const Icon(LucideIcons.plusCircle,
              color: AppColors.textMuted, size: 22),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 100));
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Meal Plan Tab
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildMealPlanTab() {
    final meals = [
      ('Monday', '🐔 Chicken, Rice, Salad', 2450),
      ('Tuesday', '🥩 Beef Stir-Fry, Quinoa', 2380),
      ('Wednesday', '🍣 Salmon, Sweet Potato', 2520),
      ('Thursday', '🫘 Lentil Soup, Eggs', 2200),
      ('Friday', '🥚 Omelette, Brown Rice', 2300),
      ('Saturday', '🍗 Turkey, Pasta, Greens', 2650),
      ('Sunday', '🥗 Rest & Recovery Day', 2000),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      itemCount: meals.length,
      itemBuilder: (_, i) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowDark.withValues(alpha: 0.5),
              offset: const Offset(4, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                gradient: AppColors.emeraldGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meals[i].$1,
                      style: AppTextStyles.labelM
                          .copyWith(color: AppColors.accentEmerald)),
                  const SizedBox(height: 4),
                  Text(meals[i].$2,
                      style: AppTextStyles.bodyM
                          .copyWith(color: AppColors.textPrimary)),
                ],
              ),
            ),
            Text('${meals[i].$3} kcal',
                style: AppTextStyles.labelM
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: i * 80)),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Calculator Tab
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildCalculatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Macro Calculator',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(
            'Your personalized macros based on your goal, weight, and activity level.',
            style: AppTextStyles.bodyM.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ...['Build Muscle', 'Lose Fat', 'Maintain Weight'].map((goal) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowDark.withValues(alpha: 0.5),
                    offset: const Offset(4, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal,
                      style: AppTextStyles.h4
                          .copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _macroTarget(
                          'Protein',
                          goal == 'Build Muscle'
                              ? '180g'
                              : goal == 'Lose Fat'
                                  ? '200g'
                                  : '160g',
                          AppColors.primaryElectricBlue),
                      _macroTarget(
                          'Carbs',
                          goal == 'Build Muscle'
                              ? '280g'
                              : goal == 'Lose Fat'
                                  ? '180g'
                                  : '240g',
                          AppColors.accentGold),
                      _macroTarget(
                          'Fats',
                          goal == 'Build Muscle'
                              ? '75g'
                              : goal == 'Lose Fat'
                                  ? '60g'
                                  : '70g',
                          AppColors.accentCoral),
                      _macroTarget(
                          'Calories',
                          goal == 'Build Muscle'
                              ? '2,550'
                              : goal == 'Lose Fat'
                                  ? '2,000'
                                  : '2,300',
                          AppColors.accentEmerald),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _macroTarget(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h4.copyWith(color: color)),
        Text(label,
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
      ],
    );
  }
}
