class HouseModel {
  // creating singleton instance
  static HouseModel? _instance;

  HouseModel.private();

  factory HouseModel() {
    if (_instance == null) {
      _instance = HouseModel.private();
      return _instance!;
    } else {
      return _instance!;
    }
  }

  void displayHouseModelContent() {
    print(toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'plotNumber': plotNumber,
      'province': province,
      'scheme': scheme,
      'provinceName': provinceName,
      'cityName': cityName,
      'schemeName': schemeName,
      'phaseName': phaseName,
      'blockName': blockName,
      'subBlockName': subBlockName,
      'city': city,
      'phase': phase,
      'block': block,
      'subBlock': subBlock,
      'propertyType': propertyType,
      'propertySubType': propertySubType,
      'purpose': purpose,
      'address': address,
      'isNonScheme': isNonScheme,
      'schemeImageURL': schemeImageURL
    };
  }

  void resetValue() {
    plotNumber = '';
    province = '';
    scheme = '';
    provinceName = '';
    cityName = '';
    schemeName = '';
    phaseName = '';
    blockName = '';
    subBlockName = '';
    city = '';
    phase = '';
    block = '';
    subBlock = [];
    propertyType = '';
    propertySubType = '';
    purpose = '';
    area = '';
    areaUnit = '';
    demand = '';
    description = '';
    marker_x = '';
    marker_y = '';
    address = '';
    isNonScheme = false;
    schemeImageURL = '';
  }

  // only contain field that are necessary and ommitted other irrelevant field
  // fields
  String schemeImageURL='';
  String plotNumber = '';
  String province = '';
  String scheme = '';
  String provinceName = '';
  String cityName = '';
  String schemeName = '';
  String phaseName = '';
  String blockName = '';
  String subBlockName = '';
  String city = '';
  String phase = '';
  String block = '';
  List<dynamic> subBlock = [];
  String propertyType = '';
  String propertySubType = '';
  String purpose = '';
  String area = '';
  String areaUnit = '';
  String demand = '';
  String description = '';
  String marker_x = '';
  String marker_y = '';
  String address = '';
  bool isNonScheme = false;
}
