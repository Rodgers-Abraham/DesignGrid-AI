import 'package:flutter_test/flutter_test.dart';
import 'package:designgrid_ai/logic/canvas/canvas_bloc.dart';
import 'package:designgrid_ai/logic/canvas/canvas_event.dart';
import 'package:designgrid_ai/logic/canvas/canvas_state.dart';
import 'package:designgrid_ai/data/models/canvas_layer.dart';

void main() {
  group('CanvasBloc Tests', () {
    late CanvasBloc canvasBloc;

    setUp(() {
      canvasBloc = CanvasBloc();
    });

    tearDown(() {
      canvasBloc.close();
    });

    test('initial state is aiCoPilot mode with no layers', () {
      expect(canvasBloc.state.mode, EditorMode.aiCoPilot);
      expect(canvasBloc.state.layers, isEmpty);
    });

    test('ToggleEditorModeEvent switches modes', () {
      canvasBloc.add(ToggleEditorModeEvent());
      expectLater(canvasBloc.stream, emits(const CanvasState(mode: EditorMode.manual)));
    });

    test('AddLayerEvent adds a layer', () {
      const layer = CanvasLayer(id: '1', type: LayerType.text, content: 'Hello');
      canvasBloc.add(AddLayerEvent(layer));
      expectLater(canvasBloc.stream, emits(const CanvasState(layers: [layer], mode: EditorMode.aiCoPilot)));
    });
  });
}
