import 'package:arief_kiddocare_tech/view/details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arief_kiddocare_tech/provider/listing_prvd.dart';
import 'package:arief_kiddocare_tech/model/listing_mdl.dart';

class ListingScreen extends StatefulWidget {
  @override
  _ListingScreenState createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<KindergartenProvider>(context, listen: false);
    provider.fetchKindergartens(); // Call fetchKindergartens in initState

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        provider.fetchKindergartens();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kindergartens'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Consumer<KindergartenProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.kindergartens.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: provider.kindergartens.length + 1,
            itemBuilder: (context, index) {
              if (index == provider.kindergartens.length) {
                return provider.isLoading ? Center(child: CircularProgressIndicator()) : SizedBox();
              }

              final kindergarten = provider.kindergartens[index];
              return ListTile(
                leading: Image.network(kindergarten.imageUrl),
                title: Text(kindergarten.name),
                subtitle: Text('${kindergarten.city}, ${kindergarten.state}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(kindergartenId: kindergarten.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
