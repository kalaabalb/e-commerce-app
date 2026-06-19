import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../../utility/responsive_utils.dart';
import '../../../utility/constants.dart';
import '../../../models/product_summery_info.dart';

class ProductSummeryCard extends StatelessWidget {
  const ProductSummeryCard({
    Key? key,
    required this.info,
    required this.onTap,
  }) : super(key: key);

  final ProductSummeryInfo info;
  final Function(String?) onTap;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        onTap(info.title);
      },
      child: Container(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              surfaceColor,
              info.color!.withOpacity(0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: info.color!.withOpacity(0.20),
          ),
          boxShadow: [
            BoxShadow(
              color: info.color!.withOpacity(0.07),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 9 : 11),
                  height: isMobile ? 38 : 44,
                  width: isMobile ? 38 : 44,
                  decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: SvgPicture.asset(
                    info.svgSrc!,
                    colorFilter: ColorFilter.mode(
                        info.color ?? Colors.black, BlendMode.srcIn),
                  ),
                ),
                Icon(Icons.more_vert,
                    color: Colors.white.withOpacity(0.50), size: 18)
              ],
            ),
            const Gap(10),
            Text(
              info.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: isMobile ? 14 : null,
                  ),
            ),
            const Gap(8),
            Text(
              '${info.productsCount} items',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: isMobile ? 22 : null,
                  ),
            ),
            const Gap(10),
            ProgressLine(
              color: info.color,
              percentage: info.percentage,
            ),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isMobile)
                  Text(
                    info.percentage != null
                        ? '${info.percentage!.toStringAsFixed(0)}% of stock'
                        : '',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white70),
                  )
                else
                  Text(
                    info.percentage != null
                        ? '${info.percentage!.toStringAsFixed(0)}%'
                        : '',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                  ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: info.color,
                  size: isMobile ? 16 : 18,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final double? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 4,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.12),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
