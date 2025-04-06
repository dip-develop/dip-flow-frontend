import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mixpanel_analytics/mixpanel_analytics.dart';

import '../../../domain/repositories/repositories.dart';

@LazySingleton(as: AnalyticsRepository)
class MixpanelAnalyticsRepository implements AnalyticsRepository {
  late final MixpanelAnalytics _mixpanelAnalytics;

  MixpanelAnalyticsRepository() {
    _mixpanelAnalytics = MixpanelAnalytics.batch(
      token: '199db839368b1b91da8de2bda30d743d',
      verbose: kDebugMode,
      uploadInterval: const Duration(seconds: 30),
      onError: (p0) {
        debugPrint(p0.toString());
      },
    );
  }

  @override
  void updateUser({int? id, String? email, String? name}) {
    if (email != null || name != null) {
      _mixpanelAnalytics
          .engage(operation: MixpanelUpdateOperations.$set, value: {
        if (email != null) 'email': email,
        if (name != null) 'name': name,
      });
    }
    _mixpanelAnalytics.userId = id.toString();
  }

  @override
  Future<bool> logScreenView({required String name, String? path}) =>
      _mixpanelAnalytics.track(event: 'screen_view', properties: {
        'screenName': name,
        if (path != null) 'screenPath': path,
      });

  @override
  Future<bool> logAppException(dynamic exception) =>
      _mixpanelAnalytics.track(event: 'app_exception', properties: {
        'exception': exception.toString(),
      });

  @override
  Future<bool> logFirstOpen() =>
      _mixpanelAnalytics.track(event: 'first_open', properties: {});

  @override
  Future<bool> logFirstVisit() =>
      _mixpanelAnalytics.track(event: 'first_visit', properties: {});

  @override
  Future<bool> logSelectItem({required int itemId, String? itemName}) =>
      _mixpanelAnalytics.track(event: 'select_item', properties: {
        'item_list_id': itemId.toString(),
        if (itemName != null) 'item_list_name': itemName,
      });

  @override
  Future<bool> logShare({String? contentType, int? itemId, String? method}) =>
      _mixpanelAnalytics.track(event: 'share', properties: {
        if (contentType != null) 'content_type': contentType,
        if (itemId != null) 'item_id': itemId.toString(),
        if (method != null) 'method': method,
      });

  @override
  Future<bool> logSignIn({String? method}) =>
      _mixpanelAnalytics.track(event: 'login', properties: {
        if (method != null) 'method': method,
      });

  @override
  Future<bool> logSignUp({String? method}) =>
      _mixpanelAnalytics.track(event: 'sign_up', properties: {
        if (method != null) 'method': method,
      });

  @override
  Future<bool> logViewItem({required int itemId, String? itemName}) =>
      _mixpanelAnalytics.track(event: 'view_item', properties: {
        'item_id': itemId.toString(),
        if (itemName != null) 'item_name': itemId.toString(),
      });

  @override
  Future<bool> logViewItemList({required int listId, String? listName}) =>
      _mixpanelAnalytics.track(event: 'view_item_list', properties: {
        'list_id': listId.toString(),
        if (listName != null) 'list_name': listName,
      });

  @override
  Future<bool> logViewSearchResults({required String searchTerm}) =>
      _mixpanelAnalytics.track(event: 'view_search_results', properties: {
        'search_term': searchTerm,
      });
}
