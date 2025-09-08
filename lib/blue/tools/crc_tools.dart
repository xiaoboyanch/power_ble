import 'dart:typed_data';

import '../tools/tools.dart';


class CrcTools {
  //位移转换映射
  static var key = [
    0x02,
    0x09,
    0x03,
    0x06,
    0x0E,
    0x01,
    0x0F,
    0x05,
    0x0C,
    0x04,
    0x0B,
    0x07,
    0x03,
    0x06,
    0x0A,
    0x0D
  ];
  static var uiConfused = 0xA327;

  /****************************************************************************
   ** \brief	CRC计算
   ** \param  [in] List<int> 数据串 Key 密钥
   ** \return  CRC 校验值
   ** \note
   *****************************************************************************/
  static int calcCRC(List<int> data, int len, int key) {
    int crc = 0xffff;
    int temp;
    int i = 0;
    int j = 0;

    for (j = 0; j < len; j++) {
      crc ^= data[j];
      for (i = 0; i < 8; i++) {
        if ((0x0001 & crc) == 1) {
          crc >>= 1;
          crc ^= key;
        } else {
          crc >>= 1;
        }
      }
    }
    return crc;
  }

  static getCheckSum(List<int> data, int inConfuse) {
    int uiSum = 0;
    int cSum = 0;
    for (int i = 0; i < data.length; i++) {
      int temp;
      if ((i + 1) < data.length) {
        temp = data[i] << 8 | (data[i + 1] & 0xFF);
        cSum += data[i] + data[i + 1];
      } else {
        temp = data[i] << 8;
        cSum += data[i];
      }
      cSum ^= temp;
    }
    uiSum ^= inConfuse;
    cSum ^= (cSum >> 4);
    uiSum = cror(uiSum, key[cSum & 0x0f]);
    return (~(uiSum & 0xFFFF));
  }

  static int cror(int inData, int inCBits) {
    var usRet = (inData >> inCBits) | (inData << (16 - inCBits));
    return (usRet & 0xFFFF);
  }

  static List<int> getCRC(List<int> data, int len, int key) {
    int crc = 0xffff;
    int temp;
    int i = 0;
    int j = 0;

    for (j = 0; j < len; j++) {
      crc ^= data[j];
      for (i = 0; i < 8; i++) {
        if ((0x0001 & crc) == 1) {
          crc >>= 1;
          crc ^= key;
        } else {
          crc >>= 1;
        }
      }
    }

    // print("The crc is: ${crc}");
    // print("get crc data1 is: ${crc.toRadixString(16)}");
    ByteData byteData = ByteData(2);
    byteData.setInt16(0, crc, Endian.little);
    List<int> data1 = byteData.buffer.asUint8List();
    // print("get crc data1 is: ${data1}");
    return data1;
  }

  static bool checkCRC(List<int> dataList) {
    int length = dataList.length;
    if (length > 4) {
      if (dataList[0] == 0xF5 && dataList.last == 0xFA) {
        List<int> newList = dataList.sublist(0, length-3);
        List<int> newCrc = CrcTools.getCRC(newList, length-3, CrcTools.uiConfused);
        List<int> oldCrcs = dataList.sublist(length-3, length-1);
        // int newNum = (crc[0] << 8) + crc[1];
        // int oldNum = (oldCrcs[0] << 8) + oldCrcs[1];
        if (newCrc[0] == oldCrcs[0] && newCrc[1] == oldCrcs[1]) {
          return true;
        }else {
          print('BBBBB  CRC校验失败 app:$newCrc - device:$oldCrcs  :  ${Tools.getNiceHexArray(newCrc)} -> ${Tools.getNiceHexArray(oldCrcs)}');
          print('BBBBB  CRC校验失败 $dataList');
        }
      }
    }
    return false;
  }

  static List<int> encryptCmd(List<int> inputData, {bool needSplit = true}) {
    List<int> data = [0xF5, 0x00, 0x00];
    data.addAll(inputData);
    data[1] = data.length + 3;

    List<int> result = [];
    data.addAll(getCRC(data, data.length, uiConfused));
    data.add(0xFA);

    for (int i = 0; i < data.length; i++) {
      if (i < 1 || i == data.length - 1) {
        result.add(data[i]);
      } else {
        if (needSplit) {
          result.addAll(Tools.encryptionFxData(data[i]));
        }else {
          result.add(data[i]);
        }
      }
    }
    result[1] = result.length;

    return result;
  }

  static List<int> decodeCmd(List<int> data) {
    List<int> result = [];

    int i = 2;
    while (i < data.length - 3) {
      int data1 = data[i];
      String hex = data1.toRadixString(16);

      if (data1 >> 4 == 0xf) {
        result.add(data[i] | data[i+1]);
        i += 2;
      } else {
        result.add(Tools.hexToInt(hex));
        i += 1;
      }
    }
    result.insert(0, data[0]);
    result.insert(1, result.length + 1);

    return result;
  }

  static List<int> receiveDecodeCmd(List<int> data) {
    List<int> result = [];
    int i = 2;
    while (i < data.length-1) {
      int data1 = data[i];
      int data2 = data[i+1];
      if (data2 < 0xf0 && data1 == 0xf0) {
        result.add(data[i] | data[i + 1]);
        i++;
      } else {
        result.add(data[i]);
      }
      i++;
    }
    result.add(data[i]);  //  添加最后一位FA
    result.insert(0, data[0]);
    result.insert(1, result.length + 1);
    return result;
  }

}
