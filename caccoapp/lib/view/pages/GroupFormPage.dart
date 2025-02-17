import 'package:CaccoApp/utility/Extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:CaccoApp/view/widget/CustomButton.dart';
import 'package:CaccoApp/view/widget/TextWidgets.dart';

import 'package:CaccoApp/models/Cacco.dart';
import 'package:CaccoApp/utility/AppColors.dart';
import 'package:CaccoApp/utility/Navigation.dart';

import 'package:CaccoApp/network/CaccoNetwork.dart';
import 'package:intl/intl.dart';

import '../../models/Group.dart';
import '../../network/GroupsNetwork.dart';
import '../../utility/AppFontWeight.dart';
import '../widget/CustomScaffold.dart';

class GroupFormPage extends StatefulWidget {

    @override
    State<GroupFormPage> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupFormPage> {
    final _formKey = GlobalKey<FormState>();

    final _nameTextController = TextEditingController();

    bool _isProcessing = false;

    late DocumentSnapshot<Object?> _oldData;

    final _focusNome = FocusNode();

    @override
    Widget build(BuildContext context) {
        final size = MediaQuery.of(context).size;
        String title = 'Crea gruppo';
        if (_isProcessing) {
            return CustomScaffold(
                title: title,
                body: const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.mainBrown,
                    )));
        } else  {
            return CustomScaffold(
                title: title,
                withAppbar: true,
                body: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: SizedBox(
                        height: size.height,
                        width: size.width,
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: formBody(),
                                ),
                                const SizedBox(height: 40),
                                createButton(context)
                            ],
                        ),
                    ),
                ));
        }
    }

    Widget formBody() {
        bool necessary = true;

        return Form(
            key: _formKey,
            child: Column(
                children: [
                    const SizedBox(height: 10),
                    Flexible(
                        flex: 0,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                            child: TextFormFieldWidget(
                                controller: _nameTextController,
                                label: 'Nome',
                                hint: 'Inserire nome'),
                        ),
                    ),
                ],
            ));
    }

    // Button per creare un nuovo gruppo
    Widget createButton(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 200),
            child: CustomButtons.submit(
                'Crea gruppo',
                onPressed: () async {
                    _focusNome.unfocus();

                    if (_formKey.currentState!.validate()) {
                        setState(() {
                            _isProcessing = true;
                        });

                        var now = DateTime.now();
                        var formatter = DateFormat('dd-MM-yyyy');
                        String formattedDate = formatter.format(now);

                        await GroupsNetwork.createGroup(Group(
                            adminId: FirebaseAuth.instance.currentUser!.uid,
                            adminName: FirebaseAuth.instance.currentUser!.displayName!,
                            name: _nameTextController.text,
                            creationDate: formattedDate,
                        ).toMap());

                        if (context.mounted) {
                            Navigation.back(context);
                        }
                    }
                },
            ));
    }


}