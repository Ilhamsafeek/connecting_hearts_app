import 'dart:convert';

import 'package:connecting_hearts/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:connecting_hearts/constant/Constant.dart';
import 'dart:io';

class WebServices {
  ApiListener mApiListener;

  WebServices(this.mApiListener);
  var base_url = 'https://chadmin.online/api/';

  Future<dynamic> getProjectData() async {
    var response = await http.get(base_url + "projects");
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getCompletedProjectData() async {
    var response = await http.get(base_url + "completedProjects");
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<String> updateUserToken(String appToken) async {
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    var url = base_url + 'updateaccount';
    var response = await http.post(url, body: {
      'app_token': '$appToken',
      'phone': '$CURRENT_USER',
    });

    print(response.statusCode);
    print(response.body);
    return response.body;
  }

  Future<int> updateUser(currency, email, fname, lname,receiveNotification) async {
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    var url = base_url + 'updateaccount';
    var response = await http.post(url, body: {
      'currency': '$currency',
      'phone': '$CURRENT_USER',
      'email': '$email',
      'firstname': '$fname',
      'lastname': '$lname',
      'receive_notification': '$receiveNotification',
    });

    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future createAccount(String contact, String country) async {
    var url = base_url + 'createaccount';

    var response = await http.post(url, body: {
      'phone': contact,
      'role_id': '2',
      'country': country,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future createUserHit() async {
    var url = base_url + 'createuserhit';

    var response = await http.post(url, body: {
      'phone': CURRENT_USER,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<dynamic> getSermonData() async {
    var response = await http.get(base_url + 'allsermons');
    var jsonServerData = json.decode(response.body);
    print("Response ${response.body}");
    return jsonServerData;
  }

  Future<dynamic> getCategoryData() async {
    var response = await http.get(base_url + 'allprojectcategories');
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getNotificationData() async {
    var response = await http.get(base_url + 'allnotifications');
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getUserData() async {
    var url = base_url + 'getuser';
    var response = await http.post(url, body: {
      'phone': CURRENT_USER,
    });
    var jsonServerData = json.decode(response.body);

    print("Response======>>>> ${response.body}");
    return jsonServerData;
  }

  Future<dynamic> getZamzamUpdateData() async {
    var response = await http.get(base_url + 'zamzamupdates');
    var jsonServerData = json.decode(response.body);
    print("Response ${response.body}");
    return jsonServerData;
  }

  Future<dynamic> getImageFromFolder(folder, type) async {
    print("=========>>>>>" + folder);
    var url = base_url + 'getimagefile/' + type;
    var response = await http.post(url, body: {
      'folder': folder,
    });

    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  // Payment records

  Future<dynamic> createPayment(amount, projectData, method, status,
      isRecurring, type, signupPaymentDescription) async {
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
    });
    print('Payment Response status: ${response.statusCode}');
    print('Payment Response body: ${response.body}');
    return response;
  }

  Future<dynamic> getPaymentData() async {
    var url = base_url + 'getpayment';
    var response = await http.post(url, body: {
      'user_id': CURRENT_USER,
    });
    var jsonServerData = json.decode(response.body);
    return jsonServerData;
  }

  Future<int> updateSlip(id, path) async {
    String base64Image = base64Encode(File(path).readAsBytesSync());
    String fileName = File(path).path.split('/').last;
    print('payment_id::::::::: $id');
    var response = await http.post(base_url + 'updateslip', body: {
      "payment_id": "$id",
      "image": base64Image,
      "filename": fileName
    });
    print("Slip Update Response:::" + response.body);
    return response.statusCode;
  }

  Future<dynamic> getCompanyData() async {
    var response = await http.get(base_url + 'companydata');
    var jsonServerData = json.decode(response.body);
    print("Response ${response.body}");
    return jsonServerData;
  }

// Channels

  Future<dynamic> getChannelData() async {
    var response = await http.get(base_url + 'channels');
    var jsonServerData = json.decode(response.body);
    print(jsonServerData);
    return jsonServerData;
  }

// Job
  Future<dynamic> getJobData() async {
    var url = base_url + 'alljob';
    var response = await http.get(url);
    var jsonServerData = json.decode(response.body);
    return jsonServerData;
  }

  Future<int> postJob(type, title, location, minExperience, description,
      contact, email, image, organization) async {
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
    });
    print('Response status: ${response.statusCode}');
    return response.statusCode;
    // print('Response body: ${response.body}');
  }

  Future<int> deleteJob(id) async {
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    var url = base_url + 'deletejob';
    var response = await http.post(url, body: {
      'id': '$id',
    });

    print(response.statusCode);
    print(response.body);
    return response.statusCode;
  }

  Future<int> editJob(id, title, location, minExperience, description, contact,
      email, image, organization) async {
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
    });

    return response.statusCode;
  }

  //Chat
  Future createChat(chatTopic, chatId, message, toUser) async {
    var url = base_url + 'createchat';

    var response = await http.post(url, body: {
      'from_user': currentUserData['user_id'],
      'to_user': '$toUser',
      'topic': '$chatTopic',
      'message': '$message',
      'chat_id': '$chatId',
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response.statusCode;
  }

  Future<dynamic> getChatTopicsByPhone() async {
    var url = base_url + 'getchattopicsbyphone';
    var response = await http.post(url, body: {
      'phone': CURRENT_USER,
    });
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getChatById(chatId) async {
    var url = base_url + 'getchatbyid';
    var response = await http.post(url, body: {
      'chat_id': chatId,
    });
    var jsonServerData = json.decode(response.body);

    return jsonServerData;
  }

  Future<dynamic> getChatTopics() async {
    var url = base_url + 'getchattopics';
    var response = await http.post(url);

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
    print("Testingggggg.....");
    var url = base_url + 'convertCurrency';

    var response = await http.post(url, body: {
      'from': '$from',
      'to': '$to',
      'amount': '$amount',
    });
    print('Currency Response status: ${response.statusCode}');
    print('Currency Response body: ${response.body}');
    return response.body;
  }
}
