import 'package:digilocker/features/neom/presentation/widget/pdf_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:digilocker/features/neom/domain/entities/meon_user_data_details.dart';

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

                SizedBox(
                  height: 500,
                  child: CustomPdfNetworkWidget(url: userData.panImagePath),
                ),

                Image.network(userData.aadharImge),
                Image.network(userData.aadharImageFileName),
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
