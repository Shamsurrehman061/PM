class ListingRangeModel{
  // creating singleton model class
  ListingRangeModel._private();
  static ListingRangeModel? _instance;
  factory ListingRangeModel(){
    if(_instance == null){
      _instance = ListingRangeModel._private();
      return _instance!;
    } else {
      return _instance!;
    }
  }

  void reset(){
    province = '';
    city = '';
    minRange = 0;
    maxRange = 0;
    propertySubType = '';
    areaUnit = '';
  }

  String province='';
  String city='';
  int minRange=0;
  int maxRange=10;
  String propertySubType='';
  String areaUnit='';
}