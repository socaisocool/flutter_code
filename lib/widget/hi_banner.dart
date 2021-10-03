import 'package:flutter/material.dart';
import 'package:flutter_code/model/home_mo.dart';
import 'package:flutter_code/utils/view_util.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class HiBanner extends StatelessWidget {
  final List<BannerMo>? bannerList;

  final double bannerHeight;

  final EdgeInsetsGeometry padding;

  final ValueChanged<BannerMo>? bannerItemClick;

  const HiBanner(this.bannerList,
      {Key? key,
      this.bannerHeight = 160,
      this.padding = EdgeInsets.zero,
      this.bannerItemClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: bannerHeight,
      child: _banner(),
    );
  }

  _banner() {
    return Swiper(
      itemCount: bannerList?.length ?? 0,
      autoplay: true,
      pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: DotSwiperPaginationBuilder(
              color: Colors.white60, size: 6, activeSize: 6)),
      itemBuilder: (context, index) {
        return _image(bannerList![index]);
      },
    );
  }

  _image(BannerMo bannerMo) {
    return InkWell(
      onTap: () {
        if (bannerItemClick != null) {
          bannerItemClick!(bannerMo);
        }
      },
      child: Container(
        padding: padding,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: cachedImage(bannerMo.cover),
        ),
      ),
    );
  }
}
