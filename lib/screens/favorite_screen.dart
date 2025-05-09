import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/beauty_spot.dart';
import '../services/auth_service.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        final favorites = auth.getFavorites();
        final favoriteSpots = beautySpots.where((spot) => favorites.contains(spot.name)).toList();

        return Scaffold(
          appBar: AppBar(title: Text('Yêu thích')),
          body: favoriteSpots.isEmpty
              ? Center(child: Text('Chưa có địa điểm yêu thích'))
              : ListView.builder(
                  itemCount: favoriteSpots.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.asset(favoriteSpots[index].imagePath, width: 50, fit: BoxFit.cover),
                      title: Text(favoriteSpots[index].name),
                      subtitle: Text(favoriteSpots[index].services),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DetailScreen(spot: favoriteSpots[index])),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}