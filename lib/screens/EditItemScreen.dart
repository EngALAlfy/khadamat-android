import 'dart:io';

import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khadamat_app/models/Item.dart';
import 'package:khadamat_app/providers/CategoriesProvider.dart';
import 'package:khadamat_app/providers/ItemsProvider.dart';
import 'package:khadamat_app/widgets/IsErrorWidget.dart';
import 'package:khadamat_app/widgets/IsLoadingWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smart_select/smart_select.dart';

class EditItemScreen extends StatefulWidget {
  final Item item;

  const EditItemScreen({Key key, this.item}) : super(key: key);
  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(EzLocalization.of(context).get("update_item")),
        centerTitle: true,
      ),
      body: Form(
        key: _key,
        child: Consumer2<CategoriesProvider, ItemsProvider>(
          builder: (context, value, value2, child) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: EzLocalization.of(context).get("desc"),
                  ),
                  maxLines: null,
                  minLines: 4,
                  controller: value2.descController,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(
                  height: 10,
                ),
                selectCategory(context, value, value2),
                SizedBox(
                  height: 10,
                ),
                selectSubCategory(context, value, value2),
                SizedBox(
                  height: 10,
                ),
                selectSubSubCategory(context, value, value2),
                SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                  onPressed: () async {
                    await Permission.storage.request();

                    Alert(
                      title: EzLocalization.of(context).get("pick_image"),
                      context: context,
                      content: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.image),
                            title:
                            Text(EzLocalization.of(context).get("gallery")),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              // Pick an image
                              XFile image = await _picker.pickImage(
                                  source: ImageSource.gallery);

                              value2.image = image.path;
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt_outlined),
                            title:
                            Text(EzLocalization.of(context).get("camera")),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              // Capture a photo
                              XFile photo = await _picker.pickImage(
                                  source: ImageSource.camera);

                              value2.image = photo.path;
                            },
                          )
                        ],
                      ),
                    ).show();

                    /*
                    List<Media> res = await ImagesPicker.pick(
                      count: 1,
                      language: Language.English,
                      quality: 0.7,
                      cropOpt: CropOption(cropType: CropType.rect),
                      pickType: PickType.image,
                    );

                    value2.image = res.first.path;

                     */
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    EzLocalization.of(context).get("upload_image"),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                value2.image == null || value2.image.isEmpty
                    ? Container()
                    : Image.file(File(value2.image)),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: () async {
                    await Permission.storage.request();

                    Alert(
                      title: EzLocalization.of(context).get("pick_image"),
                      context: context,
                      content: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.image),
                            title:
                            Text(EzLocalization.of(context).get("gallery")),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              // Pick an image
                              XFile image = await _picker.pickImage(
                                  source: ImageSource.gallery);

                              value2.image1 = image.path;
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt_outlined),
                            title:
                            Text(EzLocalization.of(context).get("camera")),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              // Capture a photo
                              XFile photo = await _picker.pickImage(
                                  source: ImageSource.camera);

                              value2.image1 = photo.path;
                            },
                          )
                        ],
                      ),
                    ).show();

                  },
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    EzLocalization.of(context).get("upload_image1"),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                value2.image1 == null || value2.image1.isEmpty
                    ? Container()
                    : Image.file(File(value2.image1)),
                SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: () async {
                    await Permission.storage.request();


                    Alert(
                      title: EzLocalization.of(context).get("pick_image"),
                      context: context,
                      content: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.image),
                            title:
                            Text(EzLocalization.of(context).get("gallery")),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              // Pick an image
                              XFile image = await _picker.pickImage(
                                  source: ImageSource.gallery);

                              value2.image2 = image.path;
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt_outlined),
                            title:
                            Text(EzLocalization.of(context).get("camera")),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              // Capture a photo
                              XFile photo = await _picker.pickImage(
                                  source: ImageSource.camera);

                              value2.image2 = photo.path;
                            },
                          )
                        ],
                      ),
                    ).show();
/*
                    List<Media> res = await ImagesPicker.pick(
                      count: 1,
                      language: Language.English,
                      quality: 0.7,
                      cropOpt: CropOption(cropType: CropType.rect),
                      pickType: PickType.image,
                    );

                    value2.image2 = res.first.path;

 */
                  },
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    EzLocalization.of(context).get("upload_image2"),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                value2.image2 == null || value2.image2.isEmpty
                    ? Container()
                    : Image.file(File(value2.image2)),
                SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: () async {
                    await Permission.storage.request();


                    Alert(
                      title: EzLocalization.of(context).get("pick_image"),
                      context: context,
                      content: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.image),
                            title:
                            Text(EzLocalization.of(context).get("gallery")),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              // Pick an image
                              XFile image = await _picker.pickImage(
                                  source: ImageSource.gallery);

                              value2.image3 = image.path;
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt_outlined),
                            title:
                            Text(EzLocalization.of(context).get("camera")),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              // Capture a photo
                              XFile photo = await _picker.pickImage(
                                  source: ImageSource.camera);

                              value2.image3 = photo.path;
                            },
                          )
                        ],
                      ),
                    ).show();
                    /*
                    List<Media> res = await ImagesPicker.pick(
                      count: 1,
                      language: Language.English,
                      quality: 0.7,
                      cropOpt: CropOption(cropType: CropType.rect),
                      pickType: PickType.image,
                    );

                    value2.image3 = res.first.path;

                     */
                  },
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    EzLocalization.of(context).get("upload_image3"),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                value2.image3 == null || value2.image3.isEmpty
                    ? Container()
                    : Image.file(File(value2.image3)),
                SizedBox(
                  height: 10,
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: () async {
                    await Permission.storage.request();



                    Alert(
                      title: EzLocalization.of(context).get("pick_image"),
                      context: context,
                      content: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.image),
                            title:
                            Text(EzLocalization.of(context).get("gallery")),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              // Pick an image
                              XFile image = await _picker.pickImage(
                                  source: ImageSource.gallery);

                              value2.image4 = image.path;
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt_outlined),
                            title:
                            Text(EzLocalization.of(context).get("camera")),
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              // Capture a photo
                              XFile photo = await _picker.pickImage(
                                  source: ImageSource.camera);

                              value2.image4 = photo.path;
                            },
                          )
                        ],
                      ),
                    ).show();
/*
                    List<Media> res = await ImagesPicker.pick(
                      count: 1,
                      language: Language.English,
                      quality: 0.7,
                      cropOpt: CropOption(cropType: CropType.rect),
                      pickType: PickType.image,
                    );

                    value2.image4 = res.first.path;
                    */
                  },
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    EzLocalization.of(context).get("upload_image4"),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                value2.image4 == null || value2.image4.isEmpty
                    ? Container()
                    : Image.file(File(value2.image4)),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 20,
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () {
                    if (_key.currentState.validate()) {
                      value2.updateItem(context , widget.item.id);
                    }
                  },
                  icon: Icon(
                    Icons.save_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    EzLocalization.of(context).get("update"),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  selectCategory(
      BuildContext context, CategoriesProvider value, ItemsProvider value2) {
    if (value.selectCategoriesResponse.isLoading) {
      return IsLoadingWidget();
    }

    if (value.selectCategoriesResponse.isError) {
      return IsErrorWidget(
        error: value.selectCategoriesResponse.error,
      );
    }

    return SmartSelect<String>.single(
      title: EzLocalization.of(context).get("categories"),
      value: value2.category_id,
      choiceItems: value.selectCategoriesResponse.data,
      modalType: S2ModalType.bottomSheet,
      choiceType: S2ChoiceType.radios,
      onChange: (state) {
        value2.category_id = state.value;
        value.selectSubCategories(context, state.value);
      },
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          isTwoLine: true,
          trailing: Icon(Icons.keyboard_arrow_left_rounded),
        );
      },
    );
  }

  selectSubCategory(
      BuildContext context, CategoriesProvider value, ItemsProvider value2) {
    if (value.selectSubCategoriesResponse.isLoading) {
      return IsLoadingWidget();
    }

    if (value.selectSubCategoriesResponse.isError != null &&
        value.selectSubCategoriesResponse.isError) {
      return IsErrorWidget(
        error: value.selectSubCategoriesResponse.error,
      );
    }

    return SmartSelect<String>.single(
      title: EzLocalization.of(context).get("subcategories"),
      value: value2.subcategory_id,
      choiceItems: value.selectSubCategoriesResponse.data,
      modalType: S2ModalType.bottomSheet,
      choiceType: S2ChoiceType.radios,
      onChange: (state) {
        value2.subcategory_id = state.value;
        value.selectSubSubCategories(context, state.value);
      },
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          isTwoLine: true,
          trailing: Icon(Icons.keyboard_arrow_left_rounded),
        );
      },
    );
  }

  selectSubSubCategory(
      BuildContext context, CategoriesProvider value, ItemsProvider value2) {
    if (value.selectSubSubCategoriesResponse.isLoading) {
      return IsLoadingWidget();
    }

    if (value.selectSubSubCategoriesResponse.isError != null &&
        value.selectSubSubCategoriesResponse.isError) {
      return IsErrorWidget(
        error: value.selectSubSubCategoriesResponse.error,
      );
    }

    return SmartSelect<String>.single(
      title: EzLocalization.of(context).get("subsubcategories"),
      value: value2.subsubcategory_id,
      choiceItems: value.selectSubSubCategoriesResponse.data,
      modalType: S2ModalType.bottomSheet,
      choiceType: S2ChoiceType.radios,
      onChange: (state) {
        value2.subsubcategory_id = state.value;
      },
      tileBuilder: (context, state) {
        return S2Tile.fromState(
          state,
          isTwoLine: true,
          trailing: Icon(Icons.keyboard_arrow_left_rounded),
        );
      },
    );
  }

  @override
  void initState() {
    context.read<ItemsProvider>().initUpdate(widget.item);
    context.read<CategoriesProvider>().selectCategories(context);
    context.read<CategoriesProvider>().selectSubCategories(context , widget.item.category.id);
    context.read<CategoriesProvider>().selectSubSubCategories(context , widget.item.subcategory.id);
    super.initState();
  }
}
