import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:test_apk/constant.dart';

class Pinch_Zoom extends StatefulWidget {
  final String? img;
  final String? namepic;

  const Pinch_Zoom({Key? key, this.img, this.namepic}) : super(key: key);

  @override
  State<Pinch_Zoom> createState() => _Pinch_ZoomState();
}

class _Pinch_ZoomState extends State<Pinch_Zoom>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  OverlayEntry? entry;

  final double minScale = 1;
  final double maxScale = 4;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        controller.value = animation!.value;
      });
    // ..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     removeOverlay();
    //   }
    // });
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.black,
              leading: backbutton(context, secondColor),
            ),
            body: pinhc_Zoom()));
  }

  // ignore: non_constant_identifier_names
  Widget pinhc_Zoom() {
    return PinchZoom(
      resetDuration: const Duration(milliseconds: 100),
      maxScale: 2.5,
      onZoomStart: () {
        print('Start zooming');
      },
      onZoomEnd: () {
        print('Stop zooming');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 100),
        height: MediaQuery.of(context).size.height * 0.5,
        child: CachedNetworkImage(
          imageUrl: widget.img!,
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          imageBuilder: (context, imageProvider) => Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,

                // colorFilter:
                //     ColorFilter.mode(Colors.red, BlendMode.colorBurn)
              ),
            ),
          ),
          placeholder: (context, url) => const SizedBox.shrink(),
          // Center(
          //     child: CircularProgressIndicator(
          //   color: thirdCOlor,
          // )),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget buildImage() {
    return Builder(builder: (context) {
      return InteractiveViewer(
        clipBehavior: Clip.none,
        panEnabled: false,
        maxScale: maxScale,
        minScale: minScale,
        onInteractionEnd: (details) {
          restAnimation();
        },
        // onInteractionStart: (details) {
        //   if (details.pointerCount < 2) return;
        //   showOverlay(context);
        // },
        child: ClipRRect(
          child: Image.network(
            widget.img!,
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }

  void showOverlay(BuildContext context) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = MediaQuery.of(context).size;
    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
            width: size.width,
            left: offset.dx,
            top: offset.dy,
            child: buildImage());
      },
    );
    final overlay = Overlay.of(context);
    overlay.insert(entry!);
  }

  void restAnimation() {
    animation = Matrix4Tween(begin: controller.value, end: Matrix4.identity())
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInOut));
    animationController.forward(from: 0);
  }

  void removeOverlay() {
    entry?.remove();
    entry = null;
  }
}
