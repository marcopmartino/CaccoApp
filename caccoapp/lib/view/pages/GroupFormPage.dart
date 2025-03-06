import 'package:CaccoApp/helpers/LoginService.dart';
import 'package:CaccoApp/utility/DocumentStreamBuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:CaccoApp/view/widget/CustomButton.dart';
import 'package:CaccoApp/view/widget/TextWidgets.dart';

import 'package:CaccoApp/utility/AppColors.dart';
import 'package:CaccoApp/utility/Navigation.dart';

import 'package:intl/intl.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';

import '../../models/Group.dart';
import '../../network/GroupsNetwork.dart';
import '../../utility/CustomEdgeInsets.dart';
import '../widget/CustomScaffold.dart';
import 'GroupDetailsPage.dart';

class GroupFormPage extends StatefulWidget {
  GroupFormPage({super.key}) {
    newGroup = true;
  }

  static const String route = 'groupForm';

  GroupFormPage.edit({super.key, required this.groupId}) {
    newGroup = false;
  }

  late final String? groupId;
  late final bool newGroup;

  @override
  State<GroupFormPage> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();

  bool _isProcessing = false;
  bool _initializationCompleted = false;

  late DocumentSnapshot<Object?> _oldGroup;

  final _focusNome = FocusNode();

  void startLoadingAnimation() {
    setState(() {
      _isProcessing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String title = widget.newGroup ? 'Crea gruppo' : 'Modifica gruppo';

    if (_isProcessing) {
      return CustomScaffold(
          title: title,
          body: const Center(
              child: LogoandSpinner(
            imageAssets: 'assets/temp-image.jpg',
            reverse: true,
            arcColor: AppColors.sandBrown,
            spinSpeed: Duration(milliseconds: 500),
          )));
    } else if (widget.newGroup) {
      return CustomScaffold(
          title: title,
          withAppbar: true,
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
    } else if (_initializationCompleted) {
      return CustomScaffold.form(
          title: title,
          withAppbar: true,
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: formBody(),
                  ),
                  const SizedBox(height: 40),
                  Flexible(
                      flex: 1,
                      child: editButton(context)
                  )
                ],
              ),
            ),
          ));
    } else {
      return CustomScaffold.form(
          title: title,
          withAppbar: true,
          body: DocumentStreamBuilder(
              stream: GroupsNetwork.getGroupDetailsStream(widget.groupId!),
              builder: (BuildContext context,
                  DocumentSnapshot<Object?> groupDetails) {
                _nameTextController.text = groupDetails['name'];
                _initializationCompleted = true;

                _oldGroup = groupDetails;

                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SizedBox(
                    height: size.height,
                    width: size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 3,
                          child: formBody(),
                        ),
                        const SizedBox(height: 40),
                        Flexible(
                            flex: 1,
                            child: editButton(context)
                        )
                      ],
                    ),
                  ),
                );
              }));
    }
  }

  Widget formBody() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Flexible(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: TextFormFieldWidget(
                  controller: _nameTextController,
                  label: 'Nome',
                  hint: 'Inserire nome',
                  maxLines: 1,
                ),
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
                adminName: LoginService.loggedInUserModel!.username!,
                name: _nameTextController.text,
                creationDate: formattedDate,
              ).toMap()).then((groupId){
                Future.delayed(const Duration(seconds: 1), () => {
                  if(context.mounted)
                    Navigation.navigateFromLeft(context, GroupDetailsPage(groupId: groupId))
                });
              });


            }
          },
        ));
  }

  // Button per modificare un gruppo
  Widget editButton(BuildContext context) {

    return Padding(
      padding: const CustomEdgeInsets.only(left:16, right: 16, top: 16, bottom:32),
        child: CustomButtons.submit(
          'Salva modifiche',
          onPressed: () async {
            if(_formKey.currentState!.validate()){
              startLoadingAnimation();

              if(_nameTextController.text == _oldGroup['name']){
                if(context.mounted) Navigation.replaceFromLeft(context, GroupDetailsPage(groupId: _oldGroup.id));
              }

              Group group = Group(
                id: _oldGroup.id,
                adminId: _oldGroup['adminId'],
                adminName: _oldGroup['adminName'],
                name: _nameTextController.text,
                memberCounter: _oldGroup['membersCounter'],
                creationDate: _oldGroup['creationDate']
              );

              await GroupsNetwork.updateGroup(group).then((_){
                if(context.mounted) Navigation.replaceFromLeft(context, GroupDetailsPage(groupId: _oldGroup.id));
              });

            }
          }
        )
    );
  }

}
