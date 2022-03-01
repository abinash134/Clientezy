class DashboardModel {
  late String name;
  late String path;

  DashboardModel({required this.name, required this.path});

  static List<DashboardModel> DashboardModelItems = [
    DashboardModel(name: "Add a Client", path: "/addclient"),
    DashboardModel(name: "View nearby Client", path: "/nearclints"),
    DashboardModel(name: "View All Clients", path: "/viewclient"),
  ];
}
