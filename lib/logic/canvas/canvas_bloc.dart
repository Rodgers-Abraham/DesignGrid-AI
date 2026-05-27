import 'package:flutter_bloc/flutter_bloc.dart';
import 'canvas_event.dart';
import 'canvas_state.dart';
import '../../data/models/canvas_layer.dart';

class CanvasBloc extends Bloc<CanvasEvent, CanvasState> {
  CanvasBloc() : super(const CanvasState()) {
    on<ToggleEditorModeEvent>((event, emit) {
      final newMode = state.mode == EditorMode.manual 
          ? EditorMode.aiCoPilot 
          : EditorMode.manual;
      emit(state.copyWith(mode: newMode));
    });

    on<AddLayerEvent>((event, emit) {
      final updatedLayers = List<CanvasLayer>.from(state.layers)..add(event.layer);
      emit(state.copyWith(layers: updatedLayers));
    });

    on<UpdateLayerEvent>((event, emit) {
      final updatedLayers = state.layers.map((l) {
        return l.id == event.layer.id ? event.layer : l;
      }).toList();
      emit(state.copyWith(layers: updatedLayers));
    });

    on<ClearCanvasEvent>((event, emit) {
      emit(state.copyWith(layers: []));
    });
  }
}
