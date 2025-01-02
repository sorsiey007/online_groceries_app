import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_groceries_app/Widget/BackgroundWidget.dart';
import 'package:online_groceries_app/Widget/custom_elevated_button.dart';
import 'package:online_groceries_app/themes/app_theme.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({super.key});

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  // Location data
  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  List<dynamic> communes = [];
  List<dynamic> villages = [];

  // Selected dropdown values
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedCommune;
  String? selectedVillage;

  @override
  void initState() {
    super.initState();
    _loadLocationData();
  }

  Future<void> _loadLocationData() async {
    try {
      final provinceData =
          await rootBundle.loadString('assets/location/province.json');
      final districtData =
          await rootBundle.loadString('assets/location/district.json');
      final communeData =
          await rootBundle.loadString('assets/location/commune.json');
      final villageData =
          await rootBundle.loadString('assets/location/village.json');

      setState(() {
        provinces = json.decode(provinceData);
        districts = json.decode(districtData);
        communes = json.decode(communeData);
        villages = json.decode(villageData);
      });
    } catch (e) {
      // Handle errors in data loading
      print('Error loading location data: $e');
    }
  }

  List<dynamic> _filterList(List<dynamic> list, String? key, String field) {
    if (key == null) return [];
    return list.where((item) => item['properties'][field] == key).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyAppTheme.primaryColor,
      body: Stack(
        children: [
          const BackgroundWidget(
            imagePath: 'assets/images/png/groceries.png',
            imageWidth: 600,
            imageHeight: 600,
            blurSigmaX: 3.0,
            blurSigmaY: 3.0,
            overlayColor: MyAppTheme.primaryColor,
            overlayOpacity: 0.85,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/svg/logo_color.svg',
                      height: screenWidth * 0.2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Set Your Location',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: MyAppTheme.backgroundColor,
                      fontFamily: 'KantumruyPro',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please select your location!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: MyAppTheme.borderColor12,
                      fontFamily: 'KantumruyPro',
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDropdown(
                    label: 'Select Province',
                    value: selectedProvince,
                    items: provinces
                        .map((province) => DropdownMenuItem<String>(
                              value: province['properties']['ADMIN_ID1'],
                              child: Text(
                                province['properties']['NAME_ENG1'],
                                style:
                                    const TextStyle(fontFamily: 'KantumruyPro'),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProvince = value;
                        selectedDistrict = null;
                        selectedCommune = null;
                        selectedVillage = null;
                      });
                    },
                  ),
                  _buildDropdown(
                    label: 'Select District',
                    value: selectedDistrict,
                    items: _filterList(districts, selectedProvince, 'ADMIN_ID1')
                        .map((district) => DropdownMenuItem<String>(
                              value: district['properties']['ADMIN_ID2'],
                              child: Text(
                                district['properties']['NAME_ENG2'],
                                style:
                                    const TextStyle(fontFamily: 'KantumruyPro'),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDistrict = value;
                        selectedCommune = null;
                        selectedVillage = null;
                      });
                    },
                  ),
                  _buildDropdown(
                    label: 'Select Commune',
                    value: selectedCommune,
                    items: _filterList(communes, selectedDistrict, 'ADMIN_ID2')
                        .map((commune) => DropdownMenuItem<String>(
                              value: commune['properties']['ADMIN_ID3'],
                              child: Text(
                                commune['properties']['NAME_ENG3'],
                                style:
                                    const TextStyle(fontFamily: 'KantumruyPro'),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCommune = value;
                        selectedVillage = null;
                      });
                    },
                  ),
                  _buildDropdown(
                    label: 'Select Village',
                    value: selectedVillage,
                    items: _filterList(villages, selectedCommune, 'ADMIN_ID3')
                        .map((village) => DropdownMenuItem<String>(
                              value: village['properties']['ADMIN_ID'],
                              child: Text(
                                village['properties']['NAME_ENG'],
                                style:
                                    const TextStyle(fontFamily: 'KantumruyPro'),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVillage = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: value,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
        ),
        iconEnabledColor: MyAppTheme.mainColor,
        iconDisabledColor: MyAppTheme.borderColor12,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: 'KantumruyPro',
            fontSize: 16,
            color: MyAppTheme.borderColor12,
          ),
          filled: true,
          fillColor: const Color.fromARGB(0, 255, 255, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
