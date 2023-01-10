import 'package:dogly_front/profile/models/challenge.dart';
import 'package:dogly_front/services/services.dart';
import 'package:dogly_front/widgets/simple_dogly_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../profile/models/user.dart';
import '../../profile/models/user_notifier.dart';

class StepCounter extends StatefulWidget {
  const StepCounter({Key? key}) : super(key: key);

  @override
  State<StepCounter> createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  int actualSteps = 0;
  int initialSteps = -1;

  bool isLoading = false;

  void onStepCount(StepCount event) {
    if (mounted) {
      if (initialSteps == -1) {
        WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) => setState(() => initialSteps = event.steps));
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setState(() {
            _steps = event.steps.toString();
            actualSteps = event.steps - initialSteps;
          }));
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) =>
      setState(() => _status = event.status);

  void onPedestrianStatusError(error) =>
      setState(() => _status = 'Pedestrian Status not available');

  void onStepCountError(error) =>
      setState(() => _steps = 'Step Count not available');

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/background.jpg",
              fit: BoxFit.fill,
            )),
        Scaffold(
          appBar: SimpleDoglyAppBar(
            context: context,
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 240,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Steps taken:',
                          style: GoogleFonts.openSans(fontSize: 30),
                        ),
                        Text(
                          actualSteps.toString(),
                          style: GoogleFonts.openSans(fontSize: 30),
                        ),
                        const SizedBox(height: 100),
                        Text(
                          'Pedestrian status:',
                          style: GoogleFonts.openSans(fontSize: 20),
                        ),
                        Center(
                          child: Text(
                            _status,
                            style: _status == 'walking' || _status == 'stopped'
                                ? GoogleFonts.openSans(fontSize: 20)
                                : GoogleFonts.openSans(
                                    fontSize: 20, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 60,
                width: double.infinity,
                child: isLoading
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ))
                    : ElevatedButton(
                        onPressed: () async {
                          String? username = "";
                          var instance = await SharedPreferences.getInstance();
                          username = instance.getString("username");
                          String? email = "";
                          email = instance.getString("email");
                          String? token = "";
                          token = instance.getString("token");
                          User user = User(
                              username: username ?? '',
                              stepCount:
                                  int.tryParse(actualSteps.toString()) ?? 10,
                              email: email,
                              token: token);
                          int? level = await Services.getCurrentLevel(user.username??'');
                          if(level!=null){
                            final challenges = await Services.getChallenges(level);
                            final userBD = await Services.getUser(user.username??'', user.email??'');
                            for(var ch in challenges){
                              if((userBD?.stepCount??0)<ch.value) {
                                if ((userBD?.stepCount ?? 0) + actualSteps >=
                                    ch.value) {
                                  await Services.updatePoints(
                                      user.username ?? '', ch.points);
                                }
                              }
                            }
                          }
                          setState(() => isLoading = true);
                          Services.updateSteps(user).then((value) {
                            if (!value) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Something went wrong"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() => isLoading = false);
                                      },
                                      child: const Text("Okay"),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              Navigator.pop(context);
                              setState(() => isLoading = false);
                            }
                            context.read<UserNotifier>().value = User(
                                firstname:
                                context.read<UserNotifier>().value.firstname,
                                lastname:
                                context.read<UserNotifier>().value.lastname,
                                token: context.read<UserNotifier>().value.token,
                                dogs: context.read<UserNotifier>().value.dogs,
                                username:
                                context.read<UserNotifier>().value.username,
                                email: context.read<UserNotifier>().value.email,
                                stepCount:
                                context.read<UserNotifier>().value.stepCount??0 +
                                    actualSteps);
                          });

                        },
                        child: Text(
                          "End Walk",
                          style: GoogleFonts.openSans(fontSize: 20),
                        ),
                      ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}
