import 'package:flutter/material.dart';
import 'package:turbo/core/helpers/constants.dart';
import 'package:turbo/core/widgets/custom_header.dart';

class UplaodFilesScreen extends StatelessWidget {
  const UplaodFilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: AppConstants.screenWidth(context),
          height: AppConstants.screenHeight(context),
          child: ListView(
            children: [
              DefaultHeader(header: "Uplaod Files", onBackPressed: () => Navigator.of(context).pop(),)
            ],
          ),
        ) 
      ),
    );
  }
}