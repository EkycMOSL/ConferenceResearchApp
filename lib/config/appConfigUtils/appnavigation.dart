import 'package:conferance_application/config/appConfigUtils/pagenameconstant.dart';
import 'package:conferance_application/widgets/screennavigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppNavigation {
  navigateToPage({required String pageName,
    required BuildContext context,
    bool? isNavigationBack, String? viewImageRequestType, Function(bool isCalled)? viewImageDeleteCallBack,
    String? currentPageName, String? docName, String? userID,String? strMobileNumber,bool? isFromPan,String?
    strEmailAddress,String? strUniqId, bool? isFromOneMoney, bool? oneMoneyStatus,String?
    strClientCode,String? strAmount,Map? params, Map<String, dynamic>? strTokenData,String? strPostParameter,bool? isExistingUser,String? userName}) {
   /* Widget page = _navigateToMobileOtp(
      strMobileNumber: strMobileNumber ??"",strEmailAddress:  strEmailAddress??"",
      strUniqId: strUniqId??"",isExistingUser: isExistingUser??false,userName: userName);
*/
    switch (pageName) {
      case PageName.registrtionpage:
      //page=_navigateToRegistration(strMobileNumber ??"",userName: userName);
      break;
      default:
        //page=_navigateToRegistration(strMobileNumber ??"",userName: userName);
        break;
    }

 /*   ScreenNavigator(cx: context).navigate(
        page,
        isNavigationBack ?? false  ? NavigatorTween.leftToRight()
            : NavigatorTween.rightToLeft());*/
  }



/*  Widget _navigateToRegistration(String strMobileNumber,{String? userName}){
    return BlocProvider(
        create: (_)=> RegistrationCubit(locator<RegistrationApiRepo>()),
      child: RegistrationScreen(phoneNumber: strMobileNumber,userName: userName,),
    );
  }*/


}