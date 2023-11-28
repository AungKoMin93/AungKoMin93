import 'package:flutter/material.dart';

import '../Screens/theme.dart';

class SystemConfig extends StatefulWidget {
  const SystemConfig({Key? key}) : super(key: key);

  @override
  State<SystemConfig> createState() => _SystemConfigState();
}

class _SystemConfigState extends State<SystemConfig> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tables Configuration',
          style: TextStyle(fontSize: headingSize),
        ),
        const SizedBox(
          width: 500,
          child: Column(children: [
            Text('Currency'),
            Text('Theme')
          ]),
        )
      ],
    );
  }
}
