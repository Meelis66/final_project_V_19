class Password {
  int? id;
  late String name;
  late String password;

  //nimeline konstruktor
  Password(this.name, this.password);

  //meetod muuta password object to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
    };
  }

//meetod muuta map instance to password object
  Password.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    password = map['password'];
  }
}
