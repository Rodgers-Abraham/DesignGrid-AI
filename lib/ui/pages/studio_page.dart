import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../logic/canvas/canvas_bloc.dart';
import '../../logic/canvas/canvas_event.dart';
import '../../logic/canvas/canvas_state.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_event.dart';
import '../../logic/auth/auth_state.dart';
import '../../data/models/canvas_layer.dart';

class StudioPage extends StatefulWidget {
  const StudioPage({super.key});

  @override
  State<StudioPage> createState() => _StudioPageState();
}

class _StudioPageState extends State<StudioPage> {
  String _selectedPreset = 'Business Cards';
  final TextEditingController _promptController = TextEditingController();

  final List<Map<String, dynamic>> _presets = [
    {'name': 'Business Cards', 'ratio': '3.5:2', 'icon': Icons.contact_mail_outlined},
    {'name': 'Event Invites', 'ratio': '5:7', 'icon': Icons.event_note_outlined},
    {'name': 'Promo Posters', 'ratio': '4:5', 'icon': Icons.campaign_outlined},
    {'name': 'Web Banners', 'ratio': '16:9', 'icon': Icons.web_outlined},
    {'name': 'Greeting Cards', 'ratio': '9:0', 'icon': Icons.card_giftcard_outlined},
  ];

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _handleModeChange(EditorMode mode) {
    if (mode == EditorMode.aiCoPilot) {
      final authState = context.read<AuthBloc>().state;
      if (authState.apiKey == null || authState.apiKey!.isEmpty) {
        _showApiKeyDialog();
      }
    }
    context.read<CanvasBloc>().add(ToggleEditorModeEvent());
  }

  Future<void> _showApiKeyDialog() async {
    final controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gemini API Key Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('To use AI Co-pilot features, please enter your Google AI Studio API key.'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter API Key',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<AuthBloc>().add(UpdateApiKeyLibraryEvent(controller.text));
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _requestImagePermissions() async {
    final status = await Permission.photos.request();
    if (status.isDenied) {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gallery permission is required to add images.')),
        );
    } else {
      _addLayer(LayerType.image, 'New Image');
    }
  }

  void _addLayer(LayerType type, String content) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newLayer = CanvasLayer(
      id: id,
      type: type,
      content: content,
      x: 100.0 + (math.Random().nextDouble() * 50),
      y: 100.0 + (math.Random().nextDouble() * 50),
    );
    context.read<CanvasBloc>().add(AddLayerEvent(newLayer));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasBloc, CanvasState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: context.canPop()
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  )
                : null,
            title: const Text('Creator Studio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () => context.read<CanvasBloc>().add(ClearCanvasEvent()),
              ),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Preset Gallery', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildPresetGrid(),
                        const SizedBox(height: 24),
                        _buildModeToggle(state.mode),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  Expanded(
                    child: state.mode == EditorMode.manual 
                        ? _buildCanvas(state.layers)
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: _buildAiCoPilotSection(),
                          ),
                  ),
                  const SizedBox(height: 120), // Space for footer
                ],
              ),
              Positioned(
                bottom: 100,
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

  Widget _buildCanvas(List<CanvasLayer> layers) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: layers.map((layer) => _buildLayer(layer)).toList(),
        ),
      ),
    );
  }

  Widget _buildLayer(CanvasLayer layer) {
    return Positioned(
      left: layer.x,
      top: layer.y,
      child: GestureDetector(
        onPanUpdate: (details) {
          final updatedLayer = layer.copyWith(
            x: layer.x + details.delta.dx,
            y: layer.y + details.delta.dy,
          );
          context.read<CanvasBloc>().add(UpdateLayerEvent(updatedLayer));
        },
        child: _renderLayerContent(layer),
      ),
    );
  }

  Widget _renderLayerContent(CanvasLayer layer) {
    switch (layer.type) {
      case LayerType.text:
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryAmber.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            layer.content,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      case LayerType.shape:
        return Container(
          width: 80 * layer.scale,
          height: 80 * layer.scale,
          decoration: BoxDecoration(
            color: AppColors.primaryAmber.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.star, color: AppColors.primaryAmber),
        );
      case LayerType.image:
        return Container(
          width: 120 * layer.scale,
          height: 90 * layer.scale,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: NetworkImage('https://placeholder.com/120x90'),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(child: Icon(Icons.image_outlined)),
        );
    }
  }

  Widget _buildPresetGrid() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _presets.length,
        itemBuilder: (context, index) {
          final preset = _presets[index];
          final isSelected = _selectedPreset == preset['name'];
          return GestureDetector(
            onTap: () {
              setState(() => _selectedPreset = preset['name']!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Initialized ${preset['name']} canvas (${preset['ratio']})')),
              );
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
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
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    preset['name'],
                    style: TextStyle(
                      fontSize: 8,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModeToggle(EditorMode currentMode) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(27),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: currentMode == EditorMode.manual ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.42,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: currentMode == EditorMode.manual ? (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)) : AppColors.primaryAmber,
                borderRadius: BorderRadius.circular(23),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (currentMode != EditorMode.manual) _handleModeChange(EditorMode.manual);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Manual Editing',
                      style: TextStyle(
                        color: currentMode == EditorMode.manual ? (isDark ? Colors.white : Colors.black) : theme.textTheme.bodySmall?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (currentMode != EditorMode.aiCoPilot) _handleModeChange(EditorMode.aiCoPilot);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'AI Co-pilot Mode',
                      style: TextStyle(
                        color: currentMode == EditorMode.aiCoPilot ? Colors.black : theme.textTheme.bodySmall?.color,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Prompt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.add, color: theme.textTheme.bodySmall?.color, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
            ),
            child: TextField(
              controller: _promptController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g., Elegant watercolor floral design for a wedding invite',
                hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color?.withOpacity(0.6), fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                final authState = context.read<AuthBloc>().state;
                if (authState.apiKey == null || authState.apiKey!.isEmpty) {
                  _showApiKeyDialog();
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Connecting to Gemini...')),
                  );
                }
              },
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
          _buildToolItem(Icons.text_fields, 'Text', onTap: () => _addLayer(LayerType.text, 'New Text')),
          _buildToolItem(Icons.pentagon_outlined, 'Shapes', onTap: () => _addLayer(LayerType.shape, 'New Shape')),
          _buildToolItem(Icons.image_outlined, 'Image', onTap: _requestImagePermissions),
          _buildToolItem(Icons.layers_outlined, 'Layout', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildToolItem(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
