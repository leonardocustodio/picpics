import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:picPics/database/app_database.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/stores/migration_store.dart';
import 'package:picPics/widgets/color_animated_background.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';

/* 
class MigrationScreen extends StatefulWidget {
  static const id = 'migration_screen';

  @override
  _MigrationScreenState createState() => _MigrationScreenState();
}
 */
class MigrationScreen extends GetView<MigrationStore> {
  MigrationScreen({Key key}) : super(key: key);

  void seeDb() {
    final db = AppDatabase(); //This should be a singleton
    /* 
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MoorDbViewer(db))); */
    Get.to(MoorDbViewer(db));
  }

/*   @override
  void initState() {
    super.initState();
    // Analytics.sendCurrentScreen(Screen.login_screen);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
    migrationStore.startMigration();
  }
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: [
            ColorAnimatedBackground(
              moveByX: 30.0,
              moveByY: 20.0,
              blurFilter: false,
            ),
            SafeArea(
              child: Obx(() {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Image.asset('lib/images/picpics_small.png'),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (controller.isMigrating.value) ...[
                                Text(
                                  'Please wait',
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: kWhiteColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.4099999964237213,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 32.0, top: 32.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 6.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    'Nós estamos otimizando o aplicativo para melhorar a performance e possibilitar novas funcionalidades!',
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: kWhiteColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: -0.4099999964237213,
                                    ),
                                  ),
                                ),
                              ],
                              if (controller.isMigrating.value == false) ...[
                                Text(
                                  'Processo concluído!',
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: kWhiteColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.4099999964237213,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    'Pronto o processo foi concluído, você pode continuar usando agora o melhor gerenciador de fotos!',
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      color: kWhiteColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: -0.4099999964237213,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: 64.0),
                        CupertinoButton(
                          onPressed: () async {
                            seeDb();
                          },
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            height: 66.0,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              gradient: kPrimaryGradient,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                'Continuar',
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: kWhiteColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: -0.4099999964237213,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
