import 'package:flutter_bloc/flutter_bloc.dart';
import 'projects_event.dart';
import 'projects_state.dart';
import '../../data/models/project.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  List<Project> _allProjects = [];

  ProjectsBloc() : super(const ProjectsState()) {
    on<LoadProjectsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      
      // Simulating loading from local DB
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
      
      _allProjects = mockProjects;
      
      emit(state.copyWith(
        projects: _allProjects,
        saved: [_allProjects.first],
        drafts: [_allProjects.last],
        isLoading: false,
      ));
    });

    on<SearchProjectsEvent>((event, emit) {
      if (event.query.isEmpty) {
        emit(state.copyWith(
          projects: _allProjects,
          saved: _allProjects.where((p) => p.id == '1').toList(),
          drafts: _allProjects.where((p) => p.id == '2').toList(),
        ));
        return;
      }

      final filtered = _allProjects.where((p) {
        return p.title.toLowerCase().contains(event.query.toLowerCase());
      }).toList();

      emit(state.copyWith(
        projects: filtered,
        saved: filtered.where((p) => p.id == '1').toList(),
        drafts: filtered.where((p) => p.id == '2').toList(),
      ));
    });

    on<DeleteProjectEvent>((event, emit) {
      _allProjects.removeWhere((p) => p.id == event.projectId);
      
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
