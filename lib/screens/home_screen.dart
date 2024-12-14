import 'package:chatgpt_test/utils/open_ai.dart';
import 'package:chatgpt_test/widgets/text_widgets.dart';
import 'package:chatgpt_test/widgets/title.dart';
import 'package:flutter/material.dart';
import '../widgets/table.dart';
import '../widgets/headline_with_description.dart';
import '../data/dummy_text.dart';
import '../utils/helper.dart';
import '../widgets/url_input.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String mainTitle = '';
  String mainShortDescription = '';
  String lastUpdated = '';
  bool isLoading = false;
  List<Map<String, dynamic>> tables = [];
  String? selectedValue;

  void fetchData(String url) async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ChatGPTService()
          .getResponse(url: url, language: selectedValue ?? 'English');
      if (!isLoading) return; // Exit if loading was cancelled
      setState(() {
        mainTitle = data['mainTitle'];
        mainShortDescription = data['mainShortDescription'];
        lastUpdated = data['lastUpdated'];
        tables = (data['tables'] as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      });
    } catch (e) {
      if (isLoading) {
        debugPrint('Error fetching data: $e');
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop(); // Dismiss the loading dialog
      }
    } finally {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop(); // Dismiss the loading dialog
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => launchURL(
              context, 'https://www.sheepai.app/'), // Navigate to URL on tap
          child: const Row(
            children: [
              Text(
                'Sheep',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, // Make the text bolder
                ),
              ),
              Text(
                'AI_',
                style: TextStyle(
                  color: Color(0xFF00FF00), // More fluorescent green color
                  fontWeight: FontWeight.bold, // Make the text bolder
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[900], // Dark grey color
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UrlInputField(onSubmitted: fetchData),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom:
                          8.0), // Apply padding around the DropdownButtonFormField
                  child: DropdownButtonFormField<String>(
                    value: selectedValue,
                    hint: const Padding(
                      padding: EdgeInsets.only(
                          left: 8.0), // Apply left padding to the hint text
                      child: Text('Select language'),
                    ),
                    items: <String>['English', 'Croatian'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                    style: const TextStyle(
                      color: Colors.blue, // Change text color
                      fontSize: 16, // Change font size
                    ),
                    dropdownColor:
                        Colors.grey[200], // Change dropdown background color
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 8.0), // Apply left padding to the content
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.transparent), // Remove underline
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.transparent), // Remove underline
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.blue, // Change icon color
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TitleWidget(
                  mainTitle: mainTitle,
                  lastUpdate: lastUpdated,
                  mainShortDescription: mainShortDescription,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity, // Make the width equal
                        child: HeadlineWithDescription(
                          mainHeadline: mainTitle,
                          description: overviewText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      for (var table in tables)
                        if (table['columns'] != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20.0), // Add padding between tables
                            child: Container(
                              width: double.infinity, // Make the width equal
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[800], // Darker blue color
                                borderRadius: BorderRadius.circular(
                                    12.0), // Ensure rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TableWidget(
                                headline: table['headline'] ?? 'No Headline',
                                columns: (table['columns'] as List)
                                    .map((column) => List<String>.from(column))
                                    .toList(),
                              ),
                            ),
                          ),
                      const SizedBox(height: 20),
                      const SizedBox(
                        width: double.infinity, // Make the width equal
                        child: HeadlineWithDescription(
                          mainHeadline: detailsTitle,
                          description: detailsText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const HeadlineText(text: 'Welcome to SheepAI'),
                      const SizedBox(height: 8),
                      const DescriptionText(
                          text:
                              'This is a description of the SheepAI application.'),
                      // ...additional widgets or content...
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Builder(
              builder: (BuildContext context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.black54,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(width: 16),
                              const Text('Loading...',
                                  style: TextStyle(color: Colors.white)),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                });
                return Container();
              },
            ),
        ],
      ),
    );
  }
}
