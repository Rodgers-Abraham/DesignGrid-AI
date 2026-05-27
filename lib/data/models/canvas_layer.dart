import 'package:equatable/equatable.dart';

enum LayerType { text, shape, image }

class CanvasLayer extends Equatable {
  final String id;
  final LayerType type;
  final String content;
  final double x;
  final double y;
  final double scale;

  const CanvasLayer({
    required this.id,
    required this.type,
    required this.content,
    this.x = 0,
    this.y = 0,
    this.scale = 1.0,
  });

  CanvasLayer copyWith({
    String? content,
    double? x,
    double? y,
    double? scale,
  }) {
    return CanvasLayer(
      id: id,
      type: type,
      content: content ?? this.content,
      x: x ?? this.x,
      y: y ?? this.y,
      scale: scale ?? this.scale,
    );
  }

  @override
  List<Object?> get props => [id, type, content, x, y, scale];
}
