class APIResponse<T> {
  String _error;
  bool _isError = false;
  List<T> _data;

  bool _isLoading = true;

  bool get isEmpty => (data == null || data.isEmpty) && isLoading == false;

  bool get isLoading => _isLoading;

  List<T> get data => _data;

  set data(List<T> value) {
    _isLoading = false;
    _data = value;
  }


  set isLoading(bool value) {
    _isLoading = value;
  }


  String get error => _error;

  set error(String value) {
    isError = true;
    _error = value;
  }

  bool get isError => _isError;

  set isError(bool value) {
    if(!value){
      isLoading = true;
    }
    _isError = value;
  }
}


class SingleAPIResponse<T> {
  String _error;
  bool _isError;
  T _data;

  bool _isLoading = true;

  bool get isEmpty => data == null && isLoading == false;

  bool get isLoading => _isLoading;

  T get data => _data;

  set data(T value) {
    _isLoading = false;
    _data = value;
  }


  String get error => _error;

  set error(String value) {
    if(value != null) {
      isError = true;
    }
    _error = value;
  }

  set isLoading(bool value) {
    _isLoading = value;
  }

  bool get isError => _isError;

  set isError(bool value) {
    if(!value){
      isLoading = true;
    }
    _isError = value;
  }
}
