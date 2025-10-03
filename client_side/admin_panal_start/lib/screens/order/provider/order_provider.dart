import 'package:admin_panal_start/models/api_response.dart';
import 'package:admin_panal_start/utility/snack_bar_helper.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../../../models/order.dart';
import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';

class OrderProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final orderFormKey = GlobalKey<FormState>();
  TextEditingController trackingUrlCtrl = TextEditingController();
  String selectedOrderStatus = 'pending';
  Order? orderForUpdate;

  OrderProvider(this._dataProvider);

  updateOrder() async {
    try {
      if (orderForUpdate != null) {
        Map<String, dynamic> order = {
          'trackingUrl': trackingUrlCtrl.text,
          'orderStatus': selectedOrderStatus,
        };
        final response = await service.updateItem(
          endpointUrl: 'orders',
          itemId: orderForUpdate?.sId ?? '',
          itemData: order,
        );
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success) {
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            _dataProvider.getAllOrders();
          } else {
            SnackBarHelper.showErrorSnackBar(
              "faild to add orders${apiResponse.message}",
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

  deleteOrder(Order order) async {
    try {
      Response response = await service.deleteItem(
        endpointUrl: 'orders',
        itemId: order.sId ?? '',
      );
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success) {
          SnackBarHelper.showSuccessSnackBar("order delted successfully");
          _dataProvider.getAllOrders();
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

  updateUI() {
    notifyListeners();
  }
}
