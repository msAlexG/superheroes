
 class ApiExeption implements  Exception{
  final String message;

  ApiExeption(this.message);

  @override
  String toString() {
    return 'ApiExeption{message: $message}';
  }


}