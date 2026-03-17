class RHUrls {
  //////////// https://appqr.speraxfit.com/agreement?id=2 正式服隐私协议
  // static const String baseUrl = 'http://43.136.69.79:8079/prod-api';
  // static const String baseUrl = 'https://berrygame.top/';
  // static const String baseUrl = 'https://api.speraxfit.com/';
  static String baseUrl = '';
  static const String getApiHost = 'https://speraxapp.com/api/version?os=3';
  static const String testSpeed = '/api/feedback/testSpeed';
  static const String versionCheck = '/api/version';
  static const String sendEmailCode = '/api/app/sendMailCode';
  static const String checkCode = '/api/app/verifyCode';
  static const String forgetPsw = '/api/app/updatePwd';
  static const String register = '/api/app/register';
  static const String login = '/api/app/login';
  static const String deleteUser = '/api/app/delAcc';

  static const String uploadFile = '/api/file/upload';

  /// 用户积分
  static const String pointList = '/api/score/detail';
  static const String pointNow = '/api/score/overview';
  static const String pointAllLevel = '/api/score/level/list';

  /// 用户请求
  static const String getInfo = '/api/app/getInfo';
  static const String updateUser = '/api/app/updateInfo';
  static const String uploadAvatar = '/api/app/uploadAvatar';
  static const String bodyChangeList = '/api/app/body/change/list';
  static const String customerList = '/api/customerService/detail';
  static const String customerSend = '/api/customerService/send';
  static const String userAgreement = '/api/agreement/get';
  static const String updateUserSetting = '/api/app/updateSetting';
  static const String getUserSetting = '/api/app/getSetting';

  /// 体能测试
  static const String fitnessPostTest = '/api/physicalFitnessTest';
  static const String fitness5TestResult = '/api/physicalFitnessTest/last';
  static const String fitnessGetOneList = '/api/physicalFitnessTest/listByType';

  ///  动作库
  static const String getActList = '/api/action/list';
  static const String getActDetail = '/api/action/detail';
  static const String getActionRecommendList = '/api/action/recommend/list';


  ///运动记录
  ///创建运动记录
  static const String sportRecordCreate = '/api/sport/record/create';
  ///上报运动记录
  static const String sportRecordPost = '/api/sport/record/upload';

  static const String sportData = '/api/sport/record/statistics/list';
  static const String recordDetail = '/api/sport/record/detail';
  static String deleteRecord(String id) => '/api/sport/record/delete/$id';
  static const String recordDataList = '/api/sport/record/list';
  static const String getTotalUserData = '/api/app/statistics';

  ///绑定设备信息
  static const String deviceMsgList = '/api/device/listAll';
  static const String userDeviceList = '/api/userDevice/list';
  static const String bindUserDevice = '/api/userDevice/bind';
  static String unBindUserDevice(int id) => '/api/userDevice/unbind/$id';

  ///课程
  static const String courseList = '/api/course/list';
  static const String courseDetail = '/api/course/detail';
  static String collectCourse(String courseId, bool collect) =>
      '/api/course/collect?courseId=$courseId&collected=$collect';
  static const String collectList = '/api/course/collect/list';
  static const String recommendList = '/api/course/recommend/list';
  static const String customTempSave = '/api/course/custom/save';
  static const String customTempList = '/api/course/custom/list';
  static String customTempDelete(String id) => '/api/course/custom/delete/$id';
  static const String customTempDetail = '/api/course/custom/detail';
  ///自定义课程封面
  static const String customTempCover = '/api/course/custom/cover/list';

  /// 计划
  static const String planSave = '/api/plan/save';
  static const String planStop = '/api/plan/stop';
  static const String planDelete = '/api/plan/delete';
  static const String planFinished = '/api/plan/list/stopped';
  static const String planDetail = '/api/plan/get';
  static const String planRunning = '/api/plan/getOngoing';

  /// 活动
  static const String activeList = '/api/commentActivity/list';
  static const String dialogCheck = '/api/commentActivity/needPop';
  static const String activeSubmit = '/api/commentActivity/submit';
  static const String activeQuestion = '/api/commentActivity/questionnaire';


  ///商品推荐
  static const String productRecommend = "/api/sell/getRecommendList";
  static const String productList = "/api/sell/getSellList";
  static const String bookList = "/api/specification/list";
  static String bookDetail(int id) => "/api/specification/detail/$id";

  //数据埋点
  static const String eventReport = "/api/app/event/report";
  static const String trackCourse = "/api/log/lookCourse";
  static const String trackGoods = "/api/log/clickGoods";
  static const String trackApp = "/api/log/evoke";

  static const String otaUpdate = "/api/ota/version/list";

  RHUrls._();
}
