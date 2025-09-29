import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../models/variant_type.dart';
import '../../../services/http_services.dart';
import '../../../utility/snack_bar_helper.dart';

class VariantsTypeProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addVariantsTypeFormKey = GlobalKey<FormState>();
  TextEditingController variantNameCtrl = TextEditingController();
  TextEditingController variantTypeCtrl = TextEditingController();

  VariantType? variantTypeForUpdate;

  VariantsTypeProvider(this._dataProvider);

  addVariantType() async {
    try {
      Map<String, dynamic> variantType = {
        'name': variantNameCtrl.text,
        'type': variantTypeCtrl.text,
      };
      final response = await service.addItem(
        endpointUrl: 'variantTypes',
        itemData: variantType,
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(' ${apiResponse.message}');
          _dataProvider.getAllVariantType();
        } else {
          SnackBarHelper.showErrorSnackBar(
            "faild to add variant : ${apiResponse.message}",
          );
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
          "Error${response.body?["message"] ?? response.status}",
        );
      }
    } catch (e) {
      print("$e");
      SnackBarHelper.showErrorSnackBar("an error has occured:$e");
      rethrow;
    }
  }

  updateVariantType() async {
    try {
      if (variantTypeForUpdate != null) {
        Map<String, dynamic> variantType = {
          'name': variantNameCtrl.text,
          'subcategoryId': variantTypeCtrl.text,
        };
        final response = await service.updateItem(
          endpointUrl: 'variantTypes',
          itemId: variantTypeForUpdate?.sId ?? '',
          itemData: variantType,
        );
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            _dataProvider.getAllVariantType();
          } else {
            SnackBarHelper.showErrorSnackBar(
              "faild to add  brands${apiResponse.message}",
            );
          }
        } else {
          SnackBarHelper.showErrorSnackBar(
            "Error ${response.body?["message"] ?? response.status}",
          );
        }
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar("an error occured: $e");
      rethrow;
    }
  }

  submitVariantType() {
    if (variantTypeForUpdate != null) {
      updateVariantType();
    } else {
      addVariantType();
    }
  }

  deleteVariantType(VariantType variantType) async {
    try {
      Response response = await service.deleteItem(
        endpointUrl: 'variantTypes',
        itemId: variantType.sId ?? '',
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success) {
          SnackBarHelper.showSuccessSnackBar("varientType delted successfully");
          _dataProvider.getAllVariantType();
        } else {
          SnackBarHelper.showErrorSnackBar(
            "Error ${response.body?["message"] ?? response.status}",
          );
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  setDataForUpdateVariantTYpe(VariantType? variantType) {
    if (variantType != null) {
      variantTypeForUpdate = variantType;
      variantNameCtrl.text = variantType.name ?? '';
      variantTypeCtrl.text = variantType.type ?? '';
    } else {
      clearFields();
    }
  }

  clearFields() {
    variantNameCtrl.clear();
    variantTypeCtrl.clear();
    variantTypeForUpdate = null;
  }
}
