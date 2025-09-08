class Tools {
  static List<int> format(List<int> data, {bool first = false}) {
    var list = <int>[];
    // list.add(ORDER_START); // 桢头
    list.addAll(data); // 数据
    var validCode = attachValidCode(list);
    list.add(validCode); // 倒数第二位是校验码
    list.add(0x03); // 指令结束标志
    return list;
  }

  /**添加末位校验码，计算各个数据位，异或后放到倒数第二位,需要注意的是index为0的时候，对应的元素是起始位，所以不要参与异或操作@param data 指令数组*/
  static int attachValidCode(List<int> data, {bool first = false}) {
    var tmp = data[1];

    for (var i = 2; i < data.length; i++) {
      tmp ^= data[i];
    }
    return tmp;
  }

  static int MAKELONG(int a, int b) {
    return (a | (b * 65536));
  }

  static int MAKEWORD(int a, int b) {
    return (a | (b * 256));
  }

  static int MAKEDWORD(int a, int b, int c, int d) {
    return MAKELONG(MAKEWORD(a, b), MAKEWORD(c, d));
  }

  static int getUnsignNumber(int number) {
    return number >>> 0;
  }

  static int getSignNumber(int number) {
    if (number <= 127) {
      return number;
    } else {
      return -(256 - number);
    }
  }

  static int getOneBit(int num, int index) {
    var str = num.toRadixString(2).split('').reversed.toList();

    if (str.length > index) {
      return int.parse(str[index]);
    } else {
      return 0;
    }
  }

  static int getTwoByteSmallEndian(int data1, int data2) {
    return data1 + (data2 << 8);
  }

  static int getTwoByteByBigEndian(int data1, int data2) {
    return data1 << 8 | (data2);
  }

  static List<int> parseManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      // print('———————————  设备未返回制造商数据  ———————————');
      // print('———————————  设备未返回制造商数据  ———————————');
      // print('———————————  设备未返回制造商数据  ———————————');
      // print('———————————  设备未返回制造商数据  ———————————');
      // print('———————————  设备未返回制造商数据  ———————————');
      // print('———————————  设备未返回制造商数据  ———————————');
      // print('———————————  设备未返回制造商数据  ———————————');
      return [0x33,0x33];
    }
    var k = data.keys.first.toRadixString(16);
    if ((k.length % 2) != 0) {
      k = "0$k";
    }
    List<int> value = [];
    value.addAll(data.values.first);

    final len = (k.length / 2.0).ceil();

    for (var i = 0; i < len; i++) {
      var str = k.substring(k.length - (2 * (i + 1)), k.length - (2 * i));
      final num = hexToInt(str);
      value.insert(0, num);
    }
    if (len == 1) {
      value.insert(0, 0);
    }

    return value;
  }

  static int hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }


  static List<int> encryptionFxData(int data1) {
    String hex = data1.toRadixString(16);

    if (data1 >> 4 == 15) {
      // print("The fx0 is: ${hex}${hex[1]}");
      // print("The fx12 is: ${[0XF0, Tools.hexToInt(hex[1])]}");
      return [0XF0, Tools.hexToInt(hex[1])];
    }else{
      // print("The fx is: ${Tools.hexToInt(hex)}");
    }
    return [Tools.hexToInt(hex)];
  }

  static int decodeFxData(int data1,int index,List<int> data) {
    String hex = data1.toRadixString(16);
    String hex1 = data[index+1].toRadixString(16);
    if (data1 >> 4 == 15) {

      return Tools.hexToInt(hex[1]) + Tools.hexToInt(hex1[1]);
    }else{
      print("The fx is: ${Tools.hexToInt(hex)}");
    }
    return data1;
  }

  ///转位十六进制字符串
  static String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ').toUpperCase()}]';
  }

  ///小端对调
  static int swappingData(int lowByte, int highByte) {
    return ((highByte << 8) | lowByte);
  }
}
