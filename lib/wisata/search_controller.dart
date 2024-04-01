import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchControllerProvider =
    StateNotifierProvider<SearchUserController, List>((ref) {
  return SearchUserController();
});

class SearchUserController extends StateNotifier<List> {
  SearchUserController() : super([]);

  void onSearchUser(String query, List<dynamic> data) {
    state = [];
    print(query);
    
      final result = data
          .where((element) => element['keterangan']
              .toString()
              .toLowerCase()
              .contains(query.toString().toLowerCase()))
          .toSet()
          .toList();
          // print(result);
      state.addAll(result);
    
  }
  void onTap(String query, List<dynamic> data) {
    state = [];
    // print(query);
    
      final result = data
          .where((element) => element['wilayah']
              .toString()
              .toLowerCase()
              .contains(query.toString().toLowerCase()))
          .toSet()
          .toList();
          // print(result);
      state.addAll(result);
    
  }
}
