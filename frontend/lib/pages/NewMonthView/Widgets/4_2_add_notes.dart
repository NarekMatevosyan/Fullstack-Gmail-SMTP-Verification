import 'dart:convert';

import 'package:bbb/components/app_alert_dialog.dart';
import 'package:bbb/components/button_widget.dart';
import 'package:bbb/pages/NewMonthView/Database/month_database.dart';
import 'package:bbb/pages/NewMonthView/MonthResponseModel/exercise_model.dart';
import 'package:bbb/pages/NewMonthView/Providers/month_provider.dart';
import 'package:bbb/providers/user_data_provider.dart';
import 'package:bbb/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddNoteBottomSheet extends StatefulWidget {
  const AddNoteBottomSheet({super.key});

  @override
  State<AddNoteBottomSheet> createState() => _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState extends State<AddNoteBottomSheet> {
  final TextEditingController _noteController = TextEditingController();
  MonthProvider? monthProvider;

  @override
  void initState() {
    super.initState();
    monthProvider = Provider.of<MonthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async => await getNotesData());
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  List<ExerciseNotesModel> dataList = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Add a New Note text
              const Center(
                child: Text(
                  "Add a New Note",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Multiline Text Box
              TextField(
                controller: _noteController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter your note here',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Save Note Button
              ButtonWidget(
                text: "Save Note",
                textColor: Colors.white,
                onPress: () {
                  if (_noteController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AppAlertDialog(
                          title: "",
                          description: "Please enter text in the input field.",
                        );
                      },
                    );
                  } else {
                    addNewNote();
                    _noteController.clear();
                  }
                },
                color: AppColors.primaryColor,
                isLoading: false,
              ),
              const SizedBox(height: 20),

              _buildPreviouslyAddedNotes(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviouslyAddedNotes() {
    return Consumer<UserDataProvider>(
      builder: (context, userData, child) => dataList.isEmpty
          ? const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Text("No notes added yet."),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Previously Added Notes:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                    height: 150, // You can adjust this height
                    child: Scrollbar(
                      thumbVisibility: true,
                      thickness: 8,
                      radius: const Radius.circular(10),
                      child: ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final note = dataList[index];
                          return _buildNoteRow(DateFormat("dd-MM-yyyy").format(note.date!.toLocal()), note.note!);
                        },
                      ),
                    )),
              ],
            ),
    );
    return const SizedBox();
  }

  Widget _buildNoteRow(String date, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          const Text('|'),
          const SizedBox(width: 10),
          Expanded(
            child: Text(content),
          ),
        ],
      ),
    );
  }

  addNewNote() {
    String id = monthProvider!.isPumpDay && monthProvider!.isCircuit
        ? "${monthProvider!.exerciseDetailModel!.sId.toString()}-${monthProvider!.circuitIndex}"
        : monthProvider!.exerciseDetailModel!.sId.toString();
    final data = {
      "exerciseId": id.toString(),
      "date": "${DateTime.now().toUtc()}",
      "note": _noteController.text.trim(),
    };
    DatabaseHelper().insertData(data: data, tableName: DatabaseHelper.exerciseNotes);

    getNotesData();
  }

  getNotesData() async {
    String id = monthProvider!.isPumpDay && monthProvider!.isCircuit
        ? "${monthProvider!.exerciseDetailModel!.sId.toString()}-${monthProvider!.circuitIndex}"
        : monthProvider!.exerciseDetailModel!.sId.toString();
    final data = await DatabaseHelper().getDataFromTable(tableName: DatabaseHelper.exerciseNotes, id: id, where: "exerciseId");
    if (data.isNotEmpty) {
      dataList = List<ExerciseNotesModel>.from(json.decode(jsonEncode(data)).map((x) => ExerciseNotesModel.fromJson(x)));
    } else {
      dataList = [];
    }
    setState(() {});
  }
}
