import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../view/item/Item.dart';
import 'AppColors.dart';
import 'ListViewBuilders.dart';

// StreamBuilder per singoli Document
class DocumentStreamBuilder extends StreamBuilder<DocumentSnapshot> {

  DocumentStreamBuilder({super.key, required super.stream, required Function(BuildContext, DocumentSnapshot<Object?>) builder}) :
        super(builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Errore - Riprova più tardi'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.bloodyBrown));
        }

        final DocumentSnapshot<Object?> data = snapshot.requireData;

        return builder(context, data);
      });

  DocumentStreamBuilder.futureStream({super.key, required future, required Function(BuildContext, DocumentSnapshot<Object?>) builder}) :
        super(stream: Stream.fromFuture(future), builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Errore - Riprova più tardi'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.bloodyBrown));
        }

        final DocumentSnapshot<Object?> data = snapshot.requireData;

        return builder(context, data);
      });
}

// StreamBuilder per Collection intere
class QueryStreamBuilder extends StreamBuilder<QuerySnapshot> {

  QueryStreamBuilder({super.key, required super.stream, required Function(BuildContext, QuerySnapshot<Object?>) builder}) :
        super(builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Errore - Riprova più tardi'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.bloodyBrown));
        }

        final QuerySnapshot<Object?> data = snapshot.requireData;

        return builder(context, data);
      });

  QueryStreamBuilder.futureStream({super.key, required future, required Function(BuildContext, QuerySnapshot<Object?>) builder}) :
        super(stream: Stream.fromFuture(future), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Errore - Riprova più tardi'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.bloodyBrown));
        }

        final QuerySnapshot<Object?> data = snapshot.requireData;

        return builder(context, data);
      });

}

// QueryStreamBuilder che si occupa anche di creare la view della lista
class ListViewStreamBuilder extends QueryStreamBuilder {

  ListViewStreamBuilder({super.key,
    required super.stream,
    required Function(QueryDocumentSnapshot<Object?>) onTap,
    ItemType itemType = ItemType.NONE,
    double scale = 1,
    ScrollPhysics? scrollPhysics,
    bool shrinkWrap = false,
    bool? primaryScrollableWidget,
    bool expanded = false,
    List<QueryDocumentSnapshot<Object?>> Function(List<QueryDocumentSnapshot<Object?>> data)? filterFunction,
  }) : super(builder: (BuildContext context, QuerySnapshot<Object?> data) {

    List<QueryDocumentSnapshot<Object?>> docs = data.docs;

    if (filterFunction != null) {
      docs = filterFunction(docs);
    }

    return ListViewBuilder(
      data: docs,
      itemType: itemType,
      scale: scale,
      onTap: (QueryDocumentSnapshot<Object?> itemData) => onTap(itemData),
      scrollPhysics: scrollPhysics,
      shrinkWrap: shrinkWrap,
      primaryScrollableWidget: primaryScrollableWidget,
      expanded: expanded,
    );
  });
}

// QueryStreamBuilder che si occupa di creare la view della lista con un messaggio di lista vuota
class ListViewStreamBuilderEmptyList extends QueryStreamBuilder {

  ListViewStreamBuilderEmptyList({super.key,
    required super.stream,
    required Function(QueryDocumentSnapshot<Object?>) onTap,
    ItemType itemType = ItemType.NONE,
    double scale = 1,
    ScrollPhysics? scrollPhysics,
    bool shrinkWrap = false,
    bool? primaryScrollableWidget,
    bool expanded = false,
    required Widget empty,
    List<QueryDocumentSnapshot<Object?>> Function(List<QueryDocumentSnapshot<Object?>> data)? filterFunction,
  }) : super(builder: (BuildContext context, QuerySnapshot<Object?> data) {

    List<QueryDocumentSnapshot<Object?>> docs = data.docs;

    if (filterFunction != null) {
      docs = filterFunction(docs);
    }

    if (docs.isEmpty) {
      return empty;
    }

    return ListViewBuilder(
      data: docs,
      itemType: itemType,
      scale: scale,
      onTap: (QueryDocumentSnapshot<Object?> itemData) => onTap(itemData),
      scrollPhysics: scrollPhysics,
      shrinkWrap: shrinkWrap,
      primaryScrollableWidget: primaryScrollableWidget,
      expanded: expanded,
    );

  });
}

// QueryStreamBuilder che si occupa di creare la view della lista senza onTap
class ListViewStreamBuilderNoTap extends QueryStreamBuilder{

  ListViewStreamBuilderNoTap({super.key,
    required super.stream,
    ItemType itemType = ItemType.NONE,
    double scale = 1,
    ScrollPhysics? scrollPhysics,
    bool shrinkWrap = false,
    bool? primaryScrollableWidget,
    bool expanded = false,
    List<QueryDocumentSnapshot<Object?>> Function(List<QueryDocumentSnapshot<Object?>> data)? filterFunction,
  }) : super(builder: (BuildContext context, QuerySnapshot<Object?> data) {

    List<QueryDocumentSnapshot<Object?>> docs = data.docs;

    if (filterFunction != null) {
      docs = filterFunction(docs);
    }

    return ListViewBuilder(
      data: docs,
      itemType: itemType,
      onTap: (QueryDocumentSnapshot<Object?> itemData) {},
      scale: scale,
      scrollPhysics: scrollPhysics,
      shrinkWrap: shrinkWrap,
      primaryScrollableWidget: primaryScrollableWidget,
      expanded: expanded,
    );
  });
}

// QueryStreamBuilder che si occupa di creare la view della lista con Dismissible
class DismissibleListViewStreamBuilder extends QueryStreamBuilder {

  DismissibleListViewStreamBuilder({super.key,
    required super.stream,
    required Function(QueryDocumentSnapshot<Object?> itemData) onTap,
    ItemType itemType = ItemType.NONE,
    double scale = 1,
    ScrollPhysics? scrollPhysics,
    bool shrinkWrap = false,
    bool? primaryScrollableWidget,
    bool expanded = false,
    List<QueryDocumentSnapshot<Object?>> Function(List<QueryDocumentSnapshot<Object?>> data)? filterFunction,
    bool Function(QueryDocumentSnapshot<Object?> itemData)? dismissPolicy,
    Function(String itemId)? onDismiss,
  }) : super(builder: (BuildContext context, QuerySnapshot<Object?> data) {

    List<QueryDocumentSnapshot<Object?>> docs = data.docs;

    if (filterFunction != null) {
      docs = filterFunction(docs);
    }

    return DismissibleListViewBuilder(
      data: docs,
      itemType: itemType,
      scale: scale,
      onTap: (QueryDocumentSnapshot<Object?> itemData) => onTap(itemData),
      scrollPhysics: scrollPhysics,
      shrinkWrap: shrinkWrap,
      primaryScrollableWidget: primaryScrollableWidget,
      expanded: expanded,
      dismissPolicy: dismissPolicy,
      onDismiss: onDismiss,
    );
  });
}