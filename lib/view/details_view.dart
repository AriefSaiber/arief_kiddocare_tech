import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arief_kiddocare_tech/provider/kindergarten_pvd.dart';
import 'package:arief_kiddocare_tech/model/kindergarten_mdl.dart';

class DetailScreen extends StatefulWidget {
  final String kindergartenId;

  DetailScreen({required this.kindergartenId});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Kindergarten? _kindergarten;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKindergartenDetails();
  }

  Future<void> _fetchKindergartenDetails() async {
    final provider = Provider.of<KindergartenProvider>(context, listen: false);
    try {
      final kindergarten = await provider.fetchKindergartenDetails(widget.kindergartenId);
      setState(() {
        _kindergarten = kindergarten;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load kindergarten details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_kindergarten?.name ?? 'Kindergarten Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _kindergarten == null
              ? Center(child: Text('No details available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(_kindergarten!.imageUrl),
                      SizedBox(height: 16),
                      Text(
                        _kindergarten!.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('City: ${_kindergarten!.city}'),
                      SizedBox(height: 8),
                      Text('State: ${_kindergarten!.state}'),
                      SizedBox(height: 8),
                      Text('Contact Person: ${_kindergarten!.contactPerson}'),
                      SizedBox(height: 8),
                      Text('Contact No: ${_kindergarten!.contactNo}'),
                      SizedBox(height: 8),
                      Text('Description: ${_kindergarten!.description}'),
                    ],
                  ),
                ),
    );
  }
}
