import 'package:equatable/equatable.dart';
import '../../data/models/project.dart';

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
