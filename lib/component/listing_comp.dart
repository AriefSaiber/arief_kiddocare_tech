
import 'package:arief_kiddocare_tech/constants.dart';
import 'package:arief_kiddocare_tech/provider/kindergarten_pvd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildPaginationControls(BuildContext context) {
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
                  provider.fetchKindergartens(context, page: currentPage - 1);
                },
              ),

            // Page Number Buttons
            for (int i = startPage; i <= endPage; i++)
              SizedBox(
                width: Screen.W(context) * 0.12, // Adjust as needed
                child: TextButton(
                  onPressed: () {
                    provider.fetchKindergartens(context, page: i);
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
                  provider.fetchKindergartens(context, page: currentPage + 1);
                },
              ),
          ],
        ),
      );
    },
  );
}

Container applyButton(
    {required BuildContext context, required Function()? onPressed, String? title, bool isConfirm = true}) {
  return Container(
    // height: MediaQuery.of(context).size.height * 0.07,
    width: MediaQuery.of(context).size.width,
    child: ElevatedButton(
      child: Text(
        title ?? 'Apply',
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          Constants.primaryColor,
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
      onPressed: onPressed,
    ),
  );
}
