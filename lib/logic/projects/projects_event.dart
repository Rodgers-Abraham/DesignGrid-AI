import 'package:equatable/equatable.dart';

abstract class ProjectsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProjectsEvent extends ProjectsEvent {}

class DeleteProjectEvent extends ProjectsEvent {
  final String projectId;
  DeleteProjectEvent(this.projectId);
  @override
  List<Object?> get props => [projectId];
}

class SearchProjectsEvent extends ProjectsEvent {
  final String query;
  SearchProjectsEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class SaveProjectEvent extends ProjectsEvent {
  final String title;
  final String type;
  final List<Map<String, dynamic>> layers;
  SaveProjectEvent({required this.title, required this.type, required this.layers});
  @override
  List<Object?> get props => [title, type, layers];
}
