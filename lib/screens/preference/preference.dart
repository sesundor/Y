import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/widgets/yd_multi_steps.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/utils/image_helper.dart';

class PreferenceProvider extends ChangeNotifier {
  String _name = "";
  String get name => _name;
  set name (String name) {
    _name = name;
    print("notifyListeners()");
    notifyListeners();
  }

  List<String> _selectedInterests = [];
  List<String> get selectedInterests => _selectedInterests;
  void addInterest(String interest) {
    _selectedInterests.add(interest);
    notifyListeners();
  }
  void removeInterest(String interest) {
    _selectedInterests.remove(interest);
    notifyListeners();
  }

  List<String> _selectedProficiency = [];
  List<String> get selectedProficiency => _selectedInterests;
  void addProficiency(String proficiency) {
    _selectedProficiency.add(proficiency);
    notifyListeners();
  }
  void removeProficiency(String proficiency) {
    _selectedProficiency.remove(proficiency);
    notifyListeners();
  }
}

class PreferenceScreen extends StatelessWidget {
  const PreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PreferenceProvider(),
      child: MultiSteps(
        title: "Preference",
        hasButton: true,
        hasProgress: true,
        onComplete: () {
          _dialogBuilder(context);
          // context.go("/");
        },
        steps: [
          OneStep(title: "What's your name?", builder: (prev, next) => _Step1()),
          OneStep(title: "Location", builder: (prev, next) => _Step2()),
          OneStep(title: "Select up to 5 interests", builder: (prev, next) => _Step3()),
          OneStep(title: "Upload your photos", builder: (prev, next) => _Step4()),
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: 450
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).colorScheme.background,
          ),
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.surface,
                      )
                    )
                  ],
                ),
              ),
              Text(
                "You're Verified",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 250,
                ),
                child: Text(
                  "Your account is verified. Let's start to make friends!",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 50,
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => context.go("/"),
                    child: Text("Get Started")
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

// What's your name
class _Step1 extends StatelessWidget {
  _Step1 ({super.key});
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print("rebuild...  the value is ${nameController.value} ");
    return Consumer<PreferenceProvider>(
      builder: (BuildContext context, PreferenceProvider preferenceProvider, Widget? child) {
        // print("Assign the name from provider to textfield: ${Provider.of<PreferenceProvider>(context, listen: false).name} => ${nameController.text}");
        nameController.text = Provider.of<PreferenceProvider>(context, listen: false).name;
        nameController.selection = TextSelection(
          baseOffset: nameController.text.length,
          extentOffset: nameController.text.length,
        );
        return Container(
            padding: EdgeInsets.all(30),
            constraints: BoxConstraints(
                maxHeight: 300,
                maxWidth: 300
            ),
            child: TextField(
              controller: nameController,
              onChanged: (value) {
                print("OnChange... value is ${value}");
                Provider.of<PreferenceProvider>(context, listen: false).name = value;
              },
            )
        );
      },
    );
  }
}

// Language Proficiency
class _Step2 extends StatelessWidget {
  const _Step2({super.key});

  static const List<String> _proficiencyLevels = [
    'Advanced', 'Intermediate', 'Beginner'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'What is your Yiddish language proficiency?',
            style: TextStyle(color: Color.fromARGB(255, 162, 47, 145), fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Spacer(),
              Column(
                children: List.generate(_proficiencyLevels.length, (index) {
                  return Consumer<PreferenceProvider>(
                    builder: (BuildContext context, PreferenceProvider preferenceProvider, Widget? child) {
                  bool isSelected = context.read<PreferenceProvider>().selectedProficiency.contains(_proficiencyLevels[index]);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ChoiceChip(
                      label: Text(_proficiencyLevels[index]),
                      selected: isSelected,
                      selectedColor: Color.fromARGB(255, 247, 141, 231),
                      onSelected: (selected) {
                          if (selected) {
                            preferenceProvider.addProficiency(_proficiencyLevels[index]);
                          } else {
                            preferenceProvider._selectedProficiency = []; 
                          }
                      },
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Color.fromARGB(255, 162, 47, 145)),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected ? Color.fromARGB(255, 247, 141, 231) : Colors.grey,
                        ),
                      ),
                    )
                  );
                });
                }),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      '3/5',
                      style: TextStyle(color: Color.fromARGB(255, 162, 47, 145), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 3 / 5,
                      backgroundColor: Color.fromARGB(255, 254, 196, 247),
                      color: Color.fromARGB(255, 247, 141, 231),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Select up to 5 interests
class _Step3 extends StatelessWidget {
  const _Step3({super.key});

  static const List<String> _interests = [
    'Gaming', 'Dancing', 'Language', 'Music', 'Movie',
    'Photography', 'Architecture', 'Fashion', 'Book',
    'Writing', 'Nature', 'Painting', 'Football', 'People',
    'Animals', 'Gym & Fitness'
  ];

  static const List<IconData> _icons = [
    Icons.videogame_asset, Icons.directions_run, Icons.language,
    Icons.music_note, Icons.movie, Icons.camera_alt, Icons.account_balance,
    Icons.checkroom, Icons.book, Icons.edit, Icons.eco, Icons.brush,
    Icons.sports_soccer, Icons.people, Icons.pets, Icons.fitness_center
  ];

  @override
  Widget build(BuildContext context) {
    // print("rebuild!!");

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Select up to 5 interests',
          style: TextStyle(color: Color.fromARGB(255, 162, 47, 145), fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                alignment: WrapAlignment.center,
                children: List.generate(_interests.length, (index) {
              return Consumer<PreferenceProvider>(
                builder: (BuildContext context, PreferenceProvider preferenceProvider, Widget? child) {
                  bool isSelected = context.read<PreferenceProvider>().selectedInterests.contains(_interests[index]);
                  return ChoiceChip(
                    label: Text(_interests[index]),
                    avatar: Icon(_icons[index], color: isSelected ? Colors.black : Colors.black),
                    selected: isSelected,
                    selectedColor: Color.fromARGB(255, 247, 141, 231),
                    onSelected: (selected) {
                      if (selected && preferenceProvider.selectedInterests.length < 5) {
                        preferenceProvider.addInterest(_interests[index]);
                      } else if (!selected) {
                        preferenceProvider.removeInterest(_interests[index]);
                      }
                    },
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Color.fromARGB(255, 162, 47, 145), fontSize: 16),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isSelected ? Color.fromARGB(255, 247, 141, 231) : Colors.grey,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      '4/5',
                      style: TextStyle(color: Color.fromARGB(255, 162, 47, 145), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 4 / 5,
                      backgroundColor: Color.fromARGB(255, 254, 196, 247),
                      color: Color.fromARGB(255, 247, 141, 231),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ]
          )
        )
      )
    );  
  }
}


// Upload your photos
class _Step4 extends StatefulWidget {
  const _Step4({super.key});

  @override
  State<_Step4> createState() => _Step4State();
}

class _Step4State extends State<_Step4> {
  List<File?> _images = List<File?>.filled(6, null); // List for app images
  List<String?> _webImages = List<String?>.filled(6, null); // List for web images

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color.fromRGBO(253, 247, 253, 1),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16), // Add padding to avoid edge issues
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400), // Set max width for the grid
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemSize = (constraints.maxWidth - 3 * 3) / 3; // Calculate item size
                    return StaggeredGrid.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      children: List.generate(6, (index) =>
                        StaggeredGridTile.count(
                          crossAxisCellCount: index == 0 ? 2 : 1,
                          mainAxisCellCount: index == 0 ? 2 : 1,
                          child: Container(
                            width: itemSize,
                            height: itemSize,
                            child: ImageTile(
                              imageFile: _images[index],
                              webImage: _webImages[index],
                              onImageSelected: (file) {
                                setState(() {
                                  if (kIsWeb) {
                                    _webImages[index] = file.path;
                                  } else {
                                    _images[index] = file;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20), // Add spacing at the bottom
          ],
        ),
      ),
    );
  }
}


// Image upload helper widget
class ImageTile extends StatelessWidget {
  final File? imageFile;
  final String? webImage; // Add a field for web image
  final ValueChanged<File> onImageSelected;

  const ImageTile({
    Key? key,
    required this.imageFile,
    required this.webImage,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      child: Stack(
        children: [
          if (kIsWeb && webImage != null) // Check if it's web and web image is available
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                webImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          else if (imageFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                imageFile!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter, // Position at the bottom center
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () async {
                  final files = await ImageHelper().pickImage();
                  if (files.isNotEmpty) {
                    final croppedFile = await ImageHelper().crop(
                      file: files.first,
                      context: context,
                    );
                    if (croppedFile != null) {
                      onImageSelected(File(croppedFile.path));
                    }
                  }
                },
                child: Text('Add'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}