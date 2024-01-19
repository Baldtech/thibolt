import 'package:thibolt/common_libs.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const SizedBox(width: 20),
          const Text(
            'Thibolt'
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(
            'assets/icons/app-icon.svg',
            height: 19,
            width: 19,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
