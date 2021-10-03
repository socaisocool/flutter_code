import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//带缓存的image
Widget cachedImage(String url, {double? width, double? height}) {
  return CachedNetworkImage(
    imageUrl: url,
    width: width,
    height: height,
    fit: BoxFit.cover,
    placeholder: (context, url) {
      return Container(
        color: Colors.grey[200],
      );
    },
    errorWidget: (context, url, error) {
      return const Icon(Icons.error);
    },
  );
}

//黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
    colors: const [
      Colors.black54,
      Colors.black45,
      Colors.black38,
      Colors.black26,
      Colors.black12,
      Colors.transparent
    ],
    begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
    end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
  );
}
