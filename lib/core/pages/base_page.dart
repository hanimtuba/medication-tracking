import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BasePage<T extends ChangeNotifier> extends StatefulWidget {
  const BasePage({super.key});
}

abstract class BasePageState<T extends ChangeNotifier, P extends BasePage<T>>
    extends State<P> {
  T get provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onPageReady();
    });
  }

  void onPageReady() {}

  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: provider,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: buildBody(context),
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );
  }

  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  Widget? buildFloatingActionButton(BuildContext context) => null;
}

