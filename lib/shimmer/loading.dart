import 'package:flutter/material.dart';
import 'package:pagination_with_cubit/shimmer/shimmer.dart';

class Loading extends StatelessWidget {
  final int count;
  final showShimmer;
  const Loading({
    super.key,
    this.count = 15,
    this.showShimmer = false,
  });

  @override
  Widget build(BuildContext context) {
    return showShimmer
        ? SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildShimer(),
              ),
            ),
          )
        : _loadingIndicator();
  }

  List<Widget> _buildShimer() {
    List<Widget> shimmers = [];
    for (var i = 0; i < count; i++) {
      shimmers.add(
        Container(
          child: SizedBox(
            width: double.infinity,
            height: 100.0,
            child: Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.black,
              child: const Row(
                children: [
                  CircleAvatar(),
                  Text(
                    'Shimmer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return shimmers;
  }

  Widget _loadingIndicator() {
    return const Center(
        child: Padding(
      padding: EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    ));
  }
}
