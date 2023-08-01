import 'dart:ui';

extension RotationCanvas on Canvas {
  void centerPivot(Rect rect) {
    save();
    translate(rect.left + rect.width / 2, rect.top + rect.height / 2);
  }

  void resetPivot(Rect rect) {
    translate(
      -(rect.left + rect.width / 2),
      -(rect.top + rect.height / 2),
    );
    restore();
  }
}
