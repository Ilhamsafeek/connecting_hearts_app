import 'dart:convert';

import 'package:connecting_hearts/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:connecting_hearts/constant/Constant.dart';
import 'dart:io';

class WebServices {
  ApiListener mApiListener;
  String username = 'chadmin';
  String password = '81ac43ed664c719182acbdf8908029f55d6960ad7c82f1373aa11279d0ba5c40';
  String basicAuth;

 doAuth() {
   basicAuth =
      'Basic ' + base64Encode(utf8.encode('$username:$password'));
  }
  WebServices(this.mApiListener);
  var base_url = 'https://chadmin.online/api/';
 
 

  Future<dynamic> getProjectData() async {

  doAuth();
    var response = await http.get(base_url + "projects",
      headers: <String, String>{'authorization': basicAuth});
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getCompletedProjectData() async {
    doAuth();
    var response = await http.get(base_url + "completedProjects",
      headers: <String, String>{'authorization': basicAuth});
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<String> updateUserToken(String appToken) async {
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
     doAuth();
    var url = base_url + 'updateaccount';
    var response = await http.post(url, body: {
      'app_token': '$appToken',
      'phone': '$CURRENT_USER',
    },
      headers: <String, String>{'authorization': basicAuth});

    print(response.statusCode);
    print(response.body);
    return response.body;
  }

  Future<int> updateUser(
      currency, email, fname, lname, address, receiveNotification) async {
         doAuth();
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    var url = base_url + 'updateaccount';
    var response = await http.post(url, body: {
      'currency': '$currency',
      'phone': '$CURRENT_USER',
      'email': '$email',
      'firstname': '$fname',
      'lastname': '$lname',
      'address': '$address',
      'receive_notification': '$receiveNotification',
    },
      headers: <String, String>{'authorization': basicAuth});

    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future<int> updateNotificationSetting(receiveNotification) async {
     doAuth();
    var url = base_url + 'updateaccount';
    var response = await http.post(url, body: {
      'phone': '$CURRENT_USER',
      'receive_notification': '$receiveNotification',
    },
      headers: <String, String>{'authorization': basicAuth});
    print(receiveNotification);
    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future createAccount(String contact, String country) async {
     doAuth();
    var url = base_url + 'createaccount';

    var response = await http.post(url, body: {
      'phone': contact,
      'role_id': '2',
      'country': country,
    },
      headers: <String, String>{'authorization': basicAuth});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future createUserHit() async {
     doAuth();
    var url = base_url + 'createuserhit';

    var response = await http.post(url, body: {
      'phone': CURRENT_USER,
    },
      headers: <String, String>{'authorization': basicAuth});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<dynamic> getSermonData() async {
     doAuth();
    var response = await http.get(base_url + 'allsermons',
      headers: <String, String>{'authorization': basicAuth});
    var jsonServerData = json.decode(response.body);
    print("Response ${response.body}");
    return jsonServerData;
  }

  Future<dynamic> getCategoryData() async {
     doAuth();
    var response = await http.get(base_url + 'allprojectcategories',
      headers: <String, String>{'authorization': basicAuth});
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getNotificationData() async {
     doAuth();
    var response = await http.get(base_url + 'allnotifications',
      headers: <String, String>{'authorization': basicAuth});
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getUserData() async {
    doAuth();
    var url = base_url + 'getuser';
    var response = await http.post(url,headers: <String, String>{'authorization': basicAuth}, body: {
      'phone': CURRENT_USER,
    });
    var jsonServerData = json.decode(response.body);

    print("Response======>>>> ${response.body}");
    return jsonServerData;
  }

  Future<dynamic> getZamzamUpdateData() async {
     doAuth();
    var response = await http.get(base_url + 'zamzamupdates',
      headers: <String, String>{'authorization': basicAuth});
    var jsonServerData = json.decode(response.body);
    print("Response ${response.body}");
    return jsonServerData;
  }

  Future<dynamic> getImageFromFolder(folder, type) async {
     doAuth();
    print("=========>>>>>" + folder);
    var url = base_url + 'getimagefile/' + type;
    var response = await http.post(url, body: {
      'folder': folder,
    },
      headers: <String, String>{'authorization': basicAuth});

    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  // Payment records

  Future<dynamic> createPayment(amount, projectData, method, status,
      isRecurring, type, signupPaymentDescription) async {
         doAuth();
    print('Calling API createPayment --------->>>>>>>');
    dynamic lkrAmount = 0;
    await WebServices(mApiListener)
        .convertCurrency(currentUserData['currency'], 'LKR', '$amount')
        .then((value) {
      if (value != null) {
        lkrAmount = value;
      }
    });
    dynamic projectId;
    if (projectData == null) {
      projectId = "";
    } else {
      projectId = projectData['appeal_id'];
    }
    print('Going to pay...');
    var timestamp = new DateTime.now().millisecondsSinceEpoch;
    var url = base_url + 'createpayment';
    var response = await http.post(url, body: {
      'user_id': CURRENT_USER,
      'paid_amount': '$lkrAmount',
      'project_id': '$projectId',
      'receipt_no': '$timestamp',
      'method': method,
      'status': status,
      'recurring': '$isRecurring',
      'payment_type': type,
      'signup_payment_description': signupPaymentDescription
    },
      headers: <String, String>{'authorization': basicAuth});
    print('Payment Response status: ${response.statusCode}');
    print('Payment Response body: ${response.body}');
    return response;
  }

  Future<dynamic> getPaymentData() async {
     doAuth();
    var url = base_url + 'getpayment';
    var response = await http.post(url, body: {
      'user_id': CURRENT_USER,
    },
      headers: <String, String>{'authorization': basicAuth});
    var jsonServerData = json.decode(response.body);
    return jsonServerData;
  }

  Future<int> updateSlip(id, path) async {
     doAuth();
    String base64Image = base64Encode(File(path).readAsBytesSync());
    String fileName = File(path).path.split('/').last;
    print('payment_id::::::::: $id');
    var response = await http.post(base_url + 'updateslip', body: {
      "payment_id": "$id",
      "image": base64Image,
      "filename": fileName
    },
      headers: <String, String>{'authorization': basicAuth});
    print("Slip Update Response:::" + response.body);
    return response.statusCode;
  }

  Future<dynamic> getCompanyData() async {
     doAuth();
    var response = await http.get(base_url + 'companydata',
      headers: <String, String>{'authorization': basicAuth});
    var jsonServerData = json.decode(response.body);
    print("Response ${response.body}");
    return jsonServerData;
  }

// Channels

  Future<dynamic> getChannelData() async {
     doAuth();

    var response = await http.get(base_url + 'channels',
      headers: <String, String>{'authorization': basicAuth});
    var jsonServerData = json.decode(response.body);
    print(jsonServerData);
    return jsonServerData;
  }

// Job
  Future<dynamic> getJobData() async {
     doAuth();
    var url = base_url + 'alljob';
    var response = await http.get(url,
      headers: <String, String>{'authorization': basicAuth});
    var jsonServerData = json.decode(response.body);
    return jsonServerData;
  }

  Future<int> postJob(type, title, location, minExperience, description,
      contact, email, image, organization) async {
         doAuth();
    var url = base_url + 'createjob';
    var response = await http.post(url, body: {
      'posted_by': CURRENT_USER,
      'type': '$type',
      'title': '$title',
      'location': '$location',
      'min_experience': '$minExperience years',
      'description': '$description',
      'contact': '$contact',
      'email': '$email',
      'image': '$image',
      'organization': '$organization',
    },
      headers: <String, String>{'authorization': basicAuth});
    print('Response status: ${response.statusCode}');
    return response.statusCode;
    // print('Response body: ${response.body}');
  }

  Future<int> deleteJob(id) async {
     doAuth();
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    var url = base_url + 'deletejob';
    var response = await http.post(url, body: {
      'id': '$id',
    },
      headers: <String, String>{'authorization': basicAuth});

    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future<int> editJob(id, title, location, minExperience, description, contact,
      email, image, organization) async {
         doAuth();
    var url = base_url + 'editjob';
    var response = await http.post(url, body: {
      'id': '$id',
      'title': '$title',
      'location': '$location',
      'min_experience': '$minExperience',
      'description': '$description',
      'contact': '$contact',
      'email': '$email',
      'organization': '$organization',
    },
      headers: <String, String>{'authorization': basicAuth});

    return response.statusCode;
  }

  //Chat
  Future createChat(chatTopic, chatId, message, toUser) async {
     doAuth();
    var url = base_url + 'createchat';

    var response = await http.post(url, body: {
      'from_user': currentUserData['user_id'],
      'to_user': '$toUser',
      'topic': '$chatTopic',
      'message': '$message',
      'chat_id': '$chatId',
    },
      headers: <String, String>{'authorization': basicAuth});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response.statusCode;
  }

  Future<dynamic> getChatTopicsByPhone() async {
     doAuth();
    var url = base_url + 'getchattopicsbyphone';
    var response = await http.post(url, body: {
      'phone': CURRENT_USER,
    },
      headers: <String, String>{'authorization': basicAuth});
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getChatById(chatId) async {
     doAuth();
    var url = base_url + 'getchatbyid';
    var response = await http.post(url, body: {
      'chat_id': chatId,
    },
      headers: <String, String>{'authorization': basicAuth});
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getChatTopics() async {
     doAuth();
    var url = base_url + 'getchattopics';
    var response = await http.post(url,
      headers: <String, String>{'authorization': basicAuth});

    // print(response.body);
    var jsonServerData = json.decode(response.body);

    return jsonServerData
        .where((el) =>
            el['from_user'] == currentUserData['user_id'] ||
            el['to_user'] == currentUserData['user_id'])
        .toList();
  }

  Future<dynamic> getYoutubeChannelData() async {

    var key = "AIzaSyBsq_tg5Mp9cJ4XDLTsIYglkRouVmagq7Y";
    var baseUrl = "https://www.googleapis.com/youtube/v3/";
    var channelId = "UCxAk5Qi0fG16-K8UxZM8o4A";
    var maxResults = "60";

    var APIURL = baseUrl +
        "search?order=date&part=snippet&channelId=" +
        channelId +
        "&maxResults=" +
        maxResults +
        "&key=" +
        key;

    var response = await http.get(APIURL);
    var jsonServerData = json.decode(response.body);
    return jsonServerData;
  }

  Future convertCurrency(String from, String to, String amount) async {
     doAuth();
    print("Testingggggg.....");
    var url = base_url + 'convertCurrency';

    var response = await http.post(url, body: {
      'from': '$from',
      'to': '$to',
      'amount': '$amount',
    },
      headers: <String, String>{'authorization': basicAuth});
    print('Currency Response status: ${response.statusCode}');
    print('Currency Response body: ${response.body}');
    return response.body;
  }
}
