// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pagination_with_cubit/cubit/pagination_cubit.dart';
// import 'package:pagination_with_cubit/data/models/draft_model.dart';
// import 'package:pagination_with_cubit/data/repositories/draft_repository.dart';
// import 'package:pagination_with_cubit/presentation/pagination_view.dart';

// class DraftView extends StatefulWidget {
//   const DraftView({super.key});

//   @override
//   State<DraftView> createState() => _DraftViewState();
// }

// class _DraftViewState extends State<DraftView> {
//   final scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     setupScrollController(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     BlocProvider.of<
//                 PaginationCubit<String, DraftModel, int, DraftRepository<int>>>(
//             context)
//         .loadPosts();

//     return PaginationView<String, DraftModel, int, DraftRepository<int>>(
//       scrollController: scrollController,
//       initialKey: 0,
//       paginationItemViewBuilder: (value) {
//         return _letter(value, context);
//       },
//       headerBuilder: (message) {
//         return SliverAppBar(
//           backgroundColor: Color.fromARGB(255, 192, 0, 0),
//           pinned: true,
//           flexibleSpace: FlexibleSpaceBar(
//             centerTitle: true,
//             title: Text(
//               message,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16.0,
//               ),
//             ),
//           ),
//         );
//       },
//       errorBuider: (message) {
//         return Center(
//           child: Text(message),
//         );
//       },
//       loadMoreErrorSliverBuider: (message) {
//         return SliverMainAxisGroup(
//           slivers: [
//             SliverToBoxAdapter(
//               child: Center(
//                 child: Text(
//                   message,
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     color: Colors.red,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//       onRefresh: () {
//         _loadPost();
//       },
//     );
//   }

//   Widget _letter(DraftModel letter, BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             letter.subject,
//             style: const TextStyle(
//                 fontSize: 18.0,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10.0),
//           Text(letter.sender),
//           const SizedBox(height: 10.0),
//           Text(DateTime.parse(letter.date).toString()),
//         ],
//       ),
//     );
//   }

//   void setupScrollController(context) {
//     scrollController.addListener(() {
//       if (scrollController.position.atEdge) {
//         if (scrollController.position.pixels != 0) {
//           _loadPost();
//         }
//       }
//     });
//   }

//   _loadPost() {
//     BlocProvider.of<
//                 PaginationCubit<String, DraftModel, int, DraftRepository<int>>>(
//             context)
//         .loadPosts();
//   }
// }
