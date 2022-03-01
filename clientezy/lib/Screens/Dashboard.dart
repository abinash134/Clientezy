import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../MOdels/dashBoardModel.dart';
import 'Dashboardpages/addAclient.dart';
import 'Dashboardpages/nearbyclients.dart';
import 'Dashboardpages/viewClients.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<DashboardModel> DashboardModelItems = DashboardModel.DashboardModelItems;
  ContainerTransitionType _containerTransitionType =
      ContainerTransitionType.fade;
  List<Widget> pageslist = [AddClient(),NearbyClients(),ViewClient()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("ClientEzy"),
      ),
      body: Stack(
        children: [
          Image.asset(
            "Assets/background.png",
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemCount: DashboardModelItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return OpenContainer(
                    transitionType: _containerTransitionType,
                    transitionDuration: Duration(milliseconds: 500),
                    openBuilder: (context, _) =>pageslist[index],
                    closedElevation: 0,
                    closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                        side: BorderSide(color: Colors.white, width: 1)),
                    closedColor: Colors.amber,
                    closedBuilder: (context, _) => Container(
                      alignment: Alignment.center,
                      //width: width * 0.8,
                      child: Card(
                        color: Colors.amber,
                        child:
                        Center(child: Text(DashboardModelItems[index].name)),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}




