import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:digilocker/features/neom/domain/entities/meon_user_data_details.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class MeonDigilockerAdharDetails extends StatelessWidget {
  final MeonUserDataDetails userData;

  const MeonDigilockerAdharDetails({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digilocker Details'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Aadhaar Section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: userData.aadharImge.isNotEmpty
                          ? NetworkImage(userData.aadharImge)
                          : null,
                      child: userData.aadharImge.isEmpty
                          ? const Icon(Icons.person, size: 36)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            'Aadhaar: ${userData.aadharNo}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            userData.gender,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32, thickness: 1.2),
                _infoRow('Father\'s Name', userData.fatherName),
                _infoRow('DOB', userData.dob),
                _infoRow('Address', userData.aadharAddress),
                _infoRow('District', userData.district),
                _infoRow('State', userData.state),
                _infoRow('Pincode', userData.pincode),
                const SizedBox(height: 24),

                // PAN Section
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                        image: userData.panImagePath.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(userData.panImagePath),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: userData.panImagePath.isEmpty
                          ? const Icon(Icons.credit_card, size: 32)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PAN: ${userData.panNo}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'Name on PAN: ${userData.nameOnPan}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _infoRow('Date Linked', userData.date),
                CustomPdfNetworkWidget(url: userData.panImagePath),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}

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
      final filePath = '${dir.path}/temp_network_pdf.pdf';
      final dio = Dio();
      final response = await dio.download(
        widget.url,
        filePath,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        setState(() {
          localPath = filePath;
          loading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load PDF';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading PDF';
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
    return PDFView(
      filePath: localPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
    );
  }
}
