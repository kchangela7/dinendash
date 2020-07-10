class User {

  final String uid;
  final bool verified;

  User({ this.uid, this.verified});

}

class UserData {

  final String uid;
  final PersonalInfo personal;

  UserData({ this.uid, this.personal });

}

class PersonalInfo {

  final String firstName;
  final String lastName;
  final String email;
  final String address;

  PersonalInfo({ this.firstName, this.lastName, this.email, this.address });

}