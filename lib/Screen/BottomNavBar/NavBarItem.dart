import 'dart:async';

enum NavBarItem { HOME, LEAF, SOCIALFEED, SHOP, USERS }

class BottomNavBarBloc {
  final StreamController<NavBarItem> _navBarController =
      StreamController<NavBarItem>.broadcast();

  NavBarItem defaultItem = NavBarItem.HOME;

  Stream<NavBarItem> get itemStream => _navBarController.stream;

  void pickItem(int i) {
    print("clicked : $i");
    switch (i) {
      case 0:
        _navBarController.sink.add(NavBarItem.HOME);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.LEAF);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.SOCIALFEED);
        break;
      case 3:
        _navBarController.sink.add(NavBarItem.SHOP);
        break;
      case 4:
        _navBarController.sink.add(NavBarItem.USERS);
        break;
    }
  }

  close() {
    _navBarController?.close();
  }
}
final bottomNavBarBloc = BottomNavBarBloc();
