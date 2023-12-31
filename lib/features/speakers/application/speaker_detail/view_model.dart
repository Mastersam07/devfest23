import 'package:devfest23/core/data/data.dart';
import 'package:devfest23/core/ui_state_model/ui_state_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ui_state.dart';

class SpeakerDetailsViewModel extends StateNotifier<SpeakerDetailsUiState> {
  final DevfestRepository _repo;

  SpeakerDetailsViewModel(this._repo) : super(SpeakerDetailsUiState.initial());

  void initialiseSpeaker(Speaker speaker) {
    state = state.copyWith(speaker: speaker);
  }

  void initialiseSession(Session session) {
    state = state.copyWith(session: session);
  }

  Future<void> reserveSessionOnTap(bool hasRsvped) async {
    assert(
      state.session.sessionId.isNotEmpty,
      'A valid session must be initialised before calling this function',
    );

    if (!hasRsvped) {
      await launch(state.ref, (model) async {
        state = model.setState(state.copyWith(viewState: ViewState.loading));
        final dto = RSVPSessionRequestDto(sessionId: state.session.sessionId);
        final result = await _repo.addToRSVP(dto);

        state = model.setState(result.fold(
          (left) => state.copyWith(viewState: ViewState.error, exception: left),
          (right) => state.copyWith(
            viewState: ViewState.success,
            session: state.session.copyWith(
              availableSeats: state.session.availableSeats - 1,
              hasRsvped: true,
            ),
          ),
        ));
      });
      state = state.copyWith(viewState: ViewState.idle);
      return;
    }

    await launch(state.ref, (model) async {
      state = model.setState(state.copyWith(viewState: ViewState.loading));
      final dto = RSVPSessionRequestDto(sessionId: state.session.sessionId);
      final result = await _repo.removeFromRSVP(dto);

      state = model.setState(
        result.fold(
          (left) => state.copyWith(viewState: ViewState.error, exception: left),
          (right) => state.copyWith(
            viewState: ViewState.success,
            session: state.session.copyWith(
              availableSeats: state.session.availableSeats + 1,
              hasRsvped: false,
            ),
          ),
        ),
      );
    });
    state = state.copyWith(viewState: ViewState.idle);
  }
}

final speakerDetailsViewModelProvider = StateNotifierProvider.autoDispose<
    SpeakerDetailsViewModel, SpeakerDetailsUiState>(
  (ref) => SpeakerDetailsViewModel(ref.read(devfestRepositoryProvider)),
);
