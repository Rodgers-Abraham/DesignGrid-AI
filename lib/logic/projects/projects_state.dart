import 'package:equatable/equatable.dart';
import '../../data/models/project.dart';

class ProjectsState extends Equatable {
  final List<Project> projects;
  final List<Project> saved;
  final List<Project> drafts;
  final bool isLoading;

  const ProjectsState({
    this.projects = const [],
    this.saved = const [],
    this.drafts = const [],
    this.isLoading = false,
  });

  ProjectsState copyWith({
    List<Project>? projects,
    List<Project>? saved,
    List<Project>? drafts,
    bool? isLoading,
  }) {
    return ProjectsState(
      projects: projects ?? this.projects,
      saved: saved ?? this.saved,
      drafts: drafts ?? this.drafts,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [projects, saved, drafts, isLoading];
}
