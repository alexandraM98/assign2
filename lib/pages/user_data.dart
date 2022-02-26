class UserData {
  late double lat;
  late double long;
  late double time;


  UserData({required this.lat, required this.long, required this.time});

  Map <String, dynamic> toJson() {
    return {
      'latitude': lat,
      'longitude': long,
      'time': time
    };
  }
}