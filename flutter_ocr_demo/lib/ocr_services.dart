import 'package:TencentDocsApp/service/APIService.dart';
import 'package:TencentDocsApp/service/business/base/business_service.dart';
import 'package:TencentDocsApp/service/foundation/CGIService.dart';
import 'package:TencentDocsApp/service/model/CGIResponse.dart';
import 'package:TencentDocsApp/util/device_utils.dart';
import 'package:TencentDocsApp/util/dialog_helper.dart';
import 'package:TencentDocsApp/util/image_utils.dart';
import 'package:TencentDocsApp/util/toast_helper.dart';
import 'package:TencentDocsApp/widget/base/dialog/loading_dialog.dart';
import 'package:TencentDocsApp/widget/ocr/bean/import_ocr_request_model.dart';
import 'package:TencentDocsApp/widget/ocr/bean/ocr_request_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:http_parser/http_parser.dart';
import 'package:xlog/xlog.dart';

import '../bean/ocr_save_to_mylist_model.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';
import 'dart:async';

typedef ResultCallback = void Function(dynamic result);

class OCRService extends BusinessService {
  OCRService(APIService api) : super(api);

  Future<bool> remoteConvertImageToPDF(OCRParam param, {ResultCallback callback}) async {
    final rawRsp = await _fetchFromPDFServer(param);
    if (rawRsp?.isEmpty ?? true) {
      if (callback != null) {
        callback.call(null);
      }
      return false;
    }

    final rsp = OCRResp.fromJson(rawRsp);
    if (callback != null) {
      callback.call(rsp);
    }
    return true;
  }

  Future<Map<String, dynamic>> _fetchFromPDFServer(OCRParam param) async {
    final json = param.toJson();
    final cgiParams = <String, String>{};
    json.forEach((key, value) {
      cgiParams[key] = value is String ? value : '$value';
    });

    cgiParams.remove('param');
    final extraParams = json['param'];
    if (extraParams != null) cgiParams.addAll(extraParams);

    try {
      var response = await api?.cgiPost(
        CGI.ocr_upload_image_to_pdf,
        body: {
          'filename': param.fileName,
          'folder_Id': param.folderId,
          'source': param.source,
          'image_cos_array': param.imageCosArray,
          'operation_id': param.operationId
        },
        params: cgiParams,
        contentType: Headers.jsonContentType,
      );
      return response?.jsonData;
    } catch (e) {
      Log.e(this, '_fetchFromServer error:${e}');
      return null;
    }
  }

  /// 图片导入，直接生成文档或者表格
  Future<bool> remoteImportOCR(ImportOCRParam param, {ResultCallback callback}) async {

    final rawRsp = await _fetchImportOCR(param);
    if (rawRsp?.isEmpty ?? true) {
      if (callback != null) {
        callback.call(null);
      }
      return false;
    }

    final rsp = ImportOCRResp.fromJson(rawRsp);
    if (callback != null) {
      callback.call(rsp);
    }
    return true;
  }

  Future<Map<String, dynamic>> _fetchImportOCR(ImportOCRParam param) async {
    final json = param.toJson();
    final cgiParams = <String, String>{};
    String newPath = await checkFileSize(param.file, 2000);
    json.forEach((key, value) {
      cgiParams[key] = value is String ? value : '$value';
    });
    cgiParams["file"] = newPath;
    json["file"] = newPath;
    var map = Map<String, dynamic>();
    var fileName = Uri.file(param.file).pathSegments.last ?? 'TencentDocs';
    map['need_url'] = true;
    map['preview'] = true;
    map['file'] =
    await MultipartFile.fromFile(param.file, filename: fileName, contentType: MediaType('multipart', 'form-data'));
    try {
      return (await api?.cgiPostFormData(CGI.ocr_import_image, map, params: cgiParams))?.jsonData;
    } catch (e) {
      Log.e(this, '_fetchFromServer error:${e}');
      return null;
    }
  }

  ///  图片导入，直接生成文档或者表格
  Future<bool> remoteSaveToMyList(String url, {ResultCallback callback}) async {
    OCRSaveToMyListParam param = OCRSaveToMyListParam();
    param.prvurl = url;
    param.uniquefileid = _getUniqueFileId(url);
    param.shortLinkId = getShortLinkId(url);
    final rawRsp = await _reqSaveToMyList(param);
    if (rawRsp?.isEmpty ?? true) {
      if (callback != null) {
        callback.call(null);
      }
      return false;
    }

    final rsp = OCRSaveToMyListResp.fromJson(rawRsp);
    if (callback != null) {
      callback.call(rsp);
    }
    return true;
  }

  Future<Map<String, dynamic>> _reqSaveToMyList(OCRSaveToMyListParam param) async {
    final json = param.toJson();
    final cgiParams = <String, String>{};
    json.forEach((key, value) {
      cgiParams[key] = value is String ? value : '$value';
    });

    cgiParams.remove('param');
    final extraParams = json['param'];
    if (extraParams != null) cgiParams.addAll(extraParams);

    try {
      return (await api?.cgiPost(CGI.ocr_save_to_mylist,
              body: {
                'uniquefileid': param.uniquefileid,
                'shortLinkId': param.shortLinkId,
                'prvurl': param.prvurl,
              },
              params: cgiParams,
              contentType: Headers.jsonContentType))
          ?.jsonData;
    } catch (e) {
      Log.e(this, '_fetchFromServer error:${e}');
      return null;
    }
  }

  /// Url 格式：https://docs.qq.com/doc/DY0tEU0pHZlhtaW1N?uniquefileid=a5e35a99896b043c257a53881cd2e96f_53899228&preview=1";
  String _getUniqueFileId(String url) {
    List<String> result = url.split('?');
    String uniqueFile = null;
    if (result != null && result.length > 0) {
      for (int i = 0; i < result.length; i++) {
        if (result[i].contains('uniquefileid')) {
          uniqueFile = result[i];
          break;
        }
      }
    }
    if (uniqueFile.isEmpty) {
      return null;
    }
    result = uniqueFile.split('&');
    String uniqueFileId = null;
    if (result.isNotEmpty) {
      for (int i = 0; i < result.length; i++) {
        if (result[i].contains('uniquefileid')) {
          uniqueFileId = result[i];
          break;
        }
      }
    }
    if (uniqueFileId == null) {
      return null;
    }
    result = uniqueFileId.split('=');
    if (result.isEmpty || result.length < 2) {
      return null;
    }
    if (result[0].contains('uniquefileid')) {
      return Uri.decodeComponent(result[1]);
    }
    return null;
  }

  // 与前端的js逻辑保持一致
  String getShortLinkId(String url) {
    int end1 = url.lastIndexOf('?');
    int end2 = url.lastIndexOf('#');
    int end;
    if (end1 < 0 && end2 < 0) {
      end = -1;
    } else if (end1 < 0 && end2 >= 0) {
      end = end2;
    } else if (end1 >= 0 && end2 < 0) {
      end = end1;
    } else {
      end = end1 < end2 ? end1 : end2;
    }

    if (end == -1) {
      return null;
    }
    int begin = url.lastIndexOf('/', end);
    String fileid = url.substring(begin + 1, end);
    return Uri.decodeComponent(fileid);
  }

  Future<Map<String, dynamic>> feedbackOcrResult(Map<String, dynamic> data) async {
    var uri = Uri.https('qqbe.qq.com', 'doctable/api', null);
    CGIResponse response = await api?.request(uri, 'POST', body: data, contentType: Headers.jsonContentType);
    return response?.jsonData;
  }

  void feedback(BuildContext context, int idx, String msg, String imagePath) async {
    LoadingController controller = LoadingController();
    DialogHelper.showLoading(context, controller: controller, text: '正在反馈中...', barrierDismissible: false);

    final info = await DeviceUtils.deviceInfo;
    String uuid = info?.uuid ?? APIService.of(context).uid;
    String from = 'docs_${info?.platform ?? ''}';
    String base64Data;
    if (imagePath?.isNotEmpty ?? false) {
      try {
        base64Data = await ImageUtils.image2Base64(imagePath);
      } catch (e) {
        controller?.dismiss();
        ToastHelper.showErrorToast(context, '上传图片异常');
        return;
      }
    }
    var data = {
      'id': 1,
      'method': 'CommAI',
      'params': {
        'model': 'feedback',
        'data': base64Data,
        'uuid': uuid,
        'options': {
          'id': idx,
          'msg': msg,
          'from': from,
        }
      }
    };
    Map<String, dynamic> response = await APIService.of(context).ocrService.feedbackOcrResult(data);

    if (response != null) {
      Map<String, dynamic> result = response['result'];
      if (result != null) {
        int code = result['code'];
        String msg = result['msg'];
        if (code != 0) {
          Log.d(this, 'ocr feedback failed, result:$result  code:$code  msg:$msg');

          ToastHelper.showSuccToast(context, '反馈失败: $msg');
        } else {
          ToastHelper.showSuccToast(context, '反馈成功');
        }
      }
    }
    controller?.dismiss();
    Navigator.of(context).pop();
  }

  /// filePath: 原图路径, maxLength: 长边不超过maxLength, return: 新图片的路径（维持原始比例，长边不超过2000px）
  static Future<String> checkFileSize(String filePath, int maxLength) async {
    Img.Image image = Img.decodeImage(File(filePath).readAsBytesSync());
    Log.d('ocr_check: old_img',
        '${filePath} ; ${image.height}  ;  ${image.width}');
    int maxSide = image.height > image.width ? image.height : image.width;
    if (maxSide <= maxLength) return filePath;
    List shape = getLength(image.height, image.width, maxLength);
    Img.Image newImg = Img.copyResize(image,
               height: shape[0], width: shape[1]);
    String newPath = (await getTemporaryDirectory()).path + "/tmpCompressedImg";
    Log.d('ocr_check: new_img',
        '${newPath} : ${newImg.height}  vs  ${newImg.width} ');
    new File(newPath)..writeAsBytesSync(Img.encodeJpg(newImg, quality: 90));
    return newPath;
  }

  /// return: 新图像的长宽
  static List getLength(int h, int w, int maxLength) {
    double scale;
    if (h > w) {
      scale = w/h;
      h = maxLength;
      w = (h * scale).round();
    } else {
      scale = h/w;
      w = maxLength;
      h = (w * scale).round();
    }
    return [h, w];
  }
}
