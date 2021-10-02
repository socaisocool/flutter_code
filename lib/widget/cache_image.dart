import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
