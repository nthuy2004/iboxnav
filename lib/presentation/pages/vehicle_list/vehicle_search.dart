import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iboxnav/controllers/vehicle/vehicle_controller.dart';
import 'package:iboxnav/models/vehicle_model.dart';
import 'package:iboxnav/presentation/components/contest_tab_header.dart';
import 'package:iboxnav/presentation/components/error_widget.dart';

import 'vehicle_list_item.dart';

Map<String, String> filterMode = {
  "running": "Đang chạy",
  "parking": "Đang đỗ",
  "stopped": "Đang dừng"
};

class VehicleSearchPage extends StatefulWidget {
  const VehicleSearchPage({super.key});

  @override
  State<VehicleSearchPage> createState() => _VehicleSearchPageState();
}

class _VehicleSearchPageState extends State<VehicleSearchPage> {
  final ScrollController _scrollController = ScrollController();
  final VehicleController _controller = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final MultiChoiceController _statusController =
      MultiChoiceController(lists: filterMode);
  List<VehicleModel> vehicles = [];
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    vehicles = _controller.vehicles;
  }

  List<VehicleModel> getFiltered() {
    return _controller.vehicles
        .where((element) => filterKeyword(element) && filterStatus(element))
        .toList();
  }

  bool filterKeyword(VehicleModel model) {
    String keyword = _searchController.text;
    if (keyword.isEmpty) return true;
    return model.vehicleId.contains(_searchController.text);
  }

  bool filterStatus(VehicleModel model) {
    List<String> status = _statusController.selectedList;
    if (status.isEmpty) return true;
    if (model.status == VehicleStatus.Running && status.contains("running")) {
      return true;
    }
    if (model.status == VehicleStatus.Parking && status.contains("parking")) {
      return true;
    }
    if (model.status == VehicleStatus.Stopped && status.contains("stopped")) {
      return true;
    }
    return false;
  }

  void filter() {
    setState(() {
      vehicles = getFiltered();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      slivers: [
        SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: ContestTabHeader(
              112,
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                alignment: Alignment.center,
                width: double.maxFinite,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [buildTop(), buildChips()],
                ),
              ),
            )),
        vehicles.isNotEmpty
            ? SliverList.builder(
                itemCount: vehicles.length,
                itemBuilder: (_, index) {
                  return VehicleListItem(
                      item: vehicles[index],
                      callback: () {
                        Get.toNamed("/vehicledetail/${vehicles[index].id}");
                      });
                },
              )
            : SliverFillRemaining(
                child: ErrorWidget2(
                  text: "Không có kết quả !",
                ),
              )
      ],
    )));
  }

  Widget buildChips() {
    return MultiChoiceScrollable(
      controller: _statusController,
      onChange: (_) => filter(),
    );
  }

  Widget buildTop() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      onChanged: (_) => filter(),
      decoration: InputDecoration(
          hintText: "Tìm kiếm xe",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blueGrey[300]!, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          prefixIcon: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(FontAwesomeIcons.arrowLeft)),
          suffixIcon: IconButton(
              onPressed: () {
                _searchController.clear();
                _statusController.clear();
                filter();
              },
              icon: const Icon(FontAwesomeIcons.xmark)),
          isDense: true),
    );
  }
}

class MultiChoiceController extends ChangeNotifier {
  final Map<String, String> lists;
  List<String> selectedList = [];
  MultiChoiceController({required this.lists});
  void toggleItem(String key) {
    isSelected(key) ? selectedList.remove(key) : selectedList.add(key);
    notifyListeners();
  }

  void clear() {
    selectedList = [];
    notifyListeners();
  }

  bool isSelected(String key) {
    return selectedList.contains(key);
  }
}

class MultiChoiceScrollable extends StatefulWidget {
  const MultiChoiceScrollable(
      {super.key, required this.controller, this.onChange});
  final MultiChoiceController controller;
  final Function(List<String>)? onChange;
  @override
  State<MultiChoiceScrollable> createState() => _MultiChoiceScrollableState();
}

class _MultiChoiceScrollableState extends State<MultiChoiceScrollable> {
  List<String> selectedList = [];
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        selectedList = widget.controller.selectedList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        ...widget.controller.lists.keys.map((key) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text("${widget.controller.lists[key]}"),
                selected: widget.controller.isSelected(key),
                onSelected: (selected) {
                  widget.controller.toggleItem(key);
                  if (widget.onChange != null) {
                    widget.onChange!(widget.controller.selectedList);
                  }
                },
              ),
            ))
      ]),
    );
  }
}
