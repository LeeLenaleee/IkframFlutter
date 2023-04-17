class ArrayHelpers {
  static List<dynamic> removeDuplicatesFromList(List<dynamic> inputArr) {
    List<dynamic> tmp = [];

    inputArr.forEach((element) {
      if (tmp.indexOf(element) == -1) {
        tmp.add(element);
      }
    });

    return tmp;
  }
}
