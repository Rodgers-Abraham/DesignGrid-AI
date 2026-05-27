import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String title;
  final String type;
  final String previewUrl;
  final DateTime createdAt;

  const Project({
    required this.id,
    required this.title,
    required this.type,
    required this.previewUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, type, previewUrl, createdAt];
}
