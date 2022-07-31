import 'package:get/get.dart';
import 'package:solutions_1313/app/modules/home/views/graph.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const GRAPH = Routes.GRAPH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.GRAPH,
      page: () => const GraphScreen(),
      // binding: HomeBinding(),
    ),
  ];
}
