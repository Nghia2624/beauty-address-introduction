import 'package:flutter/material.dart';
import '../models/beauty_spot.dart';

class SpotCard extends StatelessWidget {
  final BeautySpot spot;
  final VoidCallback onTap;

  SpotCard({required this.spot, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Hero(
              tag: spot.name,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(spot.imagePath, width: 80, height: 80, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(spot.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(spot.services, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}