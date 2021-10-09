import 'dart:async';
import 'package:flutter/material.dart';
import 'package:relatasapp/utils.dart';
import 'package:rxdart/rxdart.dart';

class OppSearchInputSliver extends StatefulWidget {
  const OppSearchInputSliver({
    Key? key,
    this.onChanged,
    this.debounceTime,
  }) : super(key: key);
  final ValueChanged<String>? onChanged;
  final Duration? debounceTime;

  @override
  _OppSearchInputSliverState createState() =>
      _OppSearchInputSliverState();
}

class _OppSearchInputSliverState
    extends State<OppSearchInputSliver> {
  final StreamController<String> _textChangeStreamController =
  StreamController();
  late StreamSubscription _textChangesSubscription;

  @override
  void initState() {
    _textChangesSubscription = _textChangeStreamController.stream
        .debounceTime(
      widget.debounceTime ?? const Duration(seconds: 1),
    )
        .distinct()
        .listen((text) {
      final onChanged = widget.onChanged;
      if (onChanged != null) {
        onChanged(text);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          fillColor: Colors.white,
          filled: true,
          labelText: 'Search for opportunities...',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white, width: 1),
          )
        ),
        onChanged: _textChangeStreamController.add,
      ),
    ),
  );

  @override
  void dispose() {
    _textChangeStreamController.close();
    _textChangesSubscription.cancel();
    super.dispose();
  }
}