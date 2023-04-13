abstract class AnalyticsRepository {
  void updateUser({int? id, String? email, String? name});
  Future<bool> logScreenView({required String name, String? path});
  Future<bool> logAppException(dynamic exception);
  Future<bool> logFirstOpen();
  Future<bool> logFirstVisit();
  Future<bool> logSelectItem({required int itemId, String? itemName});
  Future<bool> logShare({String? contentType, int? itemId, String? method});
  Future<bool> logSignIn({String? method});
  Future<bool> logSignUp({String? method});
  Future<bool> logViewItem({required int itemId, String? itemName});
  Future<bool> logViewItemList({required int listId, String? listName});
  Future<bool> logViewSearchResults({required String searchTerm});
}
