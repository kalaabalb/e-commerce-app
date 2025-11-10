import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../models/sub_category.dart';
import '../../../services/admin_auth_service.dart';
import '../../../services/http_services.dart';
import 'package:admin_panal_start/models/api_response.dart';
import 'package:admin_panal_start/utility/snack_bar_helper.dart';
import 'package:admin_panal_start/utility/error_utils.dart';

class SubCategoryProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final AdminAuthService _authService = Get.find<AdminAuthService>();

  final addSubCategoryFormKey = GlobalKey<FormState>();
  TextEditingController subCategoryNameCtrl = TextEditingController();
  Category? selectedCategory;
  SubCategory? subCategoryForUpdate;

  SubCategoryProvider(this._dataProvider);

  addSubCategory() async {
    try {
      Map<String, dynamic> subCategory = {
        'name': subCategoryNameCtrl.text,
        'categoryId': selectedCategory?.sId,
        'createdBy': _authService.getUserId(), // Add createdBy
      };

      final response = await service.addItem(
        endpointUrl: 'subCategories',
        itemData: subCategory,
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('Sub Category added successfully');
          _dataProvider.getAllSubCategory();
        } else {
          SnackBarHelper.showOperationErrorSnackBar('add', apiResponse.message);
        }
      } else {
        SnackBarHelper.showOperationErrorSnackBar('add', response.statusText);
      }
    } catch (e) {
      SnackBarHelper.showOperationErrorSnackBar('add', e);
      rethrow;
    }
  }

  updateSubCategory() async {
    try {
      // Check permission
      if (!_authService.canEditItem(subCategoryForUpdate)) {
        SnackBarHelper.showErrorSnackBar(
            'You do not have permission to edit this sub category');
        return;
      }

      Map<String, dynamic> subCategory = {
        'name': subCategoryNameCtrl.text,
        'categoryId': selectedCategory?.sId,
      };

      final response = await service.updateItem(
        endpointUrl: 'subCategories',
        itemId: subCategoryForUpdate?.sId ?? '',
        itemData: subCategory,
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar(
              'Sub Category updated successfully');
          _dataProvider.getAllSubCategory();
        } else {
          SnackBarHelper.showOperationErrorSnackBar(
              'update', apiResponse.message);
        }
      } else {
        SnackBarHelper.showOperationErrorSnackBar(
            'update', response.statusText);
      }
    } catch (e) {
      SnackBarHelper.showOperationErrorSnackBar('update', e);
      rethrow;
    }
  }

  submitSubCategory() {
    if (subCategoryForUpdate != null) {
      updateSubCategory();
    } else {
      addSubCategory();
    }
  }

  deleteSubCategory(SubCategory subCategory) async {
    try {
      // Check permission
      if (!_authService.canDeleteItem(subCategory)) {
        SnackBarHelper.showErrorSnackBar(
            'You do not have permission to delete this sub category');
        return;
      }

      Response response = await service.deleteItem(
        endpointUrl: 'subCategories',
        itemId: subCategory.sId ?? '',
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success) {
          SnackBarHelper.showSuccessSnackBar(
              "Sub Category deleted successfully");
          _dataProvider.getAllSubCategory();
        } else {
          SnackBarHelper.showOperationErrorSnackBar(
              'delete', apiResponse.message);
        }
      } else {
        SnackBarHelper.showOperationErrorSnackBar(
            'delete', response.statusText);
      }
    } catch (e) {
      SnackBarHelper.showOperationErrorSnackBar('delete', e);
      rethrow;
    }
  }

  setDataForUpdateSubCategory(SubCategory? subCategory) {
    if (subCategory != null) {
      subCategoryForUpdate = subCategory;
      subCategoryNameCtrl.text = subCategory.name ?? '';
      selectedCategory = _dataProvider.categories.firstWhereOrNull(
        (element) => element.sId == subCategory.categoryId?.sId,
      );
    } else {
      clearFields();
    }
  }

  clearFields() {
    subCategoryNameCtrl.clear();
    selectedCategory = null;
    subCategoryForUpdate = null;
  }

  updateUI() {
    notifyListeners();
  }
}
