import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/note_event.dart';
import '/bloc/note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteInitial()) {
    on<AddNote>((event, emit) {
      if (state is NoteLoaded) {
        final currentNotes = (state as NoteLoaded).notes;
        if (event.note.title.isEmpty || event.note.content.isEmpty) {
          emit(NoteError("Title and content cannot be empty"));
          emit(NoteLoaded(currentNotes));
          return;
        }
        emit(NoteLoaded([...currentNotes, event.note]));
      } else {
        emit(NoteLoaded([event.note]));
      }
    });

    on<DeleteNote>((event, emit) {
      if (state is NoteLoaded) {
        final currentNotes = (state as NoteLoaded).notes;
        final updatedNotes =
            currentNotes.where((note) => note.id != event.id).toList();
        if (updatedNotes.isEmpty) {
          emit(NoteError("No notes available"));
        } else {
          emit(NoteLoaded(updatedNotes));
        }
      }
    });

    on<UpdateNote>((event, emit) {
      if (state is NoteLoaded) {
        final currentNotes = (state as NoteLoaded).notes;
        final updatedNotes =
            currentNotes.map((note) {
              return note.id == event.note.id ? event.note : note;
            }).toList();
        emit(NoteLoaded(updatedNotes));
      }
    });
  }
}
