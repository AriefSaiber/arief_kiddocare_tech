import 'package:arief_kiddocare_tech/constants.dart';
import 'package:arief_kiddocare_tech/view/details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arief_kiddocare_tech/provider/kindergarten_pvd.dart';
import 'package:arief_kiddocare_tech/model/kindergarten_mdl.dart';

class ListingScreen extends StatefulWidget {
  @override
  _ListingScreenState createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;
  String _selectedState = '';

  @override
  void initState() {
    super.initState();
    Provider.of<KindergartenProvider>(context, listen: false).fetchKindergartens();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (!_isSearchExpanded) {
        _searchController.clear();
        _selectedState = '';
        Provider.of<KindergartenProvider>(context, listen: false).fetchKindergartens();
      }
    });
  }

  // void _applyFilters() {
  //   final query = _searchController.text;
  //   final state = _selectedState;
  //   Provider.of<KindergartenProvider>(context, listen: false).fetchfilteredKindergartens(name: query, state: state);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearchExpanded ? null : Text('Kindergartens'),
        actions: [
          IconButton(
            icon: Icon(_isSearchExpanded ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  _searchController.clear();
                  _selectedState = '';
                }
              });
            },
          ),
        ],
        bottom: _isSearchExpanded
            ? PreferredSize(
                preferredSize: Size.fromHeight(Screen.H(context) * 0.25),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Search by Name
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by name...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

                      // City & State Dropdowns
                      Consumer<KindergartenProvider>(
                        builder: (context, provider, child) {
                          final states = provider.getStates();
                          return Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedState.isEmpty ? null : _selectedState,
                                  hint: Text('Filter by state'),
                                  items: states.map((state) {
                                    return DropdownMenuItem(
                                      value: state,
                                      child: Text(state),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedState = value ?? '';
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 8),

                      // Apply Button
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<KindergartenProvider>(context, listen: false)
                              .fetchFilteredKindergartens(name: _searchController.text, state: _selectedState);
                          setState(() {
                            _isSearchExpanded = false;
                          });
                        },
                        child: Text('Apply'),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<KindergartenProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.kindergartens.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: provider.kindergartens.length,
                  itemBuilder: (context, index) {
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
          ),
          _buildPaginationControls(), // Add Pagination Widget
        ],
      ),
    );
  }
}

Widget _buildPaginationControls() {
  return Consumer<KindergartenProvider>(
    builder: (context, provider, child) {
      if (provider.totalPages <= 1) return SizedBox();

      int currentPage = provider.currentPage;
      int totalPages = provider.totalPages;

      int startPage = (currentPage - 2).clamp(1, totalPages - 4);
      int endPage = (startPage + 4).clamp(5, totalPages);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous Button
            if (currentPage > 1)
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  provider.fetchKindergartens(page: currentPage - 1);
                },
              ),

            // Page Number Buttons
            for (int i = startPage; i <= endPage; i++)
              SizedBox(
                width: Screen.W(context) * 0.12, // Adjust as needed
                child: TextButton(
                  onPressed: () {
                    provider.fetchKindergartens(page: i);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove extra padding
                  ),
                  child: Text(
                    '$i',
                    style: TextStyle(
                      fontSize: 20, // Adjust font size
                      color: currentPage == i ? Colors.blue : Colors.black,
                    ),
                  ),
                ),
              ),

            // Next Button
            if (currentPage < totalPages)
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  provider.fetchKindergartens(page: currentPage + 1);
                },
              ),
          ],
        ),
      );
    },
  );
}
