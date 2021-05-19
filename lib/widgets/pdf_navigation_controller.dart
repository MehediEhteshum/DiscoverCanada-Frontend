import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import '../helpers/base.dart';

class PdfNavigationController extends StatelessWidget {
  const PdfNavigationController({
    Key key,
    @required PdfController pdfController,
    @required TextEditingController inputController,
    @required int allPagesCount,
  })  : _pdfController = pdfController,
        _inputController = inputController,
        _allPagesCount = allPagesCount,
        super(key: key);

  final PdfController _pdfController;
  final TextEditingController _inputController;
  final int _allPagesCount;

  @override
  Widget build(BuildContext context) {
    print("Memeory leaks? build PdfNavigationController");

    return Positioned(
      bottom: 0,
      width: screenWidth,
      child: Container(
        color: Colors.black12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const ImageIcon(
                const AssetImage("assets/images/double_up_arrow.png"),
              ),
              iconSize: 30,
              padding: const EdgeInsets.all(0),
              onPressed: () {
                _pdfController.animateToPage(
                  1,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 500),
                );
              },
            ),
            IconButton(
              icon: const ImageIcon(
                const AssetImage("assets/images/up_arrow.png"),
              ),
              iconSize: 30,
              padding: const EdgeInsets.all(0),
              onPressed: () {
                _pdfController.previousPage(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 300),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Row(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: screenWidth * 0.25),
                    child: IntrinsicWidth(
                      child: TextFormField(
                        controller: _inputController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: fontSize1,
                        ),
                        decoration: const InputDecoration(
                          border: const OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onFieldSubmitted: (page) {
                          int pageNumber = int.tryParse(page) ?? 1;
                          pageNumber = pageNumber < 1
                              ? 1
                              : pageNumber > _allPagesCount
                                  ? _allPagesCount
                                  : pageNumber;
                          _pdfController.jumpToPage(pageNumber);
                          _inputController.text =
                              "$pageNumber"; // when page is changed using input, or input == current page number
                        },
                      ),
                    ),
                  ),
                  Text(
                    ' /$_allPagesCount',
                    style: const TextStyle(fontSize: fontSize1),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const ImageIcon(
                const AssetImage("assets/images/down_arrow.png"),
              ),
              iconSize: 30,
              padding: const EdgeInsets.all(0),
              onPressed: () {
                _pdfController.nextPage(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 300),
                );
              },
            ),
            IconButton(
              icon: const ImageIcon(
                const AssetImage("assets/images/double_down_arrow.png"),
              ),
              iconSize: 30,
              padding: const EdgeInsets.all(0),
              onPressed: () {
                _pdfController.animateToPage(
                  _allPagesCount,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 500),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
