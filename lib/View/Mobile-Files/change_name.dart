import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopee_app/Constants/constants.dart';
import 'package:shopee_app/Controller/profile_screen_controller.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  State<ChangeName> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  final profileInjector = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _nameRegex = RegExp(
    r'^[a-zA-Z]+$',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ConstantText(
                    'New Name',
                    17,
                    FontWeight.bold,
                    blueColor,
                  ),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == '') {
                        return 'Please enter your name';
                      }
                      if (!_nameRegex.hasMatch(value.toString())) {
                        return 'Incorrect name format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          profileInjector.updateName(_nameController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const BeveledRectangleBorder(),
                        backgroundColor: blueColor,
                      ),
                      child: const ConstantText(
                        'Save',
                        20,
                        FontWeight.bold,
                        Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
