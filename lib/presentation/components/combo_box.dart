import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:iboxnav/controllers/widget/combobox_controller.dart';

// ignore: must_be_immutable
class Combobox extends StatefulWidget {
  ComboboxController<String> controller;
  String? helper;
  bool showHintOnly;
  bool bordered;
  void Function(int index, String? value)? onChange;
  Combobox(
      {super.key,
      required this.controller,
      this.helper,
      this.bordered = true,
      this.showHintOnly = false,
      this.onChange});

  @override
  State<Combobox> createState() => _ComboboxState();
}

class _ComboboxState extends State<Combobox> {
  String? currentState;
  @override
  void initState() {
    super.initState();
    if (widget.controller.list.isNotEmpty) {
      setState(() {
        currentState = widget.controller.list.first;
      });
    }
    widget.controller.addListener(() {
      setState(() {
        currentState = widget.controller.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ComboboxController<String> _controller = widget.controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (widget.helper != null && !widget.showHintOnly)
            ? Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  widget.helper!,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : const SizedBox.shrink(),
        SizedBox(
          width: double.maxFinite,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              hint: Text(
                widget.helper ?? "",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              buttonStyleData: ButtonStyleData(
                height: 54,
                width: 160,
                padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: widget.bordered
                        ? Border.all(
                            color: Colors.blueGrey[300]!,
                          )
                        : Border.all(color: Colors.transparent),
                    color: Colors.transparent,
                    boxShadow: []),
                elevation: 2,
              ),
              isExpanded: true,
              items: _controller.list
                  .asMap()
                  .entries
                  .map((item) => DropdownMenuItem<String>(
                        onTap: () {
                          _controller.setItem(item.key, item.value);
                          if (widget.onChange != null) {
                            widget.onChange!(item.key, item.value);
                          }
                        },
                        value: item.value,
                        child: Text(
                          item.value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ))
                  .toList(),
              value: currentState,
              onChanged: (value) {},
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          ),
        )
      ],
    );
  }
}
