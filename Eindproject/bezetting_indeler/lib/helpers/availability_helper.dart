enum Availability {
  AVAILABLE,
  NOT_SURE,
  NOT_AVAILABLE,
}

class AvailabilityHelper {
  static Availability transLateAvailabilityToEnum(String availability) {
    switch (availability) {
      case 'Beschikbaar':
        return Availability.AVAILABLE;
        break;
      case 'Niet zeker':
        return Availability.NOT_SURE;
        break;
      case 'Niet beschikbaar':
        return Availability.NOT_AVAILABLE;
        break;
      default:
        return Availability.NOT_AVAILABLE;
    }
  }

  static String transLateAvailability(Availability availability) {
    switch (availability) {
      case Availability.AVAILABLE:
        return 'Beschikbaar';
        break;
      case Availability.NOT_SURE:
        return 'Niet zeker';
        break;
      case Availability.NOT_AVAILABLE:
        return 'Niet beschikbaar';
        break;
      default:
        return 'Invalid input';
    }
  }
}
