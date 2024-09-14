import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_with_cubit/cubit/pagination_cubit.dart';
import 'package:pagination_with_cubit/cubit/sub_cubit/alert_cubit.dart';
import 'package:pagination_with_cubit/data/models/notification/alert_model.dart';
import 'package:pagination_with_cubit/presentation/pagination_view.dart';

import '../data/models/notification/alert_request_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    setupScrollController(context);
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AlertCubit>(context)
        .loadPosts(AlertRequestModel(pageSize: 20));

    return PaginationView<String, AlertModel, AlertRequestModel, AlertCubit>(
      scrollController: scrollController,
      initialKey: AlertRequestModel(pageSize: 20),
      paginationItemViewBuilder: (value) {
        return _notification(value, context);
      },
      headerBuilder: (message) {
        return SliverAppBar(
          backgroundColor: const Color.fromARGB(255, 192, 0, 0),
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        );
      },
      errorBuider: (message) {
        return Center(
          child: Text(message),
        );
      },
      loadMoreErrorSliverBuider: (message) {
        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ],
        );
      },
      onRefresh: _onRefresh,
    );
  }

  Future<void> _onRefresh() async {
    await BlocProvider.of<AlertCubit>(context).pullToRefresh();
  }

  Widget _notification(AlertModel letter, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            letter.id.toString(),
            style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Text(letter.title.toString()),
          const SizedBox(height: 10.0),
          Text(letter.title.toString()),
        ],
      ),
    );
  }

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<AlertCubit>(context).loadMore();
        }
      }
    });
  }
}
