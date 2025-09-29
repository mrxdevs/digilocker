import 'package:digilocker/core/constant/constanst.dart';
import 'package:digilocker/core/secerate/.env.dart';
import 'package:digilocker/features/neom/data/datasources/meon_remote_datasource.dart';
import 'package:digilocker/features/neom/data/repositories/meon_repo_imp.dart';
import 'package:digilocker/features/neom/domain/entities/meon_access_details.dart';
import 'package:digilocker/features/neom/domain/entities/meon_user_data_details.dart';
import 'package:digilocker/features/neom/domain/usecases/fetch_user_data.dart';
import 'package:digilocker/features/neom/domain/usecases/get_access_details.dart';
import 'package:digilocker/features/neom/domain/usecases/get_digilocker_url.dart';
import 'package:digilocker/features/neom/domain/usecases/get_license_digilocker_url.dart';
import 'package:digilocker/features/neom/domain/usecases/open_web_url.dart';
import 'package:digilocker/features/neom/presentation/pages/digilocker_details_page.dart';
import 'package:digilocker/features/neom/presentation/pages/docs_details_page.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NeomMainPage extends StatefulWidget {
  const NeomMainPage({super.key});

  @override
  State<NeomMainPage> createState() => _NeomMainPageState();
}

class _NeomMainPageState extends State<NeomMainPage> {
  final _pannoController = TextEditingController();
  final _nameOnPan = TextEditingController();
  bool _isShowPanUI = false;
  bool _isWebOpened = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Neom Main Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FetchButton(
              label: 'View Document',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeonDigilockerDocsDetails(),
                  ),
                );
              },
            ),
            FetchButton(
              label: "Fetch Driving License Card ",
              onPressed: _fetchLicense,
            ),
            const SizedBox(height: 20),

            if (!_isShowPanUI)
              FetchButton(label: 'Fetch Aadhar && Pan', onPressed: _fetchAdhar),
            if (_isShowPanUI)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter PAN Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _pannoController,
                    decoration: const InputDecoration(
                      labelText: 'PAN Number',

                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Handle PAN number input
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameOnPan,
                    decoration: const InputDecoration(
                      labelText: 'Name as per PAN card',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Handle PAN name input
                    },
                  ),
                ],
              ),

            const SizedBox(height: 20),
            if (_isShowPanUI)
              FetchButton(
                label: _isWebOpened
                    ? "Fetch details after Authentication"
                    : 'Initiate Authentication',
                onPressed: _fetchAdhar,
              ),
          ],
        ),
      ),
    );
  }

  void _fetchAdhar() async {
    final dio = Dio(BaseOptions(baseUrl: "https://digilocker.meon.co.in"));
    final datasource = MeonRemoteDatasourceImp(dio);
    final meonRepo = MeonRepoImp(datasource);

    // Fetch aadhar Details
    MeonAccessDetails? accessDetails;
    debugPrint(
      "Check Default/Precall access details: ${meonAccessDetails.toString()}",
    );

    //If alredy have access data then assign instead of making another call
    if (meonAccessDetails == null) {
      accessDetails = await GetAccessDetails(meonRepo).call();
    } else {
      accessDetails = meonAccessDetails;
    }
    meonAccessDetails = accessDetails;

    if (accessDetails == null) {
      debugPrint("Error on fetching Access details: Received null");
      return;
    }

    //Fetch document details
    MeonUserDataDetails? meonUserData = await FetchUserData(
      meonRepo,
    ).call(accessDetails);

    if (meonUserData == null) {
      debugPrint("Error on fetch user data: Received null");

      return;
    }

    if (meonUserData.aadharNo.isEmpty && meonUserData.panNo.isEmpty) {
      debugPrint("Found no data, Initiating authentication again");

      //If Pan ui is not visible make it visible and return
      if (mounted && !_isShowPanUI) {
        setState(() {
          _isShowPanUI = true;
        });
        return;
      }

      //Validate pan name and number
      if (_nameOnPan.text.trim().isEmpty ||
          _pannoController.text.trim().isEmpty) {
        debugPrint(
          "Pan No :${_pannoController.text} or Name on pan: ${_nameOnPan.text} have issue",
        );
        return;
      }

      //Get Digilocker URL
      String? url = await GetDigilockerUrl(meonRepo).call(
        _nameOnPan.text.trim(),
        _pannoController.text.trim(),
        accessDetails.accessToken,
      );

      //Validate the Digilocker URL
      if (url == null) {
        debugPrint("Error: Received null digilocker URL");
        return;
      }

      //Open web with url
      if (mounted) {
        setState(() {
          _isWebOpened = true;
        });
      }
      OpenWebUrl(meonRepo).call(url);
    } else {
      if (mounted && _isShowPanUI) {
        setState(() {
          _isShowPanUI = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MeonDigilockerAdharDetails(userData: meonUserData),
          ),
        );
      }
    }
  }

  void _fetchLicense() async {
    //Generate Client Token and State
    final dio = Dio(BaseOptions(baseUrl: "https://digilocker.meon.co.in"));
    final datasource = MeonRemoteDatasourceImp(dio);
    final meonRepo = MeonRepoImp(datasource);

    // Fetch aadhar Details
    MeonAccessDetails? accessDetails;
    debugPrint(
      "Check Default/Precall access details: ${meonAccessDetails.toString()}",
    );

    //If alredy have access data then assign instead of making another call
    if (meonAccessDetails == null) {
      accessDetails = await GetAccessDetails(meonRepo).call();
    } else {
      accessDetails = meonAccessDetails;
    }
    meonAccessDetails = accessDetails;

    if (accessDetails == null) {
      debugPrint("Error on fetching Access details: Received null");
      return;
    }

    final _dlController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Driving License Number',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dlController,

              decoration: const InputDecoration(
                labelText: 'DL Number',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Handle DL number input
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  //Validate DL no

                  if (_dlController.text.trim().length < 6) {
                    debugPrint(
                      "Error: DL number is invalid :${_dlController.text} ",
                    );
                    return;
                  }
                  final String? url = await GetLicenseDigilockerUrl(meonRepo)
                      .call(
                        _dlController.text.trim(),
                        meonAccessDetails!.accessToken,
                        meonOrgId,
                      );

                  //Validate the Digilocker URL
                  if (url == null) {
                    debugPrint("Error: Received null digilocker URL");
                    return;
                  }

                  //Open web with url
                  if (mounted) {
                    setState(() {
                      _isWebOpened = true;
                    });
                  }
                  OpenWebUrl(meonRepo).call(url);

                  //Fetch document details
                  MeonUserDataDetails? meonUserData = await FetchUserData(
                    meonRepo,
                  ).call(accessDetails!);

                  if (meonUserData == null) {
                    debugPrint("Error on fetch user data: Received null");

                    return;
                  }

                  //Fetch Document after success full authentication
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MeonDigilockerAdharDetails(userData: meonUserData),
                    ),
                  );
                },
                child: const Text('Fetch from Digilocker'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FetchButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const FetchButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}
