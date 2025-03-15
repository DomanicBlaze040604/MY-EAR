class TranslationService {
  final Map<String, String> _gestureToText = {
    'A': 'A',
    'B': 'B',
    'C': 'C',
    'D': 'D',
    'E': 'E',
    'F': 'F',
    'G': 'G',
    'H': 'H',
    'I': 'I',
    'J': 'J',
    'K': 'K',
    'L': 'L',
    'M': 'M',
    'N': 'N',
    'O': 'O',
    'P': 'P',
    'Q': 'Q',
    'R': 'R',
    'S': 'S',
    'T': 'T',
    'U': 'U',
    'V': 'V',
    'W': 'W',
    'X': 'X',
    'Y': 'Y',
    'Z': 'Z',
    'SPACE': ' ',
    'DELETE': '',
  };

  String translateGestureToText(String gesture) {
    return _gestureToText[gesture] ?? gesture;
  }

  String combineGesturesToSentence(List<String> gestures) {
    final StringBuffer sentence = StringBuffer();

    for (final gesture in gestures) {
      if (gesture == 'DELETE' && sentence.length > 0) {
        String current = sentence.toString();
        sentence.clear();
        sentence.write(current.substring(0, current.length - 1));
      } else if (gesture != 'DELETE') {
        sentence.write(translateGestureToText(gesture));
      }
    }

    return sentence.toString();
  }
}
