import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../logic/canvas/canvas_bloc.dart';
import '../../logic/canvas/canvas_event.dart';
import '../../logic/canvas/canvas_state.dart';
import '../../logic/projects/projects_bloc.dart';
import '../../logic/projects/projects_event.dart';
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
  bool _hasReferenceImage = false;

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

  Future<void> _showApiKeyDialog() async {
    final controller = TextEditingController(text: context.read<AuthBloc>().state.apiKey);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gemini API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('To use AI Co-pilot, you need a Google AI Studio API key.'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => launchUrl(Uri.parse('https://aistudio.google.com/app/apikey')),
              child: const Text(
                'Get your key here →',
                style: TextStyle(color: AppColors.primaryAmber, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Paste API Key here',
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('API Key stored securely.')),
                );
              }
            },
            child: const Text('Save Key'),
          ),
        ],
      ),
    );
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
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => context.go('/'),
            ),
            title: const Text('AI Creator Studio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.key_outlined, color: AppColors.primaryAmber),
                onPressed: _showApiKeyDialog,
              ),
              IconButton(
                icon: const Icon(Icons.save_outlined, color: AppColors.primaryAmber),
                onPressed: () {
                  if (state.layers.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Generate something before saving!')),
                    );
                    return;
                  }
                  context.read<ProjectsBloc>().add(SaveProjectEvent(
                        title: 'AI Design ${DateTime.now().hour}:${DateTime.now().minute}',
                        type: _selectedPreset,
                        layers: state.layers.map((l) => l.toMap()).toList(),
                      ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Project saved to cloud!')),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('1. Select Format', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildPresetGrid(),
                const SizedBox(height: 24),
                const Text('2. Reference Image (Optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildImageUploadSection(),
                const SizedBox(height: 24),
                const Text('3. Design Prompt', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildAiPromptSection(),
                const SizedBox(height: 24),
                const Text('4. Preview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildCanvas(state.layers),
                const SizedBox(height: 48),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageUploadSection() {
    return GestureDetector(
      onTap: () {
        setState(() => _hasReferenceImage = !_hasReferenceImage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_hasReferenceImage ? 'Image uploaded!' : 'Image removed.')),
        );
      },
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hasReferenceImage ? AppColors.primaryAmber : Colors.white.withOpacity(0.1),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: _hasReferenceImage
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://placeholder.com/600x200',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.refresh, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, color: AppColors.textSecondary, size: 32),
                  const SizedBox(height: 8),
                  Text('Tap to upload reference image', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
      ),
    );
  }

  Widget _buildCanvas(List<CanvasLayer> layers) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: AppColors.surface,
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
          children: [
            if (layers.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome_outlined, color: AppColors.primaryAmber.withOpacity(0.2), size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Your AI design will appear here',
                      style: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
            ...layers.map((layer) => _buildLayer(layer)).toList(),
          ],
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
      height: 90,
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
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
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

  Widget _buildAiPromptSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: TextField(
            controller: _promptController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Describe your design idea...',
              hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.4), fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              final authState = context.read<AuthBloc>().state;
              if (authState.apiKey == null || authState.apiKey!.isEmpty) {
                _showApiKeyDialog();
              } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gemini is processing your request...')),
                  );
                 _addLayer(LayerType.text, _promptController.text.isNotEmpty ? _promptController.text : 'AI Design Result');
              }
            },
            icon: const Icon(Icons.auto_awesome, color: Colors.black, size: 18),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAmber,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            label: const Text(
              'Generate Design',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
