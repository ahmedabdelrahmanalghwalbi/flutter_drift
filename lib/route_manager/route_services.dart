import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MessageType {
  none,
  success,
  error,
  warning,
  info,
  custom,
}

class AppNavigator {
  /// show native dialog
  static Future<dynamic> showAppDialog(
    context,
    Widget Function(BuildContext) creator, {
    DialogAnimationTypes animationType = DialogAnimationTypes.feedIn,
    barrierDismissible = true,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) => const SizedBox.shrink(),
      transitionBuilder: (dialogContext, a1, a2, _) => _dialogAnimated(
        animation: a1,
        type: animationType,
        body: creator(dialogContext),
      ),
    );
  }

  /// show dialog with size
  static Future<T?> showAppDialogEx<T>(context, Widget Function() creator,
      {DialogAnimationTypes animationType = DialogAnimationTypes.feedIn,
      bool barrierDismissible = true,
      String? title,
      DialogBoxSizes size = DialogBoxSizes.medium,
      Axis axisDirection = Axis.vertical,
      bool closeButton = true,
      List<Widget>? actions}) async {
    var boxConstraints = getDialogSize(size, axisDirection, context);
    return await showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) => const SizedBox.shrink(),
      transitionBuilder: (dialogContext, a1, a2, _) => _dialogAnimated(
        animation: a1,
        type: animationType,
        body: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          shape: null,
          child: ConstrainedBox(
            constraints: boxConstraints.copyWith(minHeight: 100, minWidth: 200),
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Card(
                  surfaceTintColor: Colors.white,
                  shadowColor: Colors.white,
                  child: (title ?? '').isEmpty &&
                          !closeButton &&
                          (actions ?? []).length == 0
                      ? creator()
                      : Column(
                          children: [
                            Row(
                              children: [
                                closeButton
                                    ? IconButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        icon: const Icon(Icons.close))
                                    : Container(),
                                Expanded(
                                    child: Text(
                                  title ?? '',
                                  textAlign: TextAlign.center,
                                )),
                                Container(
                                    width: (actions ?? []).length == 0
                                        ? 30.0
                                        : 0.0),
                                ...(actions ?? [])
                              ],
                            ),
                            Expanded(child: creator())
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// return the size required for a dialog
  static BoxConstraints getDialogSize(
      DialogBoxSizes size, Axis axisDirection, context) {
    BoxConstraints? boxConstraints;
    if (axisDirection == Axis.horizontal) {
      switch (size) {
        case DialogBoxSizes.small:
          boxConstraints = const BoxConstraints(maxHeight: 200, maxWidth: 300);
          break;
        case DialogBoxSizes.large:
          boxConstraints = BoxConstraints(
              maxHeight: 700, maxWidth: MediaQuery.of(context).size.width);
          break;
        default:
          boxConstraints = const BoxConstraints(maxHeight: 400, maxWidth: 600);
      }
    } else if (axisDirection == Axis.vertical) {
      switch (size) {
        case DialogBoxSizes.small:
          boxConstraints = const BoxConstraints(maxHeight: 300, maxWidth: 200);
          break;
        case DialogBoxSizes.large:
          boxConstraints = BoxConstraints(
              maxHeight: 600, maxWidth: MediaQuery.of(context).size.width);
          break;
        default:
          boxConstraints = const BoxConstraints(maxHeight: 600, maxWidth: 400);
      }
    }
    debugPrint(
        '$size ------- ${boxConstraints?.maxHeight} , ${boxConstraints?.maxWidth}');
    return boxConstraints!;
  }

  /// bind the widget in a dialog
  static Widget dialogLayout(
      {required Widget body,
      required BuildContext context,
      String? title,
      DialogBoxSizes size = DialogBoxSizes.medium,
      Axis axisDirection = Axis.vertical,
      bool closeButton = true,
      List<Widget>? actions}) {
    var boxConstraints = getDialogSize(size, axisDirection, context);
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Card(
          child: Container(
              constraints:
                  boxConstraints.copyWith(minHeight: 100, minWidth: 200),
              child: (title ?? '').isEmpty &&
                      !closeButton &&
                      (actions ?? []).length == 0
                  ? body
                  : Column(
                      children: [
                        Row(
                          children: [
                            closeButton
                                ? IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close))
                                : Container(),
                            Expanded(
                                child: Text(
                              title ?? '',
                              textAlign: TextAlign.center,
                            )),
                            Container(
                                width:
                                    (actions ?? []).length == 0 ? 30.0 : 0.0),
                            ...(actions ?? [])
                          ],
                        ),
                        Expanded(child: body)
                      ],
                    )),
        ),
      ),
    );
  }

  /// navigate
  static Future<dynamic> navigateToNamed(BuildContext context, String url,
      {bool replacment = false,
      bool replaceAll = false,
      AnimationTypes animationType = AnimationTypes.opacity}) {
    try {
      if (kIsWeb) animationType = AnimationTypes.none;
    } catch (err) {}
    // PageRoute route;
    // if (Theme.of(context).platform == TargetPlatform.iOS &&
    //     animationType != AnimationTypes.none &&
    //     animationType != AnimationTypes.opacity)
    //   route = CupertinoPageRoute(builder: (_) => creator());
    // else if (animationType == AnimationTypes.none)
    //   route = PageRouteBuilder(pageBuilder: (_, __, ___) => creator());
    // else
    //   route = PageRouteBuilder(
    //       pageBuilder: (_, __, ___) => creator(),
    //       transitionDuration: Duration(
    //           milliseconds:
    //               animationType == AnimationTypes.opacity ? 400 : 300), //300
    //       transitionsBuilder: getAnimation(animationType));

    if (replaceAll) {
      // remove all pages in navigation history
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      replacment = true;
      //return Navigator.of(context).pushAndRemoveUntil(route,(Route<dynamic> route) => route.isFirst);
    }

    if (replacment) {
      return Navigator.of(context).pushReplacementNamed(url);
    } else {
      return Navigator.of(context).pushNamed(url);
    }
  }

  /// navigate
  static Future<dynamic> navigateTo(
      BuildContext context, Widget Function() creator,
      {bool replacment = false,
      bool replaceAll = false,
      AnimationTypes animationType = AnimationTypes.opacity}) {
    if (kIsWeb) {
      animationType = AnimationTypes.none;
    }

    PageRoute route;
    if (Theme.of(context).platform == TargetPlatform.iOS &&
        animationType != AnimationTypes.none &&
        animationType != AnimationTypes.opacity) {
      route = CupertinoPageRoute(builder: (_) => creator());
    } else if (animationType == AnimationTypes.none) {
      route = PageRouteBuilder(pageBuilder: (_, __, ___) => creator());
    } else {
      route = PageRouteBuilder(
          pageBuilder: (_, __, ___) => creator(),
          transitionDuration: Duration(
              milliseconds:
                  animationType == AnimationTypes.opacity ? 400 : 300), //300
          transitionsBuilder: _getAnimation(animationType));
    }

    if (replaceAll) {
      // remove all pages in navigation history
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      replacment = true;
      //return Navigator.of(context).pushAndRemoveUntil(route,(Route<dynamic> route) => route.isFirst);
    }

    if (replacment) {
      return Navigator.of(context).pushReplacement(route);
    } else {
      return Navigator.of(context).push(route);
    }
  }

  static Widget _animationSlideLeft(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Widget _animationSlideRight(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
          .animate(animation),
      child: child,
    );
  }

  static Widget _animationSlideUp(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
          .animate(animation),
      child: child,
    );
  }

  static Widget _animationOpacity(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Opacity(
      opacity: animation.value,
      child: child,
    );
  }

  static Widget Function(
          BuildContext, Animation<double>, Animation<double>, Widget)
      _getAnimation(AnimationTypes type) {
    switch (type) {
      // case AnimationTypes.none:
      //   return null;
      case AnimationTypes.opacity:
        return _animationOpacity;
      case AnimationTypes.slideLeft:
        return _animationSlideLeft;
      case AnimationTypes.slideRight:
        return _animationSlideRight;
      case AnimationTypes.slideUp:
        return _animationSlideUp;
      default:
        return _animationOpacity;
    }
  }

  static Widget _dialogAnimated(
      {required Widget body,
      required DialogAnimationTypes type,
      required Animation<double> animation}) {
    switch (type) {
      case DialogAnimationTypes.feedIn:
        return Column(children: <Widget>[
          Spacer(flex: (animation.value * 100).toInt() + 1),
          Opacity(
              opacity: animation.value,
              child: Transform.scale(scale: animation.value, child: body)),
          const Spacer(flex: 100),
        ]);
      case DialogAnimationTypes.opacity:
        return Column(children: <Widget>[
          const Spacer(),
          Opacity(opacity: animation.value, child: body),
          const Spacer(),
        ]);
      case DialogAnimationTypes.open:
        return Column(children: <Widget>[
          const Spacer(),
          Opacity(
            opacity: animation.value,
            child: SizeTransition(
              axisAlignment: 0.0,
              sizeFactor: animation,
              child: body,
            ),
          ),
          const Spacer(),
        ]);
      default:
        return SizedBox(child: body);
    }
  }

  // show message in a dialog
  static Future<dynamic> showMessage(
    BuildContext context,
    String title,
    MessageType type, {
    String? message,
    String? imageAssert,
    String? exceptionText,
    DialogAnimationTypes animationType = DialogAnimationTypes.feedIn,
  }) async {
    bool isShowException = false;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) => const SizedBox.shrink(),
      transitionBuilder: (dialogContext, a1, a2, _) => _dialogAnimated(
        animation: a1,
        type: animationType,
        body: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: SizedBox(
            width: min(MediaQuery.of(context).size.width - 50, 700.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30.0),
                _getMessageImageWidget(type),
                const SizedBox(height: 5.0),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      title,
                      maxLines: 4,
                      style:
                          const TextStyle(fontSize: 23.0, color: Colors.black),
                      textAlign: TextAlign.center,
                    )),
                message != null ? const SizedBox(height: 20.0) : Container(),
                message != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(message,
                            style: const TextStyle(
                                fontSize: 18.0, color: Colors.black45),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            maxLines: 10))
                    : Container(),
                // if (exceptionText != null)
                //    ExpansionTile(
                //         title:expansionTitle != null ? Text
                //           (expansionTitle):Text(ConfigService.isRTL? 'تفاصيل الخطأ' :'Err'
                //         'or Description'),
                //         initiallyExpanded: false,
                //         children: [
                //           Padding(
                //               padding: EdgeInsets.all(20),
                //               child: Text(exceptionText)),
                // //         ]),
                if (exceptionText != null)
                  StatefulBuilder(
                    builder: (context, setState) => Column(
                      children: [
                        TextButton(
                            child: Text(!isShowException ? 'See More' : 'Hide',
                                style: const TextStyle(color: Colors.grey)),
                            onPressed: () {
                              isShowException = !isShowException;
                              setState(() {
                                debugPrint(isShowException.toString());
                              });
                            }),
                        if (isShowException)
                          SingleChildScrollView(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.height / 2,
                              child: Center(
                                child: SelectableText(exceptionText,
                                    textDirection: TextDirection.ltr),
                              ),
                            ),
                          ),
                        if (!isShowException) const SizedBox(height: 40.0),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                ButtonTheme(
                    minWidth: 120.0,
                    height: MediaQuery.of(context).size.height / 10,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      color: Colors.white,
                      onPressed: () =>
                          Navigator.of(dialogContext, rootNavigator: true)
                              .pop(),
                      child: Text('OK',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    )),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static _getMessageImageWidget(MessageType type) {
    switch (type) {
      case MessageType.none:
        return Container();
      case MessageType.warning:
        return const Icon(Icons.error_outline,
            size: 90.0, color: Colors.yellow);
      case MessageType.success:
        return const Icon(Icons.done, size: 90.0, color: Colors.green);
      case MessageType.error:
        return const Icon(Icons.cancel, size: 90.0, color: Colors.red);
      case MessageType.info:
        return const Icon(Icons.announcement, size: 90.0, color: Colors.black);
      default:
        return const Icon(Icons.announcement, size: 90.0, color: Colors.black);
      //return Image.asset('assets/images/logo.png', width:150.0, height: 90.0) ;
    }
  }

  static bool isMobilePlatform() {
    if (Platform.isAndroid || Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  /// show confirm message with a dialog
  static Future<bool> confirmMessage(BuildContext context, String title,
      {String? message,
      String? imageAssert,
      DialogAnimationTypes animationType = DialogAnimationTypes.feedIn,
      Widget? icon,
      bool? isArabic}) async {
    var result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      // barrierColor: Colors.transparent,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) => const SizedBox.shrink(),
      transitionBuilder: (dialogContext, a1, a2, _) => _dialogAnimated(
        animation: a1,
        type: animationType,
        body: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.white,
          child: SizedBox(
              width: isMobilePlatform() ? 320.0 : 600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  imageAssert != null
                      ? Image.asset(imageAssert, width: 150.0, height: 90.0)
                      : icon != null
                          ? SizedBox(
                              width: 150.0,
                              height: 90.0,
                              child: icon,
                            )
                          : const SizedBox(),
                  const SizedBox(height: 25.0),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 25.0, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  message != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(message,
                              style: const TextStyle(
                                  fontSize: 18.0, color: Colors.black45),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              maxLines: 4))
                      : const SizedBox(),
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ButtonTheme(
                          minWidth: 100.0,
                          height: 60.0,
                          child: MaterialButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: Text(isArabic! ? 'نعم' : 'Yes',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color)),
                          )),
                      const SizedBox(width: 15.0),
                      ButtonTheme(
                          minWidth: 100.0,
                          height: 60.0,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            color: Colors.white,
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: Text(isArabic ? 'لا' : 'No',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ))
                    ],
                  ),
                  const SizedBox(height: 50.0),
                ],
              )),
        ),
      ),
    );

    return result ?? false;
  }

  /// perform a haptic feedback
  static Future<void> hapticFeedback({bool heavy = true}) async {
    await SystemChannels.platform.invokeMethod(
      'HapticFeedback.vibrate',
      heavy
          ? 'HapticFeedbackType.heavyImpact'
          : 'HapticFeedbackType.selectionClick',
    );
  }

  /// pop the widget
  static void pop(BuildContext context, [result]) {
    Navigator.pop(context, result);
  }

  static bool isLoading = false;
  static BuildContext? loadingContext;

  static Widget getLoadingWidget(BuildContext context, [double size = 100]) {
    return CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor));
  }

  /// show loading in a dialog
  static Future<void> showLoading(BuildContext context,
      [String title = '']) async {
    var loadingWidget = Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        shape: null,
        child: SizedBox(
            width: 200.0,
            height: 150.0,
            child: //Text('Loading')
                Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)),
                  const SizedBox(width: 10),
                  Text(title.isEmpty ? 'Loading ...' : '$title, please wait')
                ],
              ),
            )));
    isLoading = true;
    loadingContext = context;
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => loadingWidget);
    isLoading = false;
  }

  static void resume([bool success = true]) async {
    if (isLoading && loadingContext != null) {
      Navigator.of(loadingContext!, rootNavigator: true).pop();
    }
    isLoading = false;
  }
}

/// Animation types
enum AnimationTypes { none, slideLeft, slideRight, slideUp, opacity }

/// dialog box size
enum DialogBoxSizes { small, medium, large }

enum DialogAnimationTypes { none, feedIn, open, opacity }
