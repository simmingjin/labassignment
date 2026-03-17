import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class PosterScreen extends StatelessWidget {
  const PosterScreen({
    super.key,
    required this.image,
    required this.suggestion,
  });

  final Uint8List image;
  final String suggestion;

  Widget buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 76, 175, 80), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(icon, title),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget buildBulletList(List items) {
    if (items.isEmpty) {
      return const Text(
        "No information available.",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black54,
          height: 1.5,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 7),
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final decoded = jsonDecode(suggestion);

    final String summary = decoded['summary'] ?? "";
    final List places = decoded['places_to_visit'] ?? [];
    final List activities = decoded['activities'] ?? [];
    final List budgetTips = decoded['budget_tips'] ?? [];
    final List travelTips = decoded['travel_tips'] ?? [];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 76, 175, 80),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Travel Poster and Suggestions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.memory(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Trip Suggestion',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Hope you have great holiday trip ahead.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 18),

            buildInfoCard(
              icon: Icons.numbers,
              title: 'Trip Summary',
              child: Text(
                summary,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),

            buildInfoCard(
              icon: Icons.numbers,
              title: 'Best Places to Visit',
              child: buildBulletList(places),
            ),

            buildInfoCard(
              icon: Icons.numbers,
              title: 'Suggested Activities',
              child: buildBulletList(activities),
            ),

            buildInfoCard(
              icon: Icons.numbers,
              title: 'Budget Tips',
              child: buildBulletList(budgetTips),
            ),

            buildInfoCard(
              icon: Icons.flight_takeoff_outlined,
              title: 'Travel Tips',
              child: buildBulletList(travelTips),
            ),
          ],
        ),
      ),
    );
  }
}