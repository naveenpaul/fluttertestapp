import 'package:relatasapp/opportunity/basic.dart';
import 'package:relatasapp/opportunity/opp_api.dart';

import 'create.dart';
import 'opp_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OppListItem extends StatelessWidget {
  const OppListItem({
     this.character,
    Key? key,
  }) : super(key: key);

  final OpportunitySummary? character;

  @override
  Widget build(BuildContext context) => Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(left: 15.0, right: 15.0,top:7.5,bottom:7.5),
      child:new InkWell(
        onTap: () {

          var opportunityId = "";
          opportunityId = character!.opportunityId!;

          // print("character");
          // print(character!.opportunityId);

          SharedPreferences.getInstance().then((prefs) {
            // prefs.setString('oppId', opportunityId);

            // RemoteOppApi.getOppDataById(opportunityId).then((oppData) {
            //   print(oppData);
            // });

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OppForm(),
                ));
          });
        },
          child: Container(
              height: 125,
              margin: const EdgeInsets.all(15.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      character!.opportunityName!,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey),
                    ),
                    Text(
                      character!.amount!,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 36),
                    ),
                    Text(
                      getFormattedDate(character!.closeDate!),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey),
                    )
                  ]
              )
          )
      ),

  );
}
