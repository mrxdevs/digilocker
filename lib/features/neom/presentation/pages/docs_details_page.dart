import 'package:digilocker/core/constant/constanst.dart';
import 'package:digilocker/features/neom/data/datasources/meon_remote_datasource.dart';
import 'package:digilocker/features/neom/data/repositories/meon_repo_imp.dart'
    show MeonRepoImp;
import 'package:digilocker/features/neom/domain/usecases/fetch_user_data.dart';
import 'package:digilocker/features/neom/presentation/widget/pdf_viewer_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:digilocker/features/neom/domain/entities/meon_user_data_details.dart';
import 'package:go_router/go_router.dart';

class MeonDigilockerDocsDetails extends StatefulWidget {
  const MeonDigilockerDocsDetails({super.key});

  @override
  State<MeonDigilockerDocsDetails> createState() =>
      _MeonDigilockerDocsDetailsState();
}

class _MeonDigilockerDocsDetailsState extends State<MeonDigilockerDocsDetails> {
  MeonUserDataDetails? userData;
  bool isLoading = false;
  _fetchDocumentFromDigilocker() async {
    final dio = Dio(BaseOptions(baseUrl: "https://digilocker.meon.co.in"));
    final datasource = MeonRemoteDatasourceImp(dio);
    final meonRepo = MeonRepoImp(datasource);

    //Local veriable

    if (meonAccessDetails == null) {
      debugPrint("Error: Seems Access credential is Null");
      return;
    }
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    //Fetch document details
    MeonUserDataDetails? meonUserData = await FetchUserData(
      meonRepo,
    ).call(meonAccessDetails!);

    if (mounted) {
      setState(() {
        userData = meonUserData;
        isLoading = false;
      });
    }

    if (meonUserData == null) {
      debugPrint("Error on fetch user data: Received null");

      return;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_timer) {
      _fetchDocumentFromDigilocker();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digilocker Details'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userData != null) ...[
                  // Aadhaar Section
                  if (userData?.aadharNo.isEmpty ?? false)
                    Center(
                      child: Text(
                        "Not autherized with Digilocker",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.deepPurple.shade100,
                        backgroundImage:
                            userData?.aadharImageFileName.isNotEmpty ?? false
                            ? NetworkImage(userData?.aadharImageFileName ?? "")
                            : null,
                        child: userData?.aadharImge.isEmpty ?? false
                            ? const Icon(
                                Icons.person,
                                size: 38,
                                color: Colors.deepPurple,
                              )
                            : null,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData?.name ?? "",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.credit_card,
                                  color: Colors.indigo,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Aadhaar: ${userData?.aadharNo ?? ""}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              userData?.gender ?? "",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32, thickness: 1.2),
                  _infoRow('Father\'s Name', userData?.fatherName ?? ""),
                  _infoRow('DOB', userData?.dob ?? ""),
                  _infoRow('Address', userData?.aadharAddress ?? ""),
                  _infoRow('District', userData?.district ?? ""),
                  _infoRow('State', userData?.state ?? ""),
                  _infoRow('Pincode', userData?.pincode ?? ""),
                  const SizedBox(height: 28),
                  Text(
                    'PAN Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.indigo.shade50,
                        ),
                        child: const Icon(
                          Icons.credit_card,
                          size: 32,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PAN: ${userData?.panNo ?? ""}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Name on PAN: ${userData?.nameOnPan ?? ""}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _infoRow('Date Linked', userData?.date ?? ""),
                  const SizedBox(height: 18),
                  Text(
                    'Driving License',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  (userData?.dlFile.isNotEmpty ?? false) &&
                          (userData?.dlFile.endsWith(".pdf") ?? false)
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.indigo,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 500,
                              child: CustomPdfNetworkWidget(
                                url: userData?.dlFile ?? "",
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.indigo,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SizedBox(
                            height: 300,
                            width: 300,
                            child: Center(
                              child: Text(
                                "No DL found",
                                style: TextStyle(color: Colors.indigo),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 18),
                  Text(
                    'Aadhaar Images',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (userData?.aadharImge.isNotEmpty ?? false)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.indigo,
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: userData!.aadharImge.endsWith(".jpg")
                            ? Image.network(userData?.aadharImge ?? "")
                            : SizedBox(
                                height: 100,
                                width: 300,
                                child: Center(child: Text(" No Image found")),
                              ),
                      ),
                    ),

                  if ((userData?.aadharImageFileName.isNotEmpty ?? false))
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.indigo,
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: userData!.aadharImageFileName.endsWith(".jpg")
                            ? Image.network(userData?.aadharImageFileName ?? "")
                            : SizedBox(
                                height: 100,
                                width: 300,
                                child: Center(child: Text(" No Image found")),
                              ),
                      ),
                    ),
                  const SizedBox(height: 18),
                  Text(
                    'PAN Document',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if ((userData?.panImagePath.isNotEmpty ?? false) &&
                      (userData?.panImagePath.endsWith(".pdf") ?? false))
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.indigo,
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 500,
                          child: CustomPdfNetworkWidget(
                            url: userData?.panImagePath ?? "",
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.indigo,
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        height: 300,
                        width: 300,
                        child: Center(
                          child: Text(
                            "No Pan found",
                            style: TextStyle(color: Colors.indigo),
                          ),
                        ),
                      ),
                    ),
                ] else ...[
                  if (meonAccessDetails == null)
                    Center(
                      child: Text(
                        "No Access found",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (userData == null && isLoading)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  if (userData == null && !isLoading)
                    Center(
                      child: Text(
                        "No Data found",
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      label: const Text("Go back"),
                    ),
                  ),
                ],
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
