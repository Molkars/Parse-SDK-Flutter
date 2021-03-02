part of flutter_parse_sdk;

typedef ParseObjectConstructor = ParseObject Function();
typedef ParseUserConstructor = ParseUser Function(
  String? username,
  String? password,
  String? emailAddress, {
  String? sessionToken,
  bool? debug,
  ParseClient? client,
});
typedef ParseFileConstructor = ParseFileBase Function({String? name, String? url});

ParseFileBase _defaultFileConstructor({String? name, String? url}) {
  if (parseIsWeb) {
  return ParseWebFile(null, name: name, url: url);
  } else {
  return ParseFile(null, name: name, url: url);
  }
}

class ParseSubClassHandler {
  ParseSubClassHandler({
    Map<String, ParseObjectConstructor>? registeredSubClassMap,
    ParseUserConstructor? parseUserConstructor,
    ParseFileConstructor? parseFileConstructor,
  }) :
    _subClassMap = registeredSubClassMap ?? <String, ParseObjectConstructor>{},
    _parseUserConstructor = parseUserConstructor,
    _parseFileConstructor = parseFileConstructor ?? _defaultFileConstructor;

  Map<String, ParseObjectConstructor> _subClassMap;
  ParseUserConstructor? _parseUserConstructor;
  ParseFileConstructor _parseFileConstructor;

  void registerSubClass(String className, ParseObjectConstructor objectConstructor) {
    if (className != keyClassUser &&
        className != keyClassInstallation &&
        className != keyClassSession &&
        className != keyFileClassname) {
      _subClassMap[className] = objectConstructor;
    }
  }

  void registerUserSubClass(ParseUserConstructor? parseUserConstructor) {
    _parseUserConstructor = parseUserConstructor;
  }

  void registerFileSubClass(ParseFileConstructor parseFileConstructor) {
    _parseFileConstructor = parseFileConstructor;
  }

  ParseObject createObject(String classname) {
    if (classname == keyClassUser) {
      return createParseUser(null, null, null);
    }
    if (_subClassMap.containsKey(classname)) {
      return _subClassMap[classname]!();
    }
    return ParseObject(classname);
  }

  ParseUser createParseUser(String? username, String? password, String? emailAddress,
      {String? sessionToken, bool? debug, ParseClient? client}) {
    return _parseUserConstructor != null
        ? _parseUserConstructor!(username, password, emailAddress,
            sessionToken: sessionToken, debug: debug, client: client)
        : ParseUser(username, password, emailAddress, sessionToken: sessionToken, debug: debug, client: client);
  }

  ParseFileBase createFile({String? name, String? url}) => _parseFileConstructor(name: name, url: url);
}
