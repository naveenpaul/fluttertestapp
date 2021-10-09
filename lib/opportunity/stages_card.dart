import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:relatasapp/opportunity/opp_sliver_list.dart';
import 'opp_summary.dart';

class StageList extends StatelessWidget {

  List<OpportunityStage>? stagesList;
  StageList({required this.stagesList});
  String selected = '';

  @override
  Widget build(BuildContext context) {

    return SliverToBoxAdapter(
        child:
        Container(
            margin: const EdgeInsets.only(left: 15.0, right: 18.0,top:10.0,bottom: 15.0),
            height: 115.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stagesList!.length,
                itemBuilder: (BuildContext context, int i) {
                  final stage = stagesList![i];
                  stage.selected = false;

                  return Card(
                      shape: stage.name == 'Pre-Sales'?RoundedRectangleBorder(
                        side: new BorderSide(color: Colors.lightBlue, width: 1.0),
                        borderRadius: BorderRadius.circular(10)):RoundedRectangleBorder(
                      side: new BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                      ),
                      child:new InkWell(
                        onTap: () {
                          for(final e in stagesList!){
                            e.selected = false;
                          };

                          stage.selected = true;
                          // this.oppSliverList.fetchOpps();
                          print(stage.name);
                          print(stage.selected);
                        },
                        child: Container(
                          width: 200.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                stage.name!.toUpperCase(),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(stage.oppCount!,
                                    style: TextStyle(color: Colors.black38,fontSize: 24, fontWeight: FontWeight.w400),),
                                  Text(stage.amount!,
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                  );
                }
            )
        )
    );
  }
}
