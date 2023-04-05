class Client {
  String? uID;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? dateCreate;
  DateTime? dateUpdate;

  Client({
    this.uID,
    this.lastName,
    this.firstName,
    this.email,
    this.dateCreate,
    this.dateUpdate,
  });
  factory Client.fromMap(map) {
    return Client(
      uID: map['uID'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      dateCreate: map["dateCreate"].toDate(),
      dateUpdate: map["dateUpdate"].toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uID': uID,
      "firstName": firstName,
      'status': true,
      "lastName": lastName,
      "dateCreate": DateTime.now(),
      "dateUpdate": DateTime.now(),
      'email': email,
    };
  }
}
