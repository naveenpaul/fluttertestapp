import 'opp_summary.dart';
// import 'opp_summary_response.dart';
import 'opp_list_item.dart';
import 'opp_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class OppListView extends StatefulWidget {
  @override
  _OppListViewState createState() => _OppListViewState();
}

class _OppListViewState extends State<OppListView> {
  static const _pageSize = 10;

  final PagingController<int, OpportunitySummary> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await RemoteOppApi.getOppList(pageKey, _pageSize);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        // final nextPageKey = pageKey + newItems.length;
        final nextPageKey = pageKey+1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
    ),
    child: Column(
      children: <Widget>[
        Expanded(
            child:  Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                "opp.opportunityName!",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
            )
        ),
        Expanded(
          child: PagedListView<int, OpportunitySummary>.separated(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<OpportunitySummary>(
              animateTransitions: true,
              itemBuilder: (context, item, index) => OppListItem(
                character: item,
              ),
            ),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ],
    )

    // PagedListView<int, OpportunitySummary>.separated(
    //   pagingController: _pagingController,
    //   builderDelegate: PagedChildBuilderDelegate<OpportunitySummary>(
    //     animateTransitions: true,
    //     itemBuilder: (context, item, index) => OppListItem(
    //       character: item,
    //     ),
    //   ),
    //   separatorBuilder: (context, index) => const Divider(),
    // ),
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
