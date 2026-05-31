import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'projects_event.dart';
import 'projects_state.dart';
import '../../data/models/project.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProjectsBloc() : super(const ProjectsState()) {
    on<LoadProjectsEvent>((event, emit) async {
      final user = _auth.currentUser;
      if (user == null) {
        emit(const ProjectsState(projects: [], saved: [], drafts: []));
        return;
      }

      emit(state.copyWith(isLoading: true));
      
      try {
        final snapshot = await _firestore
            .collection('projects')
            .where('user_id', isEqualTo: user.uid)
            .orderBy('created_at', descending: true)
            .get();

        final projects = snapshot.docs.map((doc) {
          final data = doc.data();
          return Project(
            id: doc.id,
            title: data['title'] ?? 'Untitled',
            type: data['type'] ?? 'Custom',
            previewUrl: data['preview_url'] ?? '',
            createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
          );
        }).toList();
        
        emit(state.copyWith(
          projects: projects,
          saved: projects.take(1).toList(), // Example logic
          drafts: projects.skip(1).toList(),
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<SearchProjectsEvent>((event, emit) {
      if (event.query.isEmpty) {
        add(LoadProjectsEvent());
        return;
      }

      final filtered = state.projects.where((p) {
        return p.title.toLowerCase().contains(event.query.toLowerCase());
      }).toList();

      emit(state.copyWith(
        projects: filtered,
      ));
    });

    on<DeleteProjectEvent>((event, emit) async {
      try {
        await _firestore.collection('projects').doc(event.projectId).delete();
        add(LoadProjectsEvent()); // Refresh list
      } catch (e) {
        // Handle error
      }
    });
  }
}
