import 'package:dogly_front/profile/models/challenge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';
import '../models/user.dart';
import '../models/user_notifier.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int level = -1;

  Future<User> getUser() async {
    return await Services.getUser(
            context.read<UserNotifier>().value.username ?? '',
            context.read<UserNotifier>().value.email ?? '') ??
        User();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        User user = User();
        if (snapshot.hasData) {
          user = snapshot.data as User;
        }
        return snapshot.hasData
            ? Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "assets/background.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    body: FutureBuilder(
                      future: Services.getCurrentLevel(user.username ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          level = snapshot.data as int;
                        }
                        return snapshot.hasData
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image:
                                                            Services.checkImg(
                                                                userPic: user
                                                                    .picture),
                                                        fit: BoxFit.cover),
                                                    shape: BoxShape.circle),
                                                margin: const EdgeInsets.only(
                                                    right: 20),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(user.username ?? '',
                                                      style:
                                                          GoogleFonts.openSans(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  if (level != -1)
                                                    Text('Level $level',
                                                        style: GoogleFonts
                                                            .openSans(
                                                                fontSize: 16))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text('Level $level',
                                        style: GoogleFonts.openSans(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(height: 15),
                                  FutureBuilder(
                                    future: Services.getChallenges(level),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<Challenge> challenges =
                                            (snapshot.data as List<Challenge>)
                                                .where((element) =>
                                                    element.type ==
                                                    ChallengeType.STEP)
                                                .toList();
                                        List<Challenge> activeChallenges =
                                            challenges
                                                .where((element) =>
                                                    element.value >
                                                    (user.stepCount ?? 0))
                                                .toList();
                                        if (activeChallenges.isNotEmpty) {
                                          return Expanded(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: ListView.separated(
                                                itemBuilder: (_, index) =>
                                                    Container(
                                                  height: 80,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          activeChallenges[
                                                                  index]
                                                              .name,
                                                          style: GoogleFonts
                                                              .openSans(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                      if (activeChallenges[
                                                                  index]
                                                              .value !=
                                                          -1)
                                                        Flexible(
                                                          flex: 2,
                                                          child: RichText(
                                                            text: TextSpan(
                                                              text: (user.stepCount ??
                                                                      0)
                                                                  .toString(),
                                                              style: GoogleFonts.openSans(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .blue),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '/${activeChallenges[index].value}',
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                ),
                                                itemCount:
                                                    activeChallenges.length,
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(height: 15),
                                              ),
                                            ),
                                          );
                                        } else {
                                          Services.getCurrentLevel(
                                                  user.username ?? '')
                                              .then((value) {
                                            if (mounted) {
                                              setState(
                                                  () => level = value ?? -1);
                                            }
                                          });
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  )
                                ],
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
