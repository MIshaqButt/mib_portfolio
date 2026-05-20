import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationState {
  final int activeIndex;
  final double scrollProgress; // Optional, for advanced animations

  const NavigationState({
    required this.activeIndex,
    this.scrollProgress = 0.0,
  });

  NavigationState copyWith({
    int? activeIndex,
    double? scrollProgress,
  }) {
    return NavigationState(
      activeIndex: activeIndex ?? this.activeIndex,
      scrollProgress: scrollProgress ?? this.scrollProgress,
    );
  }
}

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(activeIndex: 0));

  void setSection(int index) {
    if (state.activeIndex != index) {
      emit(state.copyWith(activeIndex: index));
    }
  }

  void updateScrollProgress(double progress) {
    emit(state.copyWith(scrollProgress: progress));
  }
}
