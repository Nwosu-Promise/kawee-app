class ApiUtility {
  static String _register = "https://kawee.herokuapp.com/api/v1/users/signup";
  static String _login = "https://kawee.herokuapp.com/api/v1/users/login";
  static String _dashBoard =
      "https://kawee.herokuapp.com/api/v1/users/dashboard";
  static String _newNote = "https://kawee.herokuapp.com/api/v1/notes";
  static String _updateNote = "https://kawee.herokuapp.com/api/v1/notes/";
  static String _tts = "https://kawee.herokuapp.com/api/v1/tts";
  static String _updateTts = "https://kawee.herokuapp.com/api/v1/tts/";
  static String _newTodo = "https://kawee.herokuapp.com/api/v1/todos";
  static String _newTodo1 = "https://kawee.herokuapp.com/api/v1/todos/?status=";
  static String _deleteTodo = "https://kawee.herokuapp.com/api/v1/todos/";
  static String _getAllKanban =
      "https://kawee.herokuapp.com/api/v1/kanbans/board";
  static String _updateColumn =
      "https://kawee.herokuapp.com/api/v1/kanbans/column";

  static String _removeTaskFromColumn =
      "https://kawee.herokuapp.com/api/v1/kanbans/remove/";
  static String _addTaskToColumn =
      "https://kawee.herokuapp.com/api/v1/kanbans/add/";
  static String _getOneBoard =
      "https://kawee.herokuapp.com/api/v1/kanbans/board/";
  static String _newTask = "https://kawee.herokuapp.com/api/v1/kanbans/task/";
  static String _deleteTask =
      "https://kawee.herokuapp.com/api/v1/kanbans/task/";
  static String _deleteKanban =
      "https://kawee.herokuapp.com/api/v1/kanbans/board/";
  static String _createKanban =
      "https://kawee.herokuapp.com/api/v1/kanbans/board/";
  static String _deleteColumn =
      "https://kawee.herokuapp.com/api/v1/kanbans/column/";
  static String _createColumn =
      "https://kawee.herokuapp.com/api/v1/kanbans/column/board/";

  static String _getAllOcr = "https://kawee.herokuapp.com/api/v1/ocr/";
  static String _updateOcr = "https://kawee.herokuapp.com/api/v1/ocr/";

  static String _updateUser =
      "https://kawee.herokuapp.com/api/v1/users/updateMe";

  static String _updatePassword =
      "https://kawee.herokuapp.com/api/v1/users/updatePassword";

  static String _logOut = "https://kawee.herokuapp.com/api/v1/users/logout";

  static String _forgotPassword =
      "https://kawee.herokuapp.com/api/v1/users/forgotPassword";
  static String _resetPassword =
      "https://kawee.herokuapp.com/api/v1/users/resetPassword";

  final String resetPassword = _resetPassword;
  final String forgetPassword = _forgotPassword;
  final String updateUser = _updateUser;
  final String logOut = _logOut;
  final String updatePassword = _updatePassword;

  final String getAllOcr = _getAllOcr;
  final String updateOcr = _updateOcr;

  final String register = _register;
  final String login = _login;
  final String dashBoard = _dashBoard;
  final String newNote = _newNote;
  final String updateNote = _updateNote;
  final String tts = _tts;
  final String updateTts = _updateTts;
  final String newTodo = _newTodo;
  final String getTodo = _newTodo1;
  final String deleteTodo = _deleteTodo;
  final String getAllKanban = _getAllKanban;
  final String updateColumn = _updateColumn;
  final String removeTAsKFromColumn = _removeTaskFromColumn;
  final String addTaskToColumn = _addTaskToColumn;
  final String getOneBoard = _getOneBoard;
  final String newTask = _newTask;
  final String deleteTask = _deleteTask;
  final String deleteKanban = _deleteKanban;
  final String createKanban = _createKanban;
  final String deleteColumn = _deleteColumn;
  final String createColumn = _createColumn;
}
