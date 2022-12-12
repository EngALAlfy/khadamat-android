import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:khadamat_app/mixins/APIResponse.dart';
import 'package:khadamat_app/models/Item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DatabaseProvider extends ChangeNotifier {
  Database db;
  APIResponse<Item> itemsResponse = APIResponse();
  bool isFavorite;

  init() async {
    // File path to a file in the current directory
    String dbPath =
        (await getApplicationDocumentsDirectory()).path + '/favorite.db';
    DatabaseFactory dbFactory = databaseFactoryIo;

    // We use the database factory to open the database
    db = await dbFactory.openDatabase(dbPath);
  }

  getFavorites() async {
    itemsResponse.error = null;
    itemsResponse.isError = false;

    try {
      if (db == null) {
        await init();
      }

      var store = StoreRef<int, Map<String, dynamic>>.main();
      var keys = await store.findKeys(db);
      var values = await store.records(keys).get(db);

      itemsResponse.data =
          values.map((e) => e == null ? null : Item.fromJson(e)).toList();
    } catch (e) {
      itemsResponse.error = e.toString();
    }

    notifyListeners();
  }

  favorite(context, Item item) async {
    try {
      if (db == null) {
        await init();
      }

      var store = StoreRef<int, Map<String, dynamic>>.main();
      await store.record(item.id).put(db, item.toJson());

      EasyLoading.showSuccess(EzLocalization.of(context).get("success"));

      checkFavorite(item.id);
      getFavorites();
    } catch (e) {
      EasyLoading.showError(EzLocalization.of(context).get("error"));
    }


  }

  unFavorite(context, Item item) async {
    try {
      if (db == null) {
        await init();
      }

      var store = StoreRef<int, Map<String, dynamic>>.main();
      await store.record(item.id).delete(db);

      EasyLoading.showSuccess(EzLocalization.of(context).get("success"));

      checkFavorite(item.id);
      getFavorites();
    } catch (e) {
      EasyLoading.showError(EzLocalization.of(context).get("error"));
    }
  }

  checkFavorite(id) async {
    isFavorite = false;

    try {
      if (db == null) {
        await init();
      }

      var store = StoreRef<int, Map<String, dynamic>>.main();
      var item = await store.record(id).get(db);

      isFavorite =  item != null;
    } catch (e) {
      isFavorite = false;
    }

    notifyListeners();
  }

}
