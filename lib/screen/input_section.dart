import 'dart:convert';

import 'package:flutter/material.dart';
import '/services/image_generation_service.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'poster_screen.dart';
class InputScreen extends StatefulWidget {
  const InputScreen({super.key, required this.title});

  final String title;

  @override
  State<InputScreen> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputScreen> {
  final TextEditingController durationController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController participantsController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController traveltypeController = TextEditingController();


final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash-lite',
    generationConfig: GenerationConfig(
      temperature: 0.7,
    ),
  );

  @override
  void initState() {
    super.initState();
    budgetController.text = '2000';
  }

 Future<void> _generatePosterAndSuggestion({
  required String imagePrompt,
  required String suggestionPrompt,
}) async {
  try {
    final image = await ImageGenerationService.generateImage(imagePrompt);

    final response = await model.generateContent([
      Content.text(suggestionPrompt),
    ]);

    final suggestionRaw = response.text ?? '{}';

    final cleanJson = suggestionRaw
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    Map<String, dynamic> suggestion;
    try {
      suggestion = jsonDecode(cleanJson);
    } catch (e) {
      suggestion = {
        "summary": "Unable to generate suggestion",
        "places_to_visit": [],
        "activities": [],
        "budget_tips": [],
        "travel_tips": [],
      };
    }

    if (!mounted) return;

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PosterScreen(
          image: image,
          suggestion: jsonEncode(suggestion),
        ),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
double duration = 3;
double budget = 1000;
int participants = 1;
String selectedDestination = "Malaysia";
 String travelType = "Relax";
 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text("Duration: ${duration.toInt()} days"),
    Slider(
      min: 1,
      max: 14,
      divisions: 13,
      value: duration,
      label: duration.toInt().toString(),
      onChanged: (value) {
        setState(() {
          duration = value;
        });
      },
    ),
  ],
),
            
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text("Budget: RM ${budget.toInt()}"),
    Slider(
      min: 100,
      max: 10000,
      divisions: 99,
      value: budget,
      onChanged: (value) {
        setState(() {
          budget = value;
        });
      },
    ),
  ],
),
        

DropdownButtonFormField<String>(
  initialValue: selectedDestination,
  items: ["Malaysia", "Japan", "Korea", "Thailand"]
      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
      .toList(),
  onChanged: (value) {
    setState(() {
      selectedDestination = value!;
    });
  },
  decoration: InputDecoration(
    labelText: "Destination",
    border: OutlineInputBorder(),
  ),
),

Wrap(
  spacing: 10,
  children: ["Relax", "Adventure", "Luxury"]
      .map((type) => ChoiceChip(
            label: Text(type),
            selected: travelType == type,
            onSelected: (selected) {
              setState(() {
                travelType = type;
              });
            },
          ))
      .toList(),
),
              SizedBox(height: 16),
                SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: MaterialButton(
                  color: Colors.green,
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(child: CircularProgressIndicator()),
                    );
     final String tripDuration = '${duration.toInt()} days';
  final String travelBudget = 'RM ${budget.toInt()}';
  final String participantsStr = participants.toString();

                    final String imagePrompt =
                        "Create a professional travel poster for a trip to $selectedDestination. "
                        "The trip duration is $tripDuration, "
                        "the budget is $travelBudget, "
                        "for $participantsStr participants, "
                        "with a $travelType travel style. "
                        "Make it attractive, modern, colorful, and suitable for a travel planner app.";

                   final String suggestionPrompt = """
A user is planning a trip with the following details:
Destination: $selectedDestination
Trip Duration: $tripDuration
Budget: $travelBudget
Participants: $participantsStr
Type of Travel: $travelType

Return ONLY valid JSON.

STRICT RULES:
- Do NOT include any explanation
- Do NOT include markdown
- Do NOT include ```json
- Response MUST start with {
- Response MUST end with }

Structure:
{
  "summary": "",
  "places_to_visit": [],
  "activities": [],
  "budget_tips": [],
  "travel_tips": []
}

Use simple English.
""";
                     _generatePosterAndSuggestion(
                      imagePrompt: imagePrompt,
                      suggestionPrompt: suggestionPrompt,
                    );
                  },
                  child: const Text(
                    'Generate Travel Plan',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Center(
                child: Text(
                  'AI-generated poster + personalised travel suggestions',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}