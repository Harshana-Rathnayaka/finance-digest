class CustomException implements Exception {
  final dynamic _message;

  CustomException([this._message]);

  @override
  String toString() => "Error During Communication - $_message";
}

class FetchDataException extends CustomException {
  FetchDataException(String super.message);
}

class BadRequestException extends CustomException {
  BadRequestException(Map message) : super(message['error']);
}

class UnauthorizedException extends CustomException {
  UnauthorizedException(Map message) : super(message['error']);
}

class NotFoundException extends CustomException {
  NotFoundException(Map message) : super(message['error']);
}

class InvalidInputException extends CustomException {
  InvalidInputException(Map message) : super(message['error']);
}

class InternalServerErrorException extends CustomException {
  InternalServerErrorException(Map message) : super(message['error']);
}
