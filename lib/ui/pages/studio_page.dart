import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/canvas/canvas_bloc.dart';
import '../../logic/canvas/canvas_event.dart';
import '../../logic/canvas/canvas_state.dart';

class StudioPage extends StatefulWidget {
  const StudioPage({super.key});

  @override
  State<StudioPage> createState() => _StudioPageState();
}

class _StudioPageState extends State<StudioPage> {
  String _selectedPreset = 'Business Cards';

  final List<Map<String, dynamic>> _presets = [
    {'name': 'Business Cards', 'ratio': '3.5:2', 'icon': Icons.contact_mail_outlined},
    {'name': 'Event Invites', 'ratio': '5:7', 'icon': Icons.event_note_outlined},
    {'name': 'Promo Posters', 'ratio': '4:5', 'icon': Icons.campaign_outlined},
    {'name': 'Web Banners', 'ratio': '16:9', 'icon': Icons.web_outlined},
    {'name': 'Greeting Cards', 'ratio': '9:0', 'icon': Icons.card_giftcard_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasBloc, CanvasState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Creator Studio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Preset Gallery', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildPresetGrid(),
                    const SizedBox(height: 32),
                    _buildModeToggle(state.mode),
                    const SizedBox(height: 32),
                    if (state.mode == EditorMode.aiCoPilot) _buildAiCoPilotSection() else _buildManualEditorPlaceholder(),
                    const SizedBox(height: 120), // Space for footer
                  ],
                ),
              ),
              Positioned(
                bottom: 100, // Adjusted to be above the bottom nav
                left: 0,
                right: 0,
                child: _buildEditorFooter(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPresetGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _presets.length,
      itemBuilder: (context, index) {
        final preset = _presets[index];
        final isSelected = _selectedPreset == preset['name'];
        return GestureDetector(
          onTap: () => setState(() => _selectedPreset = preset['name']!),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryAmber : Colors.white.withOpacity(0.05),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      preset['icon'],
                      color: isSelected ? AppColors.primaryAmber : AppColors.textSecondary,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                preset['name'],
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '(${preset['ratio']})',
                style: TextStyle(fontSize: 9, color: AppColors.textSecondary.withOpacity(0.6)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeToggle(EditorMode currentMode) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(27),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: currentMode == EditorMode.manual ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.44,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: currentMode == EditorMode.manual ? Colors.white.withOpacity(0.05) : AppColors.primaryAmber,
                borderRadius: BorderRadius.circular(23),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.read<CanvasBloc>().add(ToggleEditorModeEvent()),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Manual Editing',
                      style: TextStyle(
                        color: currentMode == EditorMode.manual ? Colors.white : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => context.read<CanvasBloc>().add(ToggleEditorModeEvent()),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'AI Co-pilot Mode',
                      style: TextStyle(
                        color: currentMode == EditorMode.aiCoPilot ? Colors.black : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiCoPilotSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Prompt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Icon(Icons.add, color: AppColors.textSecondary, size: 20),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Text(
            'e.g., Elegant watercolor floral design for a wedding invite',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAmber,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              'Generate with Gemini',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManualEditorPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gesture, color: AppColors.primaryAmber.withOpacity(0.5), size: 48),
            const SizedBox(height: 12),
            Text(
              'Interactive Canvas Active',
              style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorFooter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C23),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildToolItem(Icons.text_fields, 'Text'),
          _buildToolItem(Icons.pentagon_outlined, 'Shapes'),
          _buildToolItem(Icons.image_outlined, 'Image'),
          _buildToolItem(Icons.layers_outlined, 'Layout'),
        ],
      ),
    );
  }

  Widget _buildToolItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}
