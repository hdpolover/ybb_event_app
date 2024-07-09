import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestPage extends GetResponsiveView {
  final TextEditingController nameController = TextEditingController();

  String? resu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Test Page"),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // add form here for name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),
              // add butto
              ElevatedButton(
                onPressed: () {
                  // add function here

                  resu = nameController.text;

                  print(nameController.text);
                },
                child: const Text("Submit"),
              ),

              Center(
                child: Text(resu != null ? resu! : "Test Page"),
              ),
            ],
          ),
        ));
  }
}
