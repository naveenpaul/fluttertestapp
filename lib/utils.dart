import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

String getFormattedDate(String date) {
  /// Convert into local date format.
  var localDate = DateTime.parse(date).toLocal();

  /// inputFormat - format getting from api or other func.
  /// e.g If 2021-05-27 9:34:12.781341 then format should be yyyy-MM-dd HH:mm
  /// If 27/05/2021 9:34:12.781341 then format should be dd/MM/yyyy HH:mm
  var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
  var inputDate = inputFormat.parse(localDate.toString());

  /// outputFormat - convert into format you want to show.
  var outputFormat = DateFormat('dd MMM yyyy');
  var outputDate = outputFormat.format(inputDate);

  return outputDate.toString();
}

String getBaseUrl(){
  return 'https://dev.relatas.com/';
  // return 'http://localhost:7000/';
}

Color parseColor(String color) {
  String hex = color.replaceAll("#", "");
  if (hex.isEmpty) hex = "ffffff";
  if (hex.length == 3) {
    hex = '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
  }
  Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
  return col;
}

InputDecoration formInputDecorationStyle(String label) {
  return InputDecoration(
      labelText: label,
      fillColor: Colors.white, filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      )
  );
}

SizedBox sizedBoxFormColumn(){
  return SizedBox(width: 15);
}

Container label(String label){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
      child:
     Text(label.toUpperCase(),
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: Colors.grey,
      ),
    )
  );
}

ReactiveTextField inputField(String formControlName, form) {
 return ReactiveTextField<String>(
   formControlName: formControlName,
   onSubmitted: () => form.focus('password'),
   textInputAction: TextInputAction.next,
   decoration: formInputDecorationStyle(""),
 );
}

Container DropDownButtonBox(String selectedStage, List<String> options){
  return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: SizedBox(),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        value: selectedStage,
        onChanged: (value) {
          print(value);
        },
      )
  );
}