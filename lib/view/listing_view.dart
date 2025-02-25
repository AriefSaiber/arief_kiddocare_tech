import 'package:arief_kiddocare_tech/component/listing_comp.dart';
import 'package:arief_kiddocare_tech/constants.dart';
import 'package:arief_kiddocare_tech/services/kindergarten_svc.dart';
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
    Provider.of<KindergartenProvider>(context, listen: false).fetchKindergartens(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
        //============================Expanded Filter============================
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

                      // State Dropdowns
                      Consumer<KindergartenProvider>(
                        builder: (context, provider, child) {
                          final states = provider.stateList;
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
                      applyButton(
                        context: context,
                        onPressed: () async {
                          final provider = Provider.of<KindergartenProvider>(context, listen: false);
                          if (_searchController.text.isEmpty &&
                              (_selectedState.isEmpty || _selectedState == 'All States')) {
                            await provider.fetchKindergartens(context);
                            setState(() {
                              provider.isSearch = false;
                              _isSearchExpanded = false;
                            });
                          } else {
                            await provider.fetchFilteredKindergartens(context,
                                name: _searchController.text, state: _selectedState);
                            setState(() {
                              provider.isSearch = true;
                              _isSearchExpanded = false;
                            });
                          }
                        },
                      )
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
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (provider.kindergartens.isEmpty) {
                  return Center(child: Text('No kindergartens found'));
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
          if (!Provider.of<KindergartenProvider>(context, listen: false).isSearch) buildPaginationControls(context),
        ],
      ),
    );
  }
}
