class NotificationModelData {
/*
{
  "id": 2,
  "sender_id": null,
  "receiver_id": 2,
  "league_id": null,
  "is_admin": 1,
  "type": "Title1",
  "message": "Description",
  "created_at": "2023-10-20T12:09:05.000000Z",
  "updated_at": "2023-10-20T12:09:05.000000Z",
  "user": null
}
*/

  int? id;
  String? senderId;
  int? receiverId;
  String? leagueId;
  int? isAdmin;
  String? type;
  String? message;
  String? createdAt;
  String? updatedAt;
  String? user;

  NotificationModelData({
    this.id,
    this.senderId,
    this.receiverId,
    this.leagueId,
    this.isAdmin,
    this.type,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.user,
  });
  NotificationModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    senderId = json['sender_id']?.toString();
    receiverId = json['receiver_id']?.toInt();
    leagueId = json['league_id']?.toString();
    isAdmin = json['is_admin']?.toInt();
    type = json['type']?.toString();
    message = json['message']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    user = json['user']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['league_id'] = leagueId;
    data['is_admin'] = isAdmin;
    data['type'] = type;
    data['message'] = message;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user'] = user;
    return data;
  }
}

class NotificationModel {
/*
{
  "status": 1,
  "message": "Notifications",
  "data": [
    {
      "id": 2,
      "sender_id": null,
      "receiver_id": 2,
      "league_id": null,
      "is_admin": 1,
      "type": "Title1",
      "message": "Description",
      "created_at": "2023-10-20T12:09:05.000000Z",
      "updated_at": "2023-10-20T12:09:05.000000Z",
      "user": null
    }
  ]
}
*/

  int? status;
  String? message;
  List<NotificationModelData?>? data;

  NotificationModel({
    this.status,
    this.message,
    this.data,
  });
  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toInt();
    message = json['message']?.toString();
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <NotificationModelData>[];
      v.forEach((v) {
        arr0.add(NotificationModelData.fromJson(v));
      });
      this.data = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['data'] = arr0;
    }
    return data;
  }
}
