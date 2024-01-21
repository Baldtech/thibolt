import 'package:thibolt/common_libs.dart';

class BaseCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final SvgPicture icon;
  final Widget? trailing;

  const BaseCard(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.icon,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(45),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.2),
            blurRadius: 1.0,
            spreadRadius: 1.0,
            offset: const Offset(
              1.0,
              1.0,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          _left(context),
          const Expanded(child: SizedBox()),
          if (trailing != null)
            Container(
              padding: const EdgeInsets.only(right: 25),
              child: trailing!,
            ),
        ],
      ),
    );
  }

  Widget _left(BuildContext context) {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.all(15),
        child: icon,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            title,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 7),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ]);
  }
}
