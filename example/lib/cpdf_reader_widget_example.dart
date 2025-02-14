// Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/configuration/cpdf_configuration.dart';
import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget.dart';
import 'package:compdfkit_flutter/widgets/cpdf_reader_widget_controller.dart';
import 'package:flutter/material.dart';

class CPDFReaderWidgetExample extends StatefulWidget {
  final String documentPath;

  const CPDFReaderWidgetExample({super.key, required this.documentPath});

  @override
  State<CPDFReaderWidgetExample> createState() =>
      _CPDFReaderWidgetExampleState();
}

class _CPDFReaderWidgetExampleState extends State<CPDFReaderWidgetExample> {
  late CPDFReaderWidgetController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('CPDFReaderWidget Example'),
          leading: IconButton(
            onPressed: () {
              _save();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.announcement),
              onPressed: () async {
                final document = _controller.document;
                final annotationsFile = await document.exportAnnotations();
                final annotations = await File(annotationsFile).readAsString();
                debugPrint('Annotations: $annotations');
              },
            ),
          ],
        ),
        body: CPDFReaderWidget(
          document: widget.documentPath,
          configuration: CPDFConfiguration(
            toolbarConfig: const CPDFToolbarConfig(
              iosLeftBarAvailableActions: [CPDFToolbarAction.thumbnail],
            ),
            annotationsConfig: const CPDFAnnotationsConfig(
              annotationAuthor: "user123",
            ),
          ),
          onCreated: (controller) {
            setState(() {
              _controller = controller;
            });
          },
        ));
  }

  void _save() async {
    bool saveResult = await _controller.save();
    debugPrint('ComPDFKit-Flutter: saveResult:$saveResult');
  }
}
