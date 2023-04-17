class IntlHelper {
  static String translateMonthEnglishDutch(String date) {
    var englishToDutchNaming = {
      'January': 'januarie',
      'February': 'februarie',
      'March': 'maart',
      'April': 'april',
      'May': 'mei',
      'June': 'juni',
      'July': 'juli',
      'August': 'augustus',
      'September': 'september',
      'October': 'oktober',
      'November': 'november',
      'December': 'december',
    };

    var brokenUpDate = date.split('-');
    var monthIndex =
        englishToDutchNaming.keys.toList().indexOf(brokenUpDate[1]);
    brokenUpDate[1] = englishToDutchNaming.values.toList()[monthIndex];

    return brokenUpDate.join('-');
  }
}
