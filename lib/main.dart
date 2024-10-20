import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter IndexedStack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter IndexedStack'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final listCategories = <String>[
    'Peminjaman Dana',
    'Perjalanan Dinas',
    'Pengajuan Karyawan Baru',
  ];
  final listJobPositions = <String>[
    'Product Engineer',
    'Account Manager',
    'Copywriter',
  ];
  final controllerCategory = TextEditingController();
  final controllerJobPosition = TextEditingController();

  int? indexCategory;
  var selectedCategory = '';
  var widthScreen = 0.0;
  var heightScreen = 0.0;
  var selectedJobPosition = '';

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    widthScreen = mediaQueryData.size.width;
    heightScreen = mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildWidgetTextFieldCategory(),
            indexCategory == null
                ? Container()
                : IndexedStack(
                    index: indexCategory,
                    children: [
                      buildWidgetInputPeminjamanDana(),
                      buildWidgetInputPerjalananDinas(),
                      buildWidgetInputPengajuanKaryawanBaru(),
                    ],
                  ),
            const SizedBox(height: 16),
            buildWidgetButtonSubmit(),
          ],
        ),
      ),
    );
  }

  Widget buildWidgetButtonSubmit() {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil dikirimkan'),
            ),
          );
        },
        child: const Text('Kirim'),
      ),
    );
  }

  Widget buildWidgetInputPeminjamanDana() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Jumlah',
          isDense: true,
          prefix: Text('Rp.'),
        ),
        keyboardType: TextInputType.number,
        minLines: 1,
        maxLines: 1,
        inputFormatters: [
          CurrencyIndonesiaInputFormatter(),
        ],
      ),
    );
  }

  Widget buildWidgetInputPerjalananDinas() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: "Lokasi",
          isDense: true,
        ),
        keyboardType: TextInputType.text,
        minLines: 1,
        maxLines: 1,
      ),
    );
  }

  Widget buildWidgetInputPengajuanKaryawanBaru() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: controllerJobPosition,
        decoration: const InputDecoration(
          labelText: 'Posisi pekerjaan',
          isDense: true,
          suffixIcon: Icon(
            Icons.arrow_drop_down,
          ),
        ),
        readOnly: true,
        onTap: () async {
          final chooseJobPosition = await showDialog<String>(
            context: context,
            builder: (context) {
              return WidgetDialogChoose(
                widthScreen: widthScreen,
                heightScreen: heightScreen,
                title: 'Pilih Posisi Pekerjaan',
                listOptions: listJobPositions,
                defaultSelected: selectedJobPosition,
              );
            },
          );
          if (chooseJobPosition != null) {
            setState(() {
              selectedJobPosition = chooseJobPosition;
              controllerJobPosition.text = selectedJobPosition;
            });
          }
          unfocus();
        },
      ),
    );
  }

  Widget buildWidgetTextFieldCategory() {
    return TextFormField(
      controller: controllerCategory,
      decoration: const InputDecoration(
        labelText: 'Kategori',
        isDense: true,
        suffixIcon: Icon(
          Icons.arrow_drop_down,
        ),
      ),
      readOnly: true,
      onTap: () async {
        final chooseCategory = await showDialog<String>(
          context: context,
          builder: (context) {
            return WidgetDialogChoose(
              widthScreen: widthScreen,
              heightScreen: heightScreen,
              title: 'Pilih Kategori',
              listOptions: listCategories,
              defaultSelected: selectedCategory,
            );
          },
        );
        if (chooseCategory != null) {
          setState(() {
            controllerJobPosition.clear();
            selectedJobPosition = '';
            selectedCategory = chooseCategory;
            indexCategory = listCategories
                .indexWhere((element) => element == selectedCategory);
            controllerCategory.text = selectedCategory;
          });
        }
        unfocus();
      },
    );
  }

  void unfocus() {
    final primaryFocus = FocusManager.instance.primaryFocus;
    if (primaryFocus != null) {
      primaryFocus.unfocus();
    }
  }
}

class WidgetDialogChoose extends StatefulWidget {
  final double widthScreen;
  final double heightScreen;
  final String title;
  final List<String> listOptions;
  final String? defaultSelected;

  const WidgetDialogChoose({
    Key? key,
    required this.widthScreen,
    required this.heightScreen,
    required this.title,
    required this.listOptions,
    required this.defaultSelected,
  }) : super(key: key);

  @override
  State<WidgetDialogChoose> createState() => _WidgetDialogChooseState();
}

class _WidgetDialogChooseState extends State<WidgetDialogChoose> {
  String? selectedCategory;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    selectedCategory = widget.defaultSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    final listWidgetRadioButton = <Widget>[];
    for (final itemCategory in widget.listOptions) {
      final widgetRadioButton = Radio<String>(
        value: itemCategory,
        groupValue: selectedCategory,
        onChanged: (value) => setState(() => selectedCategory = itemCategory),
      );
      final widgetText = Expanded(
        child: Text(
          itemCategory,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[900],
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
      final widgetItem = GestureDetector(
        onTap: () => setState(() => selectedCategory = itemCategory),
        child: Row(
          children: [
            widgetRadioButton,
            widgetText,
          ],
        ),
      );
      listWidgetRadioButton.add(widgetItem);
    }
    children.addAll(listWidgetRadioButton);

    return AlertDialog(
      title: Text(
        widget.title,
        textAlign: TextAlign.start,
      ),
      titleTextStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 16,
          ),
      titlePadding: const EdgeInsets.only(
        left: 16,
        top: 16,
      ),
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: widget.widthScreen / 1.2,
            height: widget.heightScreen / 2,
            child: ListView(
              shrinkWrap: true,
              children: children,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: buildWidgetButtonCancel(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: buildWidgetButtonOk(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildWidgetButtonCancel() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Batal'),
    );
  }

  Widget buildWidgetButtonOk() {
    return TextButton(
      onPressed: selectedCategory == null || selectedCategory!.isEmpty
          ? null
          : () {
              Navigator.pop(context, selectedCategory);
            },
      child: const Text('OK'),
    );
  }
}

class CurrencyIndonesiaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '0',
        selection: TextSelection.collapsed(offset: 1),
      );
    } else if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var newNumberValue =
        double.parse(newValue.text.replaceAll(',', '').replaceAll('.', ''));
    final formatter = NumberFormat('#,###');
    final newText = formatter.format(newNumberValue).replaceAll(',', '.');
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
