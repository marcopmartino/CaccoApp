import 'package:CaccoApp/view/item/UserSearchItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../view/item/CaccoHomeViewItem.dart';
import '../view/item/CaccoItem.dart';
import '../view/item/Item.dart';
import 'AppColors.dart';
import 'CustomEdgeInsets.dart';

class ListViewBuilder extends StatelessWidget {
  final List<QueryDocumentSnapshot<Object?>> data;
  final Function(QueryDocumentSnapshot<Object?> itemData) onTap;
  final ItemType itemType;
  final double scale;
  final ScrollPhysics? scrollPhysics;
  final bool shrinkWrap;
  final bool? primaryScrollableWidget;
  final bool expanded;

  const ListViewBuilder({super.key,
    required this.data,
    required this.onTap,
    this.itemType = ItemType.NONE,
    this.scale = 1,
    this.scrollPhysics,
    this.shrinkWrap = false,
    this.primaryScrollableWidget,
    this.expanded = false,
  });

  Item _getListItem(QueryDocumentSnapshot<Object?> itemData) {
    switch(itemType) {
      case ItemType.CACCO:
        return CaccoItem(itemData: itemData);
      case ItemType.CACCO_HOME_VIEW:
        return CaccoHomeViewItem(itemData: itemData);
      case ItemType.USER_SEARCH:
        return UserSearchItem(itemData: itemData);
      default:
        return Item(itemData: itemData);
    }
  }

  Widget _listView() {
    return SizedBox(
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          primary: primaryScrollableWidget,
          shrinkWrap: shrinkWrap,
          physics: scrollPhysics,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final itemData = data[index];
            return Container(
              margin: CustomEdgeInsets.list(data.length, index, scale: scale),
              // Spaziatura esterna
              width: double.infinity,
              child: InkWell(
                  onTap: () => onTap(itemData),
                  child: _getListItem(itemData)
              ),
            );
          },
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return expanded ? Expanded(child: _listView()) : _listView();
  }
}

class DismissibleListViewBuilder extends ListViewBuilder {
  final bool Function(QueryDocumentSnapshot<Object?> itemData)? dismissPolicy;
  final Function(String itemId)? onDismiss;

  const DismissibleListViewBuilder({super.key,
    required super.data,
    required super.onTap,
    super.itemType = ItemType.NONE,
    super.scale = 1,
    super.scrollPhysics,
    super.shrinkWrap = false,
    super.primaryScrollableWidget,
    super.expanded = false,
    this.dismissPolicy,
    this.onDismiss
  });

  DismissDirection _dismissDirection(QueryDocumentSnapshot<Object?> itemData) {
    if (dismissPolicy == null || dismissPolicy!(itemData)) {
      return DismissDirection.endToStart;
    } else {
      return DismissDirection.none;
    }
  }

  @override
  Widget _listView() {
    return SizedBox(
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          primary: primaryScrollableWidget,
          shrinkWrap: shrinkWrap,
          physics: scrollPhysics,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final itemData = data[index];
            final itemId = itemData.id;
            return Dismissible(
                key: Key(itemId),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  color: Colors.red,
                  child: const Icon(Icons.delete, size: 40.0, color: Colors.white),
                ),
                direction: _dismissDirection(itemData),
                onDismissed: (_) {
                  data.removeAt(index);
                  if (onDismiss != null) {
                    onDismiss!(itemId);
                  }
                },
                child: Container(
                  margin: CustomEdgeInsets.list(data.length, index, scale: scale),
                  // Spaziatura esterna
                  width: double.infinity,
                  child: InkWell(
                      onTap: () => onTap(itemData),
                      child: _getListItem(itemData)
                  ),
                )
            );
          },
        )
    );
  }
}

class FutureListViewBuilder extends StatelessWidget {
  final Future<QuerySnapshot<Object?>> future;
  final Function(QueryDocumentSnapshot<Object?> itemdata) onTap;
  final ItemType itemType;
  final double scale;
  final ScrollPhysics? scrollPhysics;
  final bool shrinkWrap;
  final bool? primaryScrollableWidget;
  final bool expanded;

  const FutureListViewBuilder({super.key,
    required this.future,
    required this.onTap,
    this.itemType = ItemType.NONE,
    this.scale = 1,
    this.scrollPhysics,
    this.shrinkWrap = false,
    this.primaryScrollableWidget,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.bloodyBrown));
        } else {
          return ListViewBuilder(
            data: snapshot.requireData.docs,
            onTap: onTap,
            itemType: itemType,
            scale: scale,
            scrollPhysics: scrollPhysics,
            shrinkWrap: shrinkWrap,
            primaryScrollableWidget: primaryScrollableWidget,
            expanded: expanded,
          );
        }
      },
    );
  }
}