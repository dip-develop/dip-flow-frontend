import 'package:injectable/injectable.dart';

import '../exceptions/app_exception.dart';
import '../repositories/repositories.dart';

abstract class AnalyticsUseCase {
  Future<void> logScreenView({required String name, String? path});
  Future<void> logAppException(AppException exception);
  Future<void> logFirstOpen();
  Future<void> logFirstVisit();
  Future<void> logSelectItem({required int itemId, String? itemName});
  Future<void> logShare({String? contentType, int? itemId, String? method});
  Future<void> logSignIn({String? method});
  Future<void> logSignUp({String? method});
  Future<void> logViewItem({required int itemId, String? itemName});
  Future<void> logViewItemList({required int listId, String? listName});
  Future<void> logViewSearchResults({required String searchTerm});
}

@LazySingleton(as: AnalyticsUseCase)
class AnalyticsUseCaseImpl implements AnalyticsUseCase {
  final AnalyticsRepository _analytics;

  const AnalyticsUseCaseImpl(this._analytics);

  @override
  Future<void> logScreenView({required String name, String? path}) =>
      _analytics.logScreenView(name: name, path: path);

  @override
  Future<void> logAppException(AppException exception) =>
      _analytics.logAppException(exception);

  @override
  Future<void> logFirstOpen() => _analytics.logFirstOpen();

  @override
  Future<void> logFirstVisit() => _analytics.logFirstVisit();

  @override
  Future<void> logSelectItem({required int itemId, String? itemName}) =>
      _analytics.logSelectItem(itemId: itemId, itemName: itemName);

  @override
  Future<void> logShare({String? contentType, int? itemId, String? method}) =>
      _analytics.logShare(
          contentType: contentType, itemId: itemId, method: method);

  @override
  Future<void> logSignIn({String? method}) =>
      _analytics.logSignIn(method: method);

  @override
  Future<void> logSignUp({String? method}) =>
      _analytics.logSignUp(method: method);

  @override
  Future<void> logViewItem({required int itemId, String? itemName}) =>
      _analytics.logViewItem(itemId: itemId, itemName: itemName);

  @override
  Future<void> logViewItemList({required int listId, String? listName}) =>
      _analytics.logViewItemList(listId: listId, listName: listName);

  @override
  Future<void> logViewSearchResults({required String searchTerm}) =>
      _analytics.logViewSearchResults(searchTerm: searchTerm);
}
