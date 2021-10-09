import 'package:relatasapp/utils.dart';
import 'opp_summary.dart';
import 'opp_list_item.dart';
import 'opp_search_input_sliver.dart';
import 'opp_api.dart';
import 'stages_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class OppSliverList extends StatefulWidget {
  @override
  _OppSliverListState createState() => _OppSliverListState();
}

class _OppSliverListState extends State<OppSliverList> {
  static const _pageSize = 10;

  final PagingController<int, OpportunitySummary> _pagingController =
  PagingController(firstPageKey: 1);

  String? _searchTerm;
  List<OpportunityStage> stages = <OpportunityStage>[];

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey,null);
    });

    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });

    super.initState();
  }

  Future<void> _fetchPage(pageKey,String? stageName) async {
    try {

      final resultOpp = await RemoteOppApi.getData(
          pageKey,
          _pageSize,
          searchTerm: _searchTerm
      );

      var newItems = <OpportunitySummary>[];
      if(resultOpp.opps != null){
        newItems = resultOpp.opps!;
      }

      setState(() {
        if(resultOpp.stages != null){
          stages = resultOpp.stages!;
          for(final e in stages){
            e.selected = false;
          }
        }
      });

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {

    Icon customIcon = const Icon(Icons.search);
    Widget customSearchBar = Text('DEALS',
      style: TextStyle(
          color: parseColor("#c5d5e4"),
          fontSize: 32,
          fontWeight: FontWeight.w300
      ),
    );

    return RefreshIndicator(
        onRefresh: () =>
            Future.sync(
                  () => _pagingController.refresh(),
            ),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: parseColor("#6b869e"),
              title: customSearchBar,
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (customIcon.icon == Icons.search) {
                        customIcon = const Icon(Icons.cancel);
                        customSearchBar = const ListTile(
                          leading: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 28,
                          ),
                          title: TextField(
                            decoration: InputDecoration(
                              hintText: 'type in journal name...',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        customIcon = const Icon(Icons.search);
                        customSearchBar = const Text('My Personal Journal');
                      }
                    });
                  },
                  icon: customIcon,
                )
              ],
            ),
            body: Container(
                decoration: new BoxDecoration(
                    color: parseColor('#f7f7f7')
                  // color: Colors.greenAccent
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    // OppSearchInputSliver(
                    //   onChanged: (searchTerm) => _updateSearchTerm(searchTerm),
                    // ),
                  SliverToBoxAdapter(
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: DropDownButtonBox('John Doe', [
                          'John Doe',
                          'Naveen Paul',
                          'Kabir Khan',
                          'Samantha Jones',
                          'Jonny Walker',
                          'Sumit Rampal',
                          'Justein Kemp',
                          'Kempa Raju',
                        ]),
                      )
                    ),
                    new StageList(stagesList: this.stages),
                    // OppSearchInputSliver(
                    //   onChanged: (searchTerm) => _updateSearchTerm(searchTerm),
                    // ),
                    PagedSliverList<int, OpportunitySummary>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<
                          OpportunitySummary>(
                        animateTransitions: true,
                        itemBuilder: (context, item, index) =>
                            OppListItem(
                              character: item,
                            ),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }

  void _updateSearchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}