import 'package:chatgpt_test/utils/open_ai.dart';
import 'package:chatgpt_test/widgets/chart.dart';
import 'package:chatgpt_test/widgets/title.dart';
import 'package:flutter/material.dart';
import '../widgets/table.dart';
import '../widgets/headline_with_description.dart';
import '../utils/helper.dart';
import '../widgets/url_input.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String mainTitle = 'SheepAI Prototype Application';
  String mainShortDescription = 'Please provide URL to fetch data';
  String lastUpdated = '';
  bool isLoading = false;
  List<Map<String, dynamic>> tables = [];
  String? selectedValue = 'English';
  List<Map<String, dynamic>> headlinesWithDescriptions = [];
  String imgUrl = 'https://i.ibb.co/1n0gWx0/Screenshot-3-edited.png';
  bool showImg = true;
  List<Map<String, dynamic>> charts = [];

  void fetchData(String url) async {
    setState(() {
      isLoading = true;
      showImg = true;
      // Clear previous data
      mainTitle = 'SheepAI Prototype Application';
      mainShortDescription = 'Please provide URL to fetch data';
      lastUpdated = '';
      tables = [];
      headlinesWithDescriptions = [];
    });

    int retryCount = 0;
    const int maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final data = await ChatGPTService()
            .getResponse(url: url, language: selectedValue ?? 'English');
        if (!isLoading) return; // Exit if loading was cancelled
        setState(() {
          showImg = false;
          mainTitle = data['mainTitle'];
          mainShortDescription = data['mainShortDescription'];
          lastUpdated = data['lastUpdated'];
          tables = (data['tables'] as List)
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
          charts = (data['charts'] as List)
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
          headlinesWithDescriptions =
              (data['headlinesWithDescriptions'] as List)
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList();
        });
        break; // Exit the loop if the request is successful
      } catch (e) {
        retryCount++;
        debugPrint('Error fetching data: $e. Retry $retryCount/$maxRetries');
        if (retryCount >= maxRetries) {
          if (isLoading) {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop(); // Dismiss the loading dialog
          }
        }
      }
    }

    if (isLoading) {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop(); // Dismiss the loading dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: GestureDetector(
            onTap: () => launchURL(context, 'https://www.sheepai.app/'),
            // Navigate to URL on tap
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sheep',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold, // Make the text bolder
                  ),
                ),
                const Text(
                  'AI_',
                  style: TextStyle(
                    color: Color(0xFF93E4C5), // More fluorescent green color
                    fontWeight: FontWeight.bold, // Make the text bolder
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: UrlInputField(onSubmitted: fetchData),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedValue,
                  hint: const Padding(
                    padding: EdgeInsets.only(
                        left: 8.0), // Apply left padding to the hint text
                    child: Text('English'),
                  ),
                  items: <String>['English', 'Croatian', 'Ukrainian', 'Russian', 'Spanish', 'Serbian', 'Czech', 'Hungarian', 'Chinese', 'Korean', 'Japanese'].map((String value) {
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
                  dropdownColor: Colors.grey[200],
                  // Change dropdown background color
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blue, // Change icon color
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.grey[900], // Dark grey color
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                TitleWidget(
                  showImg: showImg,
                  imgUrl: imgUrl,
                  mainTitle: mainTitle,
                  lastUpdate: lastUpdated,
                  mainShortDescription: mainShortDescription,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      for (var i = 0; i < tables.length; i++) ...[
                        if (tables[i]['columns'] != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[800],
                                borderRadius: BorderRadius.circular(12.0),
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
                                headline:
                                    tables[i]['headline'] ?? 'No Headline',
                                columns: (tables[i]['columns'] as List)
                                    .map((column) => List<String>.from(column))
                                    .toList(),
                              ),
                            ),
                          ),
                        if (i < headlinesWithDescriptions.length)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: HeadlineWithDescription(
                              mainHeadline: headlinesWithDescriptions[i]
                                  ['headline'],
                              description: headlinesWithDescriptions[i]
                                  ['description'],
                            ),
                          ),
                      ],
                      for (var i = 0; i < charts.length; i++) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ChartWidget(
                              headline: charts[i]['headline'] ?? 'No Headline',
                              data: (charts[i]['data'] as List)
                                  .map(
                                      (data) => Map<String, dynamic>.from(data))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                      /*const SizedBox(height: 20),
                      const HeadlineText(text: 'Welcome to SheepAI'),
                      const SizedBox(height: 8),
                      const DescriptionText(
                          text:
                              'This is a description of the SheepAI application.'),

                       */
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
                        insetPadding: const EdgeInsets.symmetric(
                            horizontal: 800), // Adjusted width
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
