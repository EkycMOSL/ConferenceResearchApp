import 'dart:io';
import 'package:conferance_application/config/constant/assetspath.dart';
import 'package:conferance_application/config/constant/colorsutils.dart';
import 'package:conferance_application/config/constant/dimensions.dart';
import 'package:conferance_application/config/constant/fontsize.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


bool isDarkMode=false;

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Widget labelText({required String data,required double fontSize, Color? textColor,FontWeight? weight,TextAlign? textAlign }){
  return Text(data,
      style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: weight ?? FontWeight.w400,
          color: textColor),
      textAlign: textAlign?? TextAlign.start,
      textScaler: const TextScaler.linear(1.0));
}


Widget textInter(String title, BuildContext context, Color color,double fontsize,[TextAlign? textAlign]) {
  return Text(title,
      textAlign: textAlign ?? TextAlign.start,
      style: GoogleFonts.inter(
          fontSize: fontsize,
          fontWeight: FontWeight.w400,
          color: color),
      textScaler: const TextScaler.linear(1.0)
    // : Theme.of(context).textTheme.subtitle1!,
  );
}

Widget buttonText(String title, Color color,[double? fontSize]) {
  return Text(title,
    style: GoogleFonts.inter(
        fontSize: fontSize ,
        fontWeight: FontWeight.w500,
        color: color),
    textScaler: const TextScaler.linear(1),
  );
}

Widget textInterBold(String title, BuildContext context, Color color,double fontsize,[GlobalKey? strkey,TextAlign? objTextAlign]) {
  return Text(title,
      key: strkey ?? null,
      textAlign: objTextAlign??null,
      style: GoogleFonts.inter(
          fontSize: fontsize,
          fontWeight: FontWeight.w600,
          color: color),
      textScaler: const TextScaler.linear(1.0)
    // : Theme.of(context).textTheme.subtitle1!,
  );
}

Widget gradientContainer({Widget? child}){
   return Container(
     width: double.maxFinite,
     height: double.maxFinite,
     decoration: const BoxDecoration(
       gradient: LinearGradient(
         begin: Alignment.topCenter,
         end: Alignment.bottomCenter,
         colors: [colorwhite,colorwhite, colorwhite],
       ),
     ),
     child: child,
  );
}



showUiSnackBak(BuildContext context,SnackBar snackBar){
  return ScaffoldMessenger.of(context)
      .showSnackBar(snackBar);
}

SnackBar messageSnackBar(String message,bool isErrorType){
  return SnackBar(
    content: labelText(data: message, fontSize: size14,weight: FontWeight.w500,textColor: colorwhite),
    backgroundColor: isErrorType ? Colors.red: Colors.green,
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    margin: getMarginOrPadding(all: size5),
    duration: const Duration(seconds: 2),
  );
}

/*
appBarwithBack(BuildContext context,AnimationController? controller,{required String pageName,required String currentPageName}){
  return AppBar(
    flexibleSpace: Container(
      decoration:const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colorGradientOne,colorGradientOne, colorGradientOne],
        )
      ),
    ),
    titleSpacing: 0,
    leading:  IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: colorblack),
      onPressed: () {
            if(currentPageName==PageName.otpEmail ||currentPageName==PageName.bank || currentPageName == PageName.livePhoto
                || currentPageName==PageName.signature || currentPageName==PageName.personal|| currentPageName == PageName.pan
                || currentPageName==PageName.usEquityPersonal)
              {
                fnShowExitPopUp(context, controller);
              }
            else if(currentPageName==PageName.pan)
              {
                AppNavigation().navigateToPage(pageName:pageName , context: context,isNavigationBack: true,isFromPan: true);
              }
            else
              {
                AppNavigation().navigateToPage(pageName:pageName , context: context,isNavigationBack: true);
              }
          }
      ,
    ),
    titleTextStyle: const TextStyle(
      color: colorblue,
      fontSize: 18.0,
    ),
    title: SvgPicture.asset(
      AssetsPath.riselogo,
      width: 50,
      height: 32,
    ),
    centerTitle: false,
    elevation: 0,
  );
}
  */
appBarwithNoBack(BuildContext context,AnimationController? controller){
  return AppBar(
    flexibleSpace: Container(
      decoration:const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorGradientOne,colorGradientOne, colorGradientOne],
          )
      ),
    ),
    automaticallyImplyLeading: false,
    titleSpacing: 15,
    titleTextStyle: const TextStyle(
      color: colorblue,
      fontSize: 18.0,
    ),
    title: labelText(data: "RM", fontSize: FontSize.fontSize14),
    centerTitle: false,
    elevation: 0,
  );
}



/*
locationPopup(BuildContext context,bool isGpsOff){
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(size20))),
          contentPadding: const EdgeInsets.only(top: 0),
          content: Wrap(
              children: [Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(size20)),
                ),
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(isGpsOff ? AssetsPath.location : AssetsPath.locationPermission,width:200,height: 220,fit:BoxFit.cover),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: labelText(data: isGpsOff ? turnOnLocation : turnOnPermission, fontSize: size18,textColor: colortextblack)
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(top :8.0,left:10,right:10,bottom:size10),
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),backgroundColor: colorblue),
                        onPressed: () async {
                          Navigator.of(context, rootNavigator: true).pop();
                          isGpsOff ? Geolocator.openLocationSettings() : Geolocator.openAppSettings();
                        },
                        child: labelText(data: allow, fontSize: size16,textColor: colorwhite),
                      ),
                    ),
                  ],
                ),
              ),]

          ),
        );
      });
}

fnShowExitPopUp(BuildContext context,AnimationController? controller)
{

  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      transitionAnimationController: controller,
      builder: (builder) {
        return  SafeArea( /// prevents navigation bar overlap
            bottom: false,
            child: BlocProvider(create: (context) =>
            ExitPopUpCubit(),
          child:  ExitPopUpScreen(),
        ));
      });
}
*/


hideKeyBoard() {
  FocusManager.instance.primaryFocus?.unfocus();
}


/*
Widget textWithAstrik (String title,Color color,[GlobalKey? strkey]){
  return RichText(
    key: strkey ?? null,
    text: TextSpan(
      children: [
        TextSpan(
            text:title,
            style: GoogleFonts.inter(
                fontSize:
                FontSize.fontSize14,
                fontWeight:
                FontWeight.w700,
                color: color)),
        TextSpan(
          text:
          ' *',
          style:GoogleFonts.inter(
              fontSize:
              FontSize.fontSize14,
              fontWeight:
              FontWeight.w700,
              color: colorRed),
        ),
      ],
    ),
  );
}

Widget hyperLinkText(
    String title, String linkTitle, Color color, String linkUrl) {
  return Text.rich(
      TextSpan(
          text: title,
          style: GoogleFonts.inter(
              fontSize: FontSize.fontSize12,
              fontWeight: FontWeight.w400,
              color: color),
          children: <TextSpan>[
            TextSpan(
              text: linkTitle,
              style: GoogleFonts.inter(
                  fontSize: FontSize.fontSize12,
                  fontWeight: FontWeight.w400,
                  color: colorblue,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  var url = Uri.parse(linkUrl);
                  if (Platform.isAndroid) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    await launchUrl((url), mode: LaunchMode.platformDefault);
                  }
                },
            )
          ]),
      textScaler: const TextScaler.linear(1.0));
}*/
