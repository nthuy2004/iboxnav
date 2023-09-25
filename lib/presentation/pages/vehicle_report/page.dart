import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iboxnav/config/constants.dart';
import 'package:iboxnav/controllers/vehicle/vehicle_controller.dart';
import 'package:iboxnav/controllers/widget/combobox_controller.dart';
import 'package:iboxnav/controllers/widget/datetime_controller.dart';
import 'package:iboxnav/core/utils/snackbar.dart';
import 'package:iboxnav/core/utils/utility.dart';
import 'package:iboxnav/models/report_model/detail_work_report_model.dart';
import 'package:iboxnav/models/report_model/overspeed_report_model.dart';
import 'package:iboxnav/models/report_model/parking_report_model.dart';
import 'package:iboxnav/models/report_model/work_report_model.dart';
import 'package:iboxnav/presentation/components/appbar.dart';
import 'package:iboxnav/presentation/components/combo_box.dart';
import 'package:iboxnav/presentation/components/contest_tab_header.dart';
import 'package:iboxnav/presentation/components/datetime_picker.dart';
import 'package:iboxnav/presentation/components/error_widget.dart';
import 'package:iboxnav/presentation/components/loading.dart';
import 'package:iboxnav/repositories/report_repository.dart';

typedef RowBuilder<T> = DataRow Function(BuildContext context, dynamic data);

class BaseReportPage<T> extends StatefulWidget {
  const BaseReportPage(
      {super.key,
      required this.thead,
      required this.rowBuilder,
      required this.reportType});
  final String reportType;
  final List<TableHead> thead;
  final RowBuilder<T> rowBuilder;
  @override
  State<BaseReportPage> createState() => _BaseReportPageState();
}

class _BaseReportPageState<T> extends State<BaseReportPage<T>> {
  final VehicleController _vehicle = Get.find();

  final ReportRepository _report = Get.put(ReportRepository());

  final String? reportType = Get.parameters["report"];

  final ScrollController _hController = ScrollController();
  final ScrollController _controller = ScrollController();

  final DatetimePickerController _startDate = DatetimePickerController(
      date: DateTime.now().subtract(const Duration(hours: 6)));

  final DatetimePickerController _endDate =
      DatetimePickerController(date: DateTime.now());

  ComboboxController<String>? _vehiclesID;

  FutureState state = FutureState.Idle;
  List<T> data = [];

  @override
  void initState() {
    _vehiclesID = ComboboxController(
        list: [..._vehicle.vehicles.map((vehicle) => vehicle.vehicleId)]);
    super.initState();
  }

  @override
  void dispose() {
    _hController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future search() async {
    try {
      setState(() {
        state = FutureState.Loading;
      });
      List dataa = await buildFuture()(
          _vehiclesID!.value!, _startDate.date, _endDate.date);
      if (dataa.isEmpty) {
        setState(() {
          state = FutureState.HasError;
        });
      } else {
        setState(() {
          data = dataa as List<T>;
          state = FutureState.HasData;
        });
      }
    } catch (e) {
      setState(() {
        state = FutureState.HasError;
      });
    }
  }

  FutureReportFunction buildFuture() {
    switch (reportType) {
      case "parking":
        return _report.getParkingReport;
      case "work":
        return _report.getWorkReport;
      case "overspeed":
        return _report.getOverspeedReport;
      case "workdetail":
        return _report.getDetailWorkReport;
      case "door":
        return _report.getDoorOpenReport;
      default:
        throw "undefined reportType";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _appBar(context),
          _select(context),
          Expanded(
              child: Container(
            color: Colors.white,
            child: _body(),
          ))
        ],
      ),
    );
  }

  Widget _body() {
    if (state == FutureState.Idle) {
      return ErrorWidget2(
        text: "Hãy bắt đầu tìm kiếm !",
        topChild: const Icon(
          FontAwesomeIcons.magnifyingGlass,
          size: 50.0,
          color: Colors.black,
        ),
      );
    }
    if (state == FutureState.Loading)
      return LoadingWidget(text: "Đang lấy dữ liệu...");
    if (state == FutureState.HasError)
      return ErrorWidget2(
        text: "Không có dữ liệu !",
        callback: () => Get.back(),
        btnText: "Quay lại",
      );
    return DataTable2(
        scrollController: _controller,
        horizontalScrollController: _hController,
        columnSpacing: 5,
        horizontalMargin: 12,
        bottomMargin: 10,
        minWidth: 600,
        columns: _createColumns(),
        rows: _createRows(data));
  }

  List<DataColumn2> _createColumns() {
    return [
      ...widget.thead.map((e) => DataColumn2(label: Text(e.name), size: e.size))
    ];
  }

  List<DataRow> _createRows(List<T> lists) {
    return [...lists.map((e) => widget.rowBuilder(context, e))];
  }

  Widget _appBar(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Material(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                  onTap: () => Get.back(),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
              Expanded(
                  child: Text(
                _reportTitle(),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 22,
                ),
              )),
              SizedBox(
                height: AppBar().preferredSize.height,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _select(context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(38.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: const Offset(0, 2),
                            blurRadius: 8.0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 0, bottom: 0),
                      child: Combobox(
                          controller: _vehiclesID!,
                          showHintOnly: true,
                          helper: "Chọn biển số xe",
                          bordered: false),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: state == FutureState.Loading
                      ? Colors.grey.withOpacity(0.8)
                      : theme.primaryColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () async {
                      if (_startDate.compareTo(_endDate) >= 0) {
                        GetSnackbarEx.error(
                            message:
                                "Thời gian bắt đầu phải nhỏ hơn thời gian kết thúc !",
                            icon: FontAwesomeIcons.clock);
                        return;
                      }
                      if (state != FutureState.Loading) {
                        await search();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        FontAwesomeIcons.magnifyingGlass,
                        size: 20,
                        color: theme.scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              _dateTimePicker("Bắt đầu", _startDate),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  width: 1,
                  height: 42,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              _dateTimePicker("Kết thúc", _endDate)
            ],
          )
        ],
      ),
    );
  }

  String _reportTitle() {
    return Constants.INSPECT_TYPES[reportType]!.title;
  }

  Widget _dateTimePicker(String text, DatetimePickerController controller) {
    return Expanded(
        child: DatetimePicker.Custom(
            controller,
            (context, controller) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontWeight: FontWeight.w100,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      controller.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w100,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                      ),
                    )
                  ],
                )));
  }
}



class TableHead {
  final String name;
  ColumnSize size;
  TableHead({required this.name, this.size = ColumnSize.M});
}
