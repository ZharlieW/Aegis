/// Authentication challenge message from relay.
class Auth {
  Auth.deserialize(List<dynamic> input)
      : assert(input.length == 2),
        challenge = input[1] as String;

  String challenge;
}

