import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:relatasapp/opportunity/basic.dart';
import 'package:relatasapp/utils.dart';

// Create a Form widget.
class OppForm extends StatefulWidget {
  const OppForm({Key? key}) : super(key: key);

  @override
  OppFormState createState() {
    return OppFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class OppFormState extends State<OppForm> {

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                // Tab(text: 'Insights'),
                Tab(text: 'Details'),
                // Tab(text: 'Notes'),
              ],
            ),
            title: Text('DEALS',
              style: TextStyle(
                  color: parseColor("#c5d5e4"),
                  fontSize: 32,
                  fontWeight: FontWeight.w300),
            ), backgroundColor: parseColor("#6b869e")
          ),
          body: TabBarView(
            children: [
              // Text('Coming soon...',
              //   style: TextStyle(
              //       color: parseColor("#333"),
              //       fontSize: 32,
              //       fontWeight: FontWeight.w300)),
              new ComplexSample(),
              // Text('Coming soon...',
              //     style: TextStyle(
              //         color: parseColor("#333"),
              //         fontSize: 32,
              //         fontWeight: FontWeight.w300)),
            ],
          ),
        ),
      )
    );
  }
}
