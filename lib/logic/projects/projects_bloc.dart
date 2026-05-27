import 'package:flutter_bloc/flutter_bloc.dart';
import 'projects_event.dart';
import 'projects_state.dart';
import '../../data/models/project.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc() : super(const ProjectsState()) {
    on<LoadProjectsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      
      // Simulating loading from local DB (Removed delay for test stability)
      final mockProjects = [
        Project(
          id: '1',
          title: 'Birthday Invite',
          type: 'Preset Type',
          previewUrl: '',
          createdAt: DateTime.now(),
        ),
        Project(
          id: '2',
          title: 'Event Poster',
          type: 'Preset Type',
          previewUrl: '',
          createdAt: DateTime.now(),
        ),
      ];
      
      emit(state.copyWith(
        projects: mockProjects,
        saved: [mockProjects.first],
        drafts: [mockProjects.last],
        isLoading: false,
      ));
    });

    on<DeleteProjectEvent>((event, emit) {
      final updatedProjects = state.projects.where((p) => p.id != event.projectId).toList();
      final updatedSaved = state.saved.where((p) => p.id != event.projectId).toList();
      final updatedDrafts = state.drafts.where((p) => p.id != event.projectId).toList();
      
      emit(state.copyWith(
        projects: updatedProjects,
        saved: updatedSaved,
        drafts: updatedDrafts,
      ));
    });
  }
}
