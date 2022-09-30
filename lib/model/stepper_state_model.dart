class StepperStateModel {
  // singleton model
  StepperStateModel._private();

  static StepperStateModel? _instance;

  factory StepperStateModel() {
    print('factory StepperStateModel()');
    if (_instance == null) {
      _instance = StepperStateModel._private();
      return _instance!;
    } else {
      return _instance!;
    }
  }

  void reset() {
    // this will enable all drop down
    print('stepper state model reset()');
    isProvinceDropDownEnable = true;
    isCityDropDownEnable = true;
    isSchemeDropDownEnable = true;
    isListSchemeDropDownEnable = true;
    isSelectPropertyDropDownEnable = true;
    isSelectPropertySubTypeDropDownEnable = true;
    selectPropertyPurposeDropDownEnable = true;
    isPhaseDropDownEnable = true;
    isBlockDropDownEnable = true;
    isSubBlockDropDownEnable = true;
  }

  // state variables <9 drop down>
  late bool isProvinceDropDownEnable;
  late bool isCityDropDownEnable;
  late bool isSchemeDropDownEnable;
  late bool isListSchemeDropDownEnable;
  late bool isSelectPropertyDropDownEnable;
  late bool isSelectPropertySubTypeDropDownEnable;
  late bool selectPropertyPurposeDropDownEnable;
  late bool isPhaseDropDownEnable;
  late bool isBlockDropDownEnable;
  late bool isSubBlockDropDownEnable;
}
