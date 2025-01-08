import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: GeneratePDF(onThemeToggle: _toggleTheme),
    );
  }
}

class GeneratePDF extends StatefulWidget {
  final VoidCallback onThemeToggle;

  GeneratePDF({required this.onThemeToggle});

  @override
  _GeneratePDFState createState() => _GeneratePDFState();
}

class _GeneratePDFState extends State<GeneratePDF> {
  bool isAssignment = true; // Toggle between Assignment and Lab Report
  final _formKey = GlobalKey<FormState>();

  // Controllers for fields
  final TextEditingController _assignmentNoController = TextEditingController();
  final TextEditingController _submissionDateController =
  TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _courseTitleController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _studentController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _intakeController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  String _designation = 'Lecturer';
  String _program = 'B.Sc in CSE';

  // Lab Report Specific Fields
  final TextEditingController _experimentNoController = TextEditingController();
  final TextEditingController _experimentDateController =
  TextEditingController();
  final TextEditingController _experimentNameController =
  TextEditingController();

  void _generatePDF() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final pdf = pw.Document();

    // Load the logo from assets
    final logoBytes = await rootBundle.load('assets/images/logo.png');
    final logoImage = logoBytes.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(
                pw.MemoryImage(logoImage),
                width: 80,
                height: 80,
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                isAssignment ? 'Assignment' : 'Lab Report',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Bangladesh University of Business and Technology',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),

              // Main Table
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey),
                  columnWidths: {
                    0: pw.FlexColumnWidth(1), // 50% for the left column
                    1: pw.FlexColumnWidth(1), // 50% for the right column
                  },
                  children: [
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text(
                          isAssignment ? 'Assignment No' : 'Experiment No',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text(isAssignment
                            ? _assignmentNoController.text
                            : _experimentNoController.text),
                      ),
                    ]),
                    if (!isAssignment)
                      pw.TableRow(children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text(
                            'Experiment Name',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text(_experimentNameController.text),
                        ),
                      ]),
                    if (!isAssignment)
                      pw.TableRow(children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text(
                            'Experiment Date',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4.0),
                          child: pw.Text(_experimentDateController.text),
                        ),
                      ]),
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text(
                          'Course Title',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text(_courseTitleController.text),
                      ),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text(
                          'Course Code',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text(_courseCodeController.text),
                      ),
                    ]),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // Submitted By and Submitted To Table
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey),
                  columnWidths: {
                    0: pw.FlexColumnWidth(1), // 50% for the left column
                    1: pw.FlexColumnWidth(1), // 50% for the right column
                  },
                  children: [
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text('Submitted By',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text('Submitted To',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Name: ${_studentController.text}'),
                            pw.Text('ID: ${_idController.text}'),
                            pw.Text('Intake: ${_intakeController.text}'),
                            pw.Text('Section: ${_sectionController.text}'),
                            pw.Text('Program: $_program'),
                          ],
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Name: ${_teacherController.text}'),
                            pw.Text('Designation: $_designation'),
                            pw.Text(
                                'Department: ${_departmentController.text}'),
                            pw.Text('BUBT'),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // Date of Submission and Signature of Teacher
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey),
                  columnWidths: {
                    0: pw.FlexColumnWidth(1), // 50% for the left column
                    1: pw.FlexColumnWidth(1), // 50% for the right column
                  },
                  children: [
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text('Date of Submission',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text('Signature of Teacher',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ]),
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4.0),
                        child: pw.Text(_submissionDateController.text),
                      ),
                      pw.Container(height: 40),
                    ]),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              pw.Text(
                'Bangladesh University of Business and Technology',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();

    // Save PDF locally
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/generated_pdf.pdf');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)],
        text: 'Here is the generated PDF.');
  }

  void _clearFields() {
    _assignmentNoController.clear();
    _submissionDateController.clear();
    _courseCodeController.clear();
    _courseTitleController.clear();
    _teacherController.clear();
    _departmentController.clear();
    _studentController.clear();
    _idController.clear();
    _intakeController.clear();
    _sectionController.clear();
    _experimentNoController.clear();
    _experimentDateController.clear();
    _experimentNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAssignment ? "Assignment" : "Lab Report"),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Toggle Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isAssignment = true;
                      });
                    },
                    child: Text("Assignment"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isAssignment = false;
                      });
                    },
                    child: Text("Lab Report"),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Assignment or Lab Report Fields
              if (isAssignment) ...[
                TextFormField(
                  controller: _assignmentNoController,
                  decoration: InputDecoration(
                    labelText: "Assignment No",
                    border: OutlineInputBorder(),
                  ),
                ),
              ] else ...[
                TextFormField(
                  controller: _experimentNoController,
                  decoration: InputDecoration(
                    labelText: "Experiment No",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _experimentNameController,
                  decoration: InputDecoration(
                    labelText: "Experiment Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  readOnly: true,
                  controller: _experimentDateController,
                  decoration: InputDecoration(
                    labelText: "Experiment Date",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          _experimentDateController.text =
                              DateFormat.yMMMd().format(pickedDate);
                        }
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              SizedBox(height: 16),

              TextFormField(
                readOnly: true,
                controller: _submissionDateController,
                decoration: InputDecoration(
                  labelText: "Submission Date",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        _submissionDateController.text =
                            DateFormat.yMMMd().format(pickedDate);
                      }
                    },
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _courseCodeController,
                decoration: InputDecoration(
                  labelText: "Course Code",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _courseTitleController,
                decoration: InputDecoration(
                  labelText: "Course Title",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _teacherController,
                decoration: InputDecoration(
                  labelText: "Teacher",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _departmentController,
                decoration: InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _designation,
                onChanged: (value) {
                  setState(() {
                    _designation = value!;
                  });
                },
                items: ['Lecturer', 'Assistant Professor']
                    .map((designation) => DropdownMenuItem(
                  value: designation,
                  child: Text(designation),
                ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: "Designation",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _studentController,
                decoration: InputDecoration(
                  labelText: "Student",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: "ID",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _intakeController,
                decoration: InputDecoration(
                  labelText: "Intake",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _sectionController,
                decoration: InputDecoration(
                  labelText: "Section",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _program,
                onChanged: (value) {
                  setState(() {
                    _program = value!;
                  });
                },
                items: [
                  'B.Sc in CSE',
                  'B.Sc in EEE',
                  'B.Sc in Civil',
                  'B.Sc in Mechanical'
                ]
                    .map((program) => DropdownMenuItem(
                  value: program,
                  child: Text(program),
                ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: "Program",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _generatePDF(); // Call the function properly here.
                      },
                      child: Text("Generate PDF"),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _clearFields,
                    child: Text("Clear"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Share.share(
                          "Sharing assignment or lab report details...");
                    },
                    child: Icon(Icons.share),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
