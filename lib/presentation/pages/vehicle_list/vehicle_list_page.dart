import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iboxnav/config/constants.dart';
import 'package:iboxnav/controllers/vehicle/vehicle_controller.dart';
import 'package:iboxnav/presentation/components/contest_tab_header.dart';
import 'package:iboxnav/presentation/pages/vehicle_list/vehicle_list_item.dart';
import 'package:iboxnav/presentation/pages/vehicle_list/vehicle_skeleton.dart';
import 'package:iboxnav/presentation/components/error_widget.dart';
import 'package:iboxnav/presentation/pages/vehicle_report/page.dart';

class VehicleListPage extends StatefulWidget {
  const VehicleListPage({super.key});

  @override
  State<VehicleListPage> createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  FutureState state = FutureState.Loading;
  final VehicleController _controller = Get.find();
  final ScrollController _scrollController = ScrollController();

  Future refresh() async {
    try {
      setState(() {
        state = FutureState.Loading;
      });
      await _controller.getVehicles();
      setState(() {
        state = FutureState.HasData;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        state = FutureState.HasError;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await refresh();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: RefreshIndicator(
        onRefresh: refresh,
        child: state == FutureState.HasError ? _error() : _body(context),
      ),
    ));
  }

  CustomScrollView _body(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (_, i) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/bg_car_list.png",
                          fit: BoxFit.cover,
                        ),
                        Text(
                          "Danh sách xe",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey[900],
                            fontSize: 32,
                          ),
                        )
                      ],
                    ),
                childCount: 1)),
        SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: ContestTabHeader(
              75,
              Container(
                alignment: Alignment.center,
                color: Theme.of(context).scaffoldBackgroundColor,
                width: double.infinity,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: _searchBar(context),
                ),
              ),
            )),
        _items()
      ],
    );
  }

  Widget _items() {
    if (state == FutureState.Loading) {
      return SliverList.builder(
        itemCount: 2,
        itemBuilder: (_, index) {
          return const VehicleSkeleton();
        },
      );
    }
    if (state == FutureState.HasError) {
      return SliverList.builder(
        itemCount: 1,
        itemBuilder: (_, index) {
          return _error();
        },
      );
    }
    return SliverList.builder(
      itemCount: _controller.vehicles.length,
      itemBuilder: (_, index) {
        return VehicleListItem(
            item: _controller.vehicles[index],
            callback: () {
              Get.toNamed("/vehicledetail/${_controller.vehicles[index].id}");
            });
      },
    );
  }

  ErrorWidget2 _error() {
    return ErrorWidget2(
      text: "Không thể lấy thông tin",
      callback: refresh,
      btnText: "Thử lại",
    );
  }

  Widget _searchBar(context) {
    return TextField(
      canRequestFocus: false,
      readOnly: true,
      onTap: () {
        Get.toNamed("/vehiclesearch");
      },
      decoration: InputDecoration(
          hintText: "Tìm kiếm xe",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blueGrey[300]!, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1)),
          suffixIcon: const Icon(FontAwesomeIcons.magnifyingGlass),
          isDense: true),
    );
  }
}
