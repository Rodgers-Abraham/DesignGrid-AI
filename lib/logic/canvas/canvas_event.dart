import 'package:equatable/equatable.dart';
import '../../data/models/canvas_layer.dart';

abstract class CanvasEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ToggleEditorModeEvent extends CanvasEvent {}

class AddLayerEvent extends CanvasEvent {
  final CanvasLayer layer;
  AddLayerEvent(this.layer);
  @override
  List<Object?> get props => [layer];
}

class UpdateLayerEvent extends CanvasEvent {
  final CanvasLayer layer;
  UpdateLayerEvent(this.layer);
  @override
  List<Object?> get props => [layer];
}

class ClearCanvasEvent extends CanvasEvent {}
