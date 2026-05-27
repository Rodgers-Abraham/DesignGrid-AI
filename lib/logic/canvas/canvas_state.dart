import 'package:equatable/equatable.dart';
import '../../data/models/canvas_layer.dart';

enum EditorMode { manual, aiCoPilot }

class CanvasState extends Equatable {
  final List<CanvasLayer> layers;
  final EditorMode mode;

  const CanvasState({
    this.layers = const [],
    this.mode = EditorMode.manual,
  });

  CanvasState copyWith({
    List<CanvasLayer>? layers,
    EditorMode? mode,
  }) {
    return CanvasState(
      layers: layers ?? this.layers,
      mode: mode ?? this.mode,
    );
  }

  @override
  List<Object?> get props => [layers, mode];
}
