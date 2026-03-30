double calculatePlayerPoints(bool isCaptain, bool isVC, double basePoints) {
    if (isCaptain) {
      return basePoints * 2.0; // Captain: 2x multiplier
    } else if (isVC) {
      return basePoints * 1.5; // Vice-Captain: 1.5x multiplier
    } else {
      return basePoints * 1.0; // Regular player: 1x multiplier
    }
  }