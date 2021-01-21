import 'dart:convert';

import 'package:connecting_hearts/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:connecting_hearts/constant/Constant.dart';

class Braintree {
  ApiListener mApiListener;

  Braintree(this.mApiListener);

  Future<dynamic> sale(amount, lkrAmount, paymentMethodNonce, projectData,
      method, status) async {
    print("lkr_amount=====>>>" + lkrAmount);
    var appealId;
    if (projectData == null) {
      appealId = "";
    } else {
      appealId = projectData['appeal_id'];
    }
    var timestamp = new DateTime.now().millisecondsSinceEpoch;
    var url = 'https://www.chadmin.online/braintree/sale';
    var response = await http.post(url, body: {
      'paymentMethodNonce': '$paymentMethodNonce',
      'user_id': CURRENT_USER,
      'paid_amount': '$amount',
      'lkr_amount': '$lkrAmount',
      'project_id': appealId,
      'receipt_no': '$timestamp',
      'method': method,
      'status': status
    });
    // var jsonServerData = json.decode(response.body);
    return response.body;
  }
}
