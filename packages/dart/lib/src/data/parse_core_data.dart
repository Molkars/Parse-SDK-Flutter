part of flutter_parse_sdk;

ParseClient _defaultClientCreator({bool? sendSessionId, SecurityContext? securityContext}) =>
    ParseHTTPClient(sendSessionId: sendSessionId, securityContext: securityContext);

/// Singleton class that defines all user keys and data
class ParseCoreData {
  static late ParseCoreData _instance;

  factory ParseCoreData() => _instance;

  ParseCoreData._init({
    required this.applicationId,
    required this.serverUrl,
    required this.debug,
    required this.clientCreator,
    required ParseSubClassHandler subClassHandler,
    required this.liveListRetryIntervals,
    required this.storage,
  }) : _subClassHandler = subClassHandler;

  /// Creates an instance of Parse Server
  ///
  /// This class should not be user unless switching servers during the app,
  /// which is odd. Should only be user by Parse.init
  factory ParseCoreData.init(
    String appId,
    String serverUrl, {
    bool debug = true,
    String? appName,
    String? appVersion,
    String? appPackageName,
    String? locale,
    String? liveQueryUrl,
    String? masterKey,
    String? clientKey,
    String? sessionId,
    bool? autoSendSessionId,
    SecurityContext? securityContext,
    CoreStore? store,
    Map<String, ParseObjectConstructor>? registeredSubClassMap,
    ParseUserConstructor? parseUserConstructor,
    ParseFileConstructor? parseFileConstructor,
    List<int>? liveListRetryIntervals,
    ParseConnectivityProvider? connectivityProvider,
    String? fileDirectory,
    Stream<void>? appResumedStream,
    ParseClientCreator clientCreator = _defaultClientCreator,
  }) {
    return ParseCoreData._init(
      applicationId: appId,
      storage: store ?? CoreStoreMemoryImp(),
      debug: debug,
      clientCreator: clientCreator,
      liveListRetryIntervals: liveListRetryIntervals ??
          (parseIsWeb ? <int>[0, 500, 1000, 2000, 5000] : <int>[0, 500, 1000, 2000, 5000, 10000]),
      serverUrl: serverUrl,
      subClassHandler: ParseSubClassHandler(
        registeredSubClassMap: registeredSubClassMap,
        parseUserConstructor: parseUserConstructor,
        parseFileConstructor: parseFileConstructor,
      ),
    )
      ..appName = appName
      ..appVersion = appVersion
      ..appPackageName = appPackageName
      ..locale = locale
      ..liveQueryUrl = liveQueryUrl
      ..clientKey = clientKey
      ..masterKey = masterKey
      ..sessionId = sessionId
      ..autoSendSessionId = autoSendSessionId
      ..securityContext = securityContext
      ..connectivityProvider = connectivityProvider
      ..fileDirectory = fileDirectory
      ..appResumedStream = appResumedStream;
  }

  String applicationId;
  String serverUrl;
  bool debug;
  String? appName;
  String? appVersion;
  String? appPackageName;
  String? locale;
  String? liveQueryUrl;
  String? clientKey;
  String? masterKey;
  String? sessionId;
  bool? autoSendSessionId;
  SecurityContext? securityContext;
  List<int> liveListRetryIntervals;
  CoreStore storage;
  ParseSubClassHandler _subClassHandler;
  ParseConnectivityProvider? connectivityProvider;
  String? fileDirectory;
  Stream<void>? appResumedStream;
  ParseClientCreator clientCreator;

  void registerSubClass(String className, ParseObjectConstructor objectConstructor) {
    _subClassHandler.registerSubClass(className, objectConstructor);
  }

  void registerUserSubClass(ParseUserConstructor parseUserConstructor) {
    _subClassHandler.registerUserSubClass(parseUserConstructor);
  }

  void registerFileSubClass(ParseFileConstructor parseFileConstructor) {
    _subClassHandler.registerFileSubClass(parseFileConstructor);
  }

  ParseObject createObject(String classname) {
    return _subClassHandler.createObject(classname);
  }

  ParseUser createParseUser(
    String? username,
    String? password,
    String? emailAddress, {
    String? sessionToken,
    bool? debug,
    ParseClient? client,
  }) {
    return _subClassHandler.createParseUser(username, password, emailAddress,
        sessionToken: sessionToken, debug: debug, client: client);
  }

  ParseFileBase createFile({String? url, String? name}) => _subClassHandler.createFile(name: name, url: url);

  /// Sets the current sessionId.
  ///
  /// This is generated when a users logs in, or calls currentUser to update
  /// their keys
  void setSessionId(String? sessionId) {
    this.sessionId = sessionId;
  }

  CoreStore getStore() {
    return storage;
  }

  @override
  String toString() => '$applicationId $masterKey';
}
