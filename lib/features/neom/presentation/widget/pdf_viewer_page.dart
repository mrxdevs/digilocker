import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class CustomPdfNetworkWidget extends StatefulWidget {
  final String url;
  const CustomPdfNetworkWidget({super.key, required this.url});

  @override
  State<CustomPdfNetworkWidget> createState() => _CustomPdfNetworkWidgetState();
}

class _CustomPdfNetworkWidgetState extends State<CustomPdfNetworkWidget> {
  String? localPath;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/temp_network_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final dio = Dio();
      final response = await dio.download(
        widget.url,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          localPath = filePath;
          loading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load PDF (status: ${response.statusCode})';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading PDF: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(child: Text(error!));
    }
    if (localPath == null) {
      return const Center(child: Text('PDF path is null'));
    }
    return PDFView(
      filePath: localPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      onError: (error) {
        setState(() {
          this.error = 'PDFView error: $error';
        });
      },
      onRender: (_pages) {
        setState(() {});
      },
      onPageError: (page, error) {
        setState(() {
          this.error = 'Error on page $page: $error';
        });
      },
    );
  }
}
