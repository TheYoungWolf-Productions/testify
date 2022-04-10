import 'package:flutter/material.dart';

class SearchListExample extends StatefulWidget {
  @override
  _SearchListExampleState createState() => new _SearchListExampleState();
}

class _SearchListExampleState extends State<SearchListExample> with SingleTickerProviderStateMixin {

  final bloodLabValues = [
    {"title": 'Alanine aminotransferase (ALT), serum',  "value": '8-40 U/L', "siValue": '8-40 U/L',
      "subtitle": [{"title": '', "value": ''}]
    },
    {"title": 'Alkaline phosphatase, serum ', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Male', "value": '30-100 U/L', "siValue": '30-100 U/L'},
        {"title": 'Female', "value": '45-115 U/L', "siValue": '45-115 U/L'},
      ]
    },
    {"title": 'Amylase, serum', "value": '25-125 U/L', "subtitle": [], "siValue": '25-125 U/L' },
    {"title": 'Aspartate aminotransferase (AST), serum', "value": '8-40 U/L', "subtitle": [], "siValue": '8-40 U/L'},
    {"title": 'Bilirubin, serum (adult)' , "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Total', "value": '0.1-1.0 mg/dL', "siValue": '2-17 μmol/L'},
        {"title": 'Direct', "value": '0.0-0.3 mg/dL', "siValue": '0.0-0.05 μmol/L'},
      ]
    },
    {"title": 'Calcium, serum (total)', "value": '8.4-10.2 mg/dL', "subtitle": [], "siValue": '2.1-2.8 mmol/L'},
    {"title": 'Cholesterol, serum' , "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Total', "value": '150-240 mg/dL', "siValue": '3.9-6.2 mmol/L'},
        {"title": 'HDL', "value": '0-70 mg/dL', "siValue": '0.8-1.8 mmol/L'},
        {"title": 'LDL', "value": '<160 mg/dL', "siValue": '<4.2 mmol/L'},
      ]
    },
    {"title": 'Cortisol, serum', "value": '', "siValue": '',
      "subtitle": [
        {"title": '0800 h', "value": '5-23 μg/dL', "siValue": '138-635 nmol/L'},
        {"title": '1600 h', "value": '3-15 μg/dL', "siValue": '82-413 nmol/L'},
        {"title": '2000 h', "value": '50% of 0800 h', "siValue": 'Fraction of 0800 h: ≤0.50'},
      ]
    },
    {"title": 'Creatine kinase, serum', "value": '', "siValue": 'L',
      "subtitle": [
        {"title": 'Male', "value": '25-90 U/L', "siValue": '25-90 U/L'},
        {"title": 'Female', "value": '10-70 U/L', "siValue": '10-70 U/L'},
      ]
    },
    {"title": 'Creatinine, serum', "value": '0.6-1.2 mg/dL', "subtitle": [], "siValue": '53-106 μmol/L'},
    {"title": 'Electrolytes, serum', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Sodium (Na+)', "value": '136-145 mEq/L', "siValue": '136-145 mEq/L'},
        {"title": 'Potassium (K+)', "value": '3.5-5.0 mEq/L', "siValue": '95-105 mmol/L'},
        {"title": 'Chloride (Cl-)', "value": '95-105 mEq/L', "siValue": '3.5-5.0 mmol/L'},
        {"title": 'Bicarbonate (HCO3-)', "value": '22-28 mEq/L', "siValue": '22-28 mEq/L'},
        {"title": 'Magnesium (Mg2+)', "value": '1.5-2.0 mEq/L', "siValue": '0.75-1.0 mmol/L'},
      ]
    },
    {"title": 'Estriol, total, serum (in pregnancy)', "value": '', "siValue": '',
      "subtitle": [
        {"title": '24-28 wks', "value": '30-170 ng/mL', "siValue": '104-590 nmol/L'},
        {"title": '28-32 wks', "value": '40-220 ng/mL', "siValue": '140-760 nmol/L'},
        {"title": '32-36 wks', "value": '60-280 ng/mL', "siValue": '208-970 nmol/L'},
        {"title": '36-40 wks', "value": '80-350 ng/mL', "siValue": '280-1210 nmol/L'},
      ]
    },

    {"title": 'Ferritin, serum', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Male', "value": '15-200 ng/mL', "siValue": '15-200 ng/mL'},
        {"title": 'Female', "value": '12-150 ng/mL', "siValue": '12-150 ng/mL'},
      ]
    },
    {"title": 'Follicle-stimulating hormone, serum/plasma', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Male', "value": '4-25 mIU/mL', "siValue": '4-25 mIU/mL'},
        {"title": 'Female', "value": '', "siValue": ''},
        {"title": 'premenopause', "value": '4-30 mIU/mL', "siValue": '4-30 mIU/mL'},
        {"title": 'midcycle peak', "value": '10-90 mIU/mLL', "siValue": '10-90 mIU/mLL'},
        {"title": 'postmenopause', "value": '40-250 mIU/mL', "siValue": '40-250 mIU/mL'},
      ]
    },
    {"title": 'Gases, arterial blood (room air)', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'pH', "value": '7.35-7.45', "siValue": '[H+] 36-44 nmol/L'},
        {"title": 'Pco2', "value": '33-45 mm Hg', "siValue": '4.4-5.9 kPa'},
        {"title": 'Po2', "value": '75-105 mm Hg', "siValue": '10.0-14.0 kPa'},
      ]
    },
    {"title": 'Glucose, serum', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Fasting', "value": '70-110 mg/dL', "siValue": '3.8-6.1 mmol/L'},
        {"title": '2-h postprandial', "value": '<120 mg/dL', "siValue": '<6.6 mmol/L'},
      ]
    },
    {"title": 'Growth hormone- arginine stimulation', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Fasting', "value": '<5 ng/mL', "siValue": '<5 ng/mL'},
        {"title": 'Provocative stimuli', "value": '>7 ng/mL', "siValue": '>7 μg/L'},
      ]
    },
    {"title": 'Immunoglobulins, serum', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'IgA', "value": '76-390 mg/dL', "siValue": '0.76-3.90 g/L'},
        {"title": 'IgE', "value": '0-380 IU/mL', "siValue": '0-380 kIU/L'},
        {"title": 'IgG', "value": '650-1,500 mg/dL', "siValue": '6.5-15 g/L'},
        {"title": 'IgM', "value": '40-345 mg/dL', "siValue": '0.4-3.45 g/L'},
      ]
    },
    {"title": 'Iron', "value": '50-170 μg/dL', "subtitle": [], "siValue": '9-30 μmol/LL'},
    {"title": 'Lactate dehydrogenase, serum', "value": '45-90 U/L (100-250 IU/L)', "siValue": '45-90 U/L (100-250 IU/L)',
      "subtitle": []
    },
    {"title": 'Luteinizing hormone, serum/plasma', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Male', "value": '6-23 mIU/mL', "siValue": '6-23 U/L'},
        {"title": 'Female', "value": '', "siValue": ''},
        {"title": 'follicular phase', "value": '5-30 mIU/mL', "siValue": '5-30 U/L'},
        {"title": 'midcycle', "value": '75-150 mIU/mL', "siValue": '75-150 U/L'},
        {"title": 'postmenopause', "value": '30-200 mIU/mL', "siValue": '30-200 U/L'},
      ]
    },
    {"title": 'Osmolality, serum', "value": '275-295 mOsmol/kg H2O', "siValue": '275-295 mOsmol/kg H2O',
      "subtitle": []
    },
    {"title": 'Parathyroid hormone, serum, N-terminal', "value": '10-65 pg/mL', "siValue": '10-65 pg/mL',
      "subtitle": []
    },
    {"title": 'Phosphate (alkaline), serum (p-NPP at 30° C)', "value": '20-70 U/L', "siValue": '20-70 U/L',
      "subtitle": []
    },
    {"title": 'Phosphorus (inorganic), serum', "value": '3.0-4.5 mg/dL', "siValue": '1.0-1.5 mmol/L',
      "subtitle": []
    },

    {"title": 'Prolactin, serum (hPRL)  ', "value": '<20 ng/mL', "siValue": '<20 ng/mL',
      "subtitle": []
    },
    {"title": 'Proteins, serum', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Total (recumbent)', "value": '6.0-7.8 g/dL', "siValue": '60-78 g/L'},
        {"title": 'Albumin', "value": '3.5-5.5 g/dL', "siValue": '35-55 g/L'},
        {"title": 'Globulin', "value": '2.3-3.5 g/dL', "siValue": '23-35 g/L'},
      ]
    },
    {"title": 'Thyroid-stimulating hormone (TSH), serum', "value": '0.5-5.0 μU/mL', "siValue": '0.5-5.0 μU/mL',
      "subtitle": []
    },
    {"title": 'Thyroidal iodine (123I) uptake', "value": '8%-30% of administered dose/24 h',  "siValue": '0.08-0.30 fraction of administered dose/24 h',
      "subtitle": []
    },
    {"title": 'Thyroxine (T4), serum', "value": '5-12 μg/dL', "siValue": '64-155 nmol/L',
      "subtitle": []
    },
    {"title": 'Triglycerides, serum', "value": '35-160 mg/dL', "siValue": '0.4-1.81 mmol/L',
      "subtitle": []
    },
    {"title": 'Triiodothyronine (T3), serum (RIA)', "value": '115-190 ng/dL', "siValue": '1.8-2.9 nmol/L',
      "subtitle": []
    },
    {"title": 'Triiodothyronine (T3) resin uptake', "value": '25%-35%', "siValue": '0.25-0.35',
      "subtitle": []
    },
    {"title": 'Urea nitrogen, serum (BUN)', "value": '7-18 mg/dL', "siValue": '1.2-3.0 mmol/L',
      "subtitle": []
    },
    {"title": 'Uric acid, serum', "value": '3.0-8.2 mg/dL', "siValue": '0.18-0.48 mmol/L',
      "subtitle": []
    },

  ];
  final HematologicLabValues = [
    {"title": 'Bleeding time (template)', "value": '2-7 minutes', "siValue": '2-7 minutes',
      "subtitle": []
    },
    {"title": 'CD4+ T-lymphocyte count', "value": '>500 mm^3', "siValue": '>500 x 106/L',
      "subtitle": []
    },
    {"title": 'Erythrocyte count', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Male', "value": '4.3-5.9 million/mm^3', "siValue": '4.3-5.9 x 10^12/L'},
        {"title": 'Female', "value": '3.5-5.5 million/mm^3', "siValue": '3.5-5.5 x 10^12/L'},
      ]
    },
    {"title": 'Erythrocyte sedimentation rate (Westergren)', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Male', "value": '0-15 mm/h', "siValue": '0-15 mm/h'},
        {"title": 'Female', "value": '0-20 mm/h', "siValue": '0-20 mm/h'},
      ]
    },
    {"title": 'Hematocrit', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Male', "value": '41%-53%', "siValue": '0.41-0.53'},
        {"title": 'Female', "value": '36%-46%', "siValue": '0.36-0.46'},
      ]
    },
    {"title": 'Hemoglobin A1c', "value": '≤6%', "siValue": '≤0.06',
      "subtitle": []
    },
    {"title": 'Hemoglobin, blood', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Male', "value": '13.5-17.5 g/dL', "siValue": '2.09-2.71 mmol/L'},
        {"title": 'Female', "value": '12.0-16.0 g/dL', "siValue": '1.86-2.48 mmol/L'},
      ]
    },
    {"title": 'Leukocyte count and differential', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Leukocyte count', "value": '4,500-11,000/mm^3', "siValue": '4.5-11.0 x 10^9/L'},
        {"title": 'Neutrophils, segmented', "value": '54%-62%',  "siValue": '0.54-0.62'},
        {"title": 'Neutrophils, banded', "value": '3%-5%', "siValue": '0.03-0.05'},
        {"title": 'Eosinophils', "value": '1%-3%', "siValue": '0.01-0.03'},
        {"title": 'Basophils', "value": '0%-0.75%', "siValue": '0-0.0075'},
        {"title": 'Lymphocytes', "value": '25%-33%', "siValue": '0.25-0.33'},
        {"title": 'Monocytes', "value": '3%-7%', "siValue": '0.03-0.07'},
      ]
    },
    {"title": 'Mean corpuscular hemoglobin (MCH)', "value": '25.4-34.6 pg/cell', "siValue": '0.39-0.54 fmol/cell',
      "subtitle": []
    },
    {"title": 'Mean corpuscular hemoglobin concentration (MCHC)', "value": '31%-36% Hb/cell', "siValue": '4.81-5.58 mmol Hb/L',
      "subtitle": []
    },
    {"title": 'Mean corpuscular volume (MCV)', "value": '80-100 μm3', "siValue": '80-100 fL',
      "subtitle": []
    },
    {"title": 'Partial thromboplastin time (activated)', "value": '25-40 seconds', "siValue": '25-40 seconds',
      "subtitle": []
    },
    {"title": 'Platelet count', "value": '150,000-400,000/mm^3', "siValue": '150-400 x 10^9/L',
      "subtitle": []
    },
    {"title": 'Prothrombin time', "value": '11-15 seconds', "siValue": '11-15 seconds',
      "subtitle": []
    },
    {"title": 'Reticulocyte count', "value": '0.5%-1.5% of red cells', "siValue": '0.005-0.015 fraction of red cells',
      "subtitle": []
    },
    {"title": 'Thrombin time', "value": '<2 seconds deviation from control', "siValue": '<2 seconds deviation from control',
      "subtitle": []
    },
    {"title": 'Volume', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Plasma', "value": '', "siValue": ''},
        {"title": 'Male', "value": '25-43 mL/kg', "siValue": '0.005-0.015 fraction of red cells' },
        {"title": 'Female', "value": '28-45 mL/kg', "siValue": '0.028-0.045 L/kg'},
        {"title": 'Red cell', "value": '', "siValue": ''},
        {"title": 'Male', "value": '20-36 mL/kg', "siValue": '0.020-0.036 L/kg'},
        {"title": 'Female', "value": '19-31 mL/kg', "siValue": '0.019-0.031 L/kg'},
      ]
    },


  ];
  final CerebrospinalLabValues = [
    {"title": 'Cell count', "value": '0-5/mm^3', "siValue": '0-5 x 10^6/L',
      "subtitle": []
    },
    {"title": 'Chloride', "value": '118-132 mEq/L', "siValue": '118-132 mmol/L',
      "subtitle": []
    },
    {"title": 'Gamma globulin', "value": '3%-12% of total proteins', "siValue": '0.03-0.12 of total proteins',
      "subtitle": []
    },
    {"title": 'Glucose', "value": '40-70 mg/dL', "siValue": '2.2-3.9 mmol/L',
      "subtitle": []
    },
    {"title": 'Pressure', "value": '70-180 mm H2O', "siValue": '70-180 mm H2O',
      "subtitle": []
    },
    {"title": 'Proteins, total', "value": '<40 mg/dL', "siValue": '<0.40 g/L',
      "subtitle": []
    },
  ];
  final sweatLabValues = [
    {"title": 'Calcium', "value": '100-300 mg/24 h', "siValue": '2.5-7.5 mmol/24 h',
      "subtitle": []
    },
    {"title": 'Chloride', "value": '1Varies with intake', "siValue": '1Varies with intake',
      "subtitle": []
    },
    {"title": 'Creatine clearance', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Male', "value": '97-137 mL/min', "siValue": '1.62-2.29 mL/s'},
        {"title": 'Female', "value": '88-128 mL/min', "siValue": '1.47-2.14 mL/s'},
      ]
    },
    {"title": 'Estriol, total (in pregnancy)', "value": '', "siValue": '',
      "subtitle": [
        {"title": '30 wks', "value": '6-18 mg/24 h', "siValue": '21-62 μmol/24 h'},
        {"title": '35 wks', "value": '9-28 mg/24 h', "siValue": '31-97 μmol/24 h'},
        {"title": '40 wks', "value": '13-42 mg/24 h', "siValue": '45-146 μmol/24 h'},
      ]
    },
    {"title": '17-hydroxycorticosteroids', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Male', "value": '3.0-10.0 mg/24 h', "siValue": '8.2-27.6 μmol/24 h'},
        {"title": 'Female', "value": '2.0-8.0 mg/24 h', "siValue": '5.5-22.0 μmol/24 h'},
      ]
    },
    {"title": '17-ketosteroids, total', "value": '', "siValue": '',
      "subtitle": [
        {"title": 'Male', "value": '8-20 mg/24 h', "siValue": '28-70 μmol/24 h'},
        {"title": 'Female', "value": '6-15 mg/24 h', "siValue": '21-52 μmol/24 h'},
      ]
    },
    {"title": 'Osmolality', "value": '50-1,400 mOsmol/kg H2O', "siValue": '50-1,400 mmol/kg',
      "subtitle": []
    },
    {"title": 'Oxalate', "value": '8-40 μg/mL', "siValue": '90-445 μmol/L',
      "subtitle": []
    },
    {"title": 'Proteins, total', "value": '<150 mg/24 h', "siValue": '<0.15 g/24 h',
      "subtitle": []
    },
    {"title": 'Sodium, total', "value": 'varies with diet', "siValue": 'varies with diet',
      "subtitle": []
    },
    {"title": 'Uric acid', "value": 'varies with diet', "siValue": 'varies with diet',
      "subtitle": []
    },
    {"title": 'Body Mass Index (Adult)', "value": '19-25 kg/m^2', "siValue": '19-25 kg/m^2',
      "subtitle": []
    },
  ];



  Widget appBarTitle = new Text(
    "Search Values",
    style: new TextStyle(color: Colors.white),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  List<String> _list = []; //  = ["Indian rupee", "United States dollar", "Australian dollar", "Euro", "British pound", "Yemeni rial", "Japanese yen", "Hong Kong dollar"];
  bool _isSearching = false;
  String _searchText = "";
  List<String> searchresult = [];
  bool _siValues = false;
  late TabController _tabController;

  var bloodLabValuesData = {
    "title" : <String>[],
    "value" : <String>[],
    "siValue" : <String>[]
  };
  var HematologicLabValuesData = {
    "title" : <String>[],
    "value" : <String>[],
    "siValue" : <String>[]
  };
  var CerebrospinalLabValuesData = {
    "title" : <String>[],
    "value" : <String>[],
    "siValue" : <String>[]
  };
  var sweatLabValuesData = {
    "title" : <String>[],
    "value" : <String>[],
    "siValue" : <String>[]
  };

  var LabValuesList = {
    "title" : <String>[],
    "value" : <String>[],
    "siValue" : <String>[]
  };

  categorizebloodLabValues() {
    for(int i = 0; i<bloodLabValues.length; i++) {
      setState(() {
        bloodLabValuesData["title"]!.add(bloodLabValues[i]["title"].toString());
        bloodLabValuesData["value"]!.add(bloodLabValues[i]["value"].toString());
        bloodLabValuesData["siValue"]!.add(bloodLabValues[i]["siValue"].toString());
        //_list.add(bloodLabValues[i]["title"].toString());
      });
    }
    for(int i = 0; i<HematologicLabValues.length; i++) {
      setState(() {
        HematologicLabValuesData["title"]!.add(HematologicLabValues[i]["title"].toString());
        HematologicLabValuesData["value"]!.add(HematologicLabValues[i]["value"].toString());
        HematologicLabValuesData["siValue"]!.add(HematologicLabValues[i]["siValue"].toString());
      });
    }
    for(int i = 0; i<CerebrospinalLabValues.length; i++) {
      setState(() {
        CerebrospinalLabValuesData["title"]!.add(CerebrospinalLabValues[i]["title"].toString());
        CerebrospinalLabValuesData["value"]!.add(CerebrospinalLabValues[i]["value"].toString());
        CerebrospinalLabValuesData["siValue"]!.add(CerebrospinalLabValues[i]["siValue"].toString());
      });
    }
    for(int i = 0; i<sweatLabValues.length; i++) {
      setState(() {
        sweatLabValuesData["title"]!.add(sweatLabValues[i]["title"].toString());
        sweatLabValuesData["value"]!.add(sweatLabValues[i]["value"].toString());
        sweatLabValuesData["siValue"]!.add(sweatLabValues[i]["siValue"].toString());
      });
    }
    if(bloodLabValuesData["title"] != null)
      setState(() {
      _list = bloodLabValuesData["title"] as List<String>;
    });
    // print(CerebrospinalLabValuesData["title"]);
    // print(_list);
  }

  _SearchListExampleState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4)
      ..addListener(() {
        setState(() {
          if(_tabController.index == 0){
            // print(_tabController.index);
            setState(() {
              _handleSearchEnd();
              if(bloodLabValuesData["title"] != null)
                _list = bloodLabValuesData["title"] as List<String>;
              _isSearching = false;
              _searchText = "";
              searchOperation("");
            });
          }
          else if(_tabController.index == 1){
            // print(_tabController.index);
            setState(() {
              _handleSearchEnd();
              if(HematologicLabValuesData["title"] != null)
                _list = HematologicLabValuesData["title"] as List<String>;
              _isSearching = false;
              _searchText = "";
              searchOperation("");
            });
          }
          else if(_tabController.index == 2){
            // print(_tabController.index);
            setState(() {
              _handleSearchEnd();
              if(CerebrospinalLabValuesData["title"] != null)
                _list = CerebrospinalLabValuesData["title"] as List<String>;
              _isSearching = false;
              _searchText = "";
              searchOperation("");
            });
          }
          else if(_tabController.index == 3){
            // print(_tabController.index);
            setState(() {
              _handleSearchEnd();
              if(sweatLabValuesData["title"] != null)
                _list = sweatLabValuesData["title"] as List<String>;
              _isSearching = false;
              _searchText = "";
              searchOperation("");
            });
          }
        });
      });
    categorizebloodLabValues();
    _isSearching = false;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget listTiles() {
    return Container( // _tabController.index == 0
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
              child: searchresult.length != 0 || _controller.text.isNotEmpty
                  ? Column(
                children: [
                  for(int j = 0; j<_list.length;j++)
                    for(int i = 0; i<searchresult.length;i++)
                      if(_list[j] == searchresult[i])
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    _tabController.index == 0 ? bloodLabValuesData["title"]![j].toString() :
                                    _tabController.index == 1 ? HematologicLabValuesData["title"]![j].toString() :
                                    _tabController.index == 2 ? CerebrospinalLabValuesData["title"]![j].toString() :
                                    _tabController.index == 3 ? sweatLabValuesData["title"]![j].toString() :sweatLabValuesData["title"]![j].toString(),
                                    style: TextStyle(
                                      color: Color(0xff232323),
                                      fontFamily: 'Brandon-med',
                                      fontSize: (MediaQuery.of(context).size.height) *
                                          (20 / 926), //38,
                                    ),
                                  ),
                                ),
                                SizedBox(width: (MediaQuery.of(context).size.width) *
                                    (15 / 428),),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    _siValues != true ? _tabController.index == 0 ? bloodLabValuesData["value"]![j].toString() :
                                    _tabController.index == 1 ? HematologicLabValuesData["value"]![j].toString() :
                                    _tabController.index == 2 ? CerebrospinalLabValuesData["value"]![j].toString() :
                                    _tabController.index == 3 ? sweatLabValuesData["value"]![j].toString() :sweatLabValuesData["value"]![j].toString() :
                                    _tabController.index == 0 ? bloodLabValuesData["siValue"]![j].toString() :
                                    _tabController.index == 1 ? HematologicLabValuesData["siValue"]![j].toString() :
                                    _tabController.index == 2 ? CerebrospinalLabValuesData["siValue"]![j].toString() :
                                    _tabController.index == 3 ? sweatLabValuesData["siValue"]![j].toString() :sweatLabValuesData["siValue"]![j].toString(),
                                    style: TextStyle(
                                      color: Color(0xff232323),
                                      fontFamily: 'Brandon-med',
                                      fontSize: (MediaQuery.of(context).size.height) *
                                          (20 / 926), //38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: (MediaQuery.of(context).size.height) *
                                (25 / 926),),
                          ],
                        ),
                ],
              )
                  : Column(
                children: [
                  for(int i = 0; i<_list.length;i++)
                    if(_list[i] == bloodLabValuesData["title"]![i])
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 7,
                                child: Text(
                                  _tabController.index == 0 ? bloodLabValuesData["title"]![i].toString() :
                                  _tabController.index == 1 ? HematologicLabValuesData["title"]![i].toString() :
                                  _tabController.index == 2 ? CerebrospinalLabValuesData["title"]![i].toString() :
                                  _tabController.index == 3 ? sweatLabValuesData["title"]![i].toString() :sweatLabValuesData["title"]![i].toString(),
                                  style: TextStyle(
                                    color: Color(0xff232323),
                                    fontFamily: 'Brandon-med',
                                    fontSize: (MediaQuery.of(context).size.height) *
                                        (20 / 926), //38,
                                  ),
                                ),
                              ),
                              SizedBox(width: (MediaQuery.of(context).size.width) *
                                  (15 / 428),),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  _siValues != true ? _tabController.index == 0 ? bloodLabValuesData["value"]![i].toString() :
                                  _tabController.index == 1 ? HematologicLabValuesData["value"]![i].toString() :
                                  _tabController.index == 2 ? CerebrospinalLabValuesData["value"]![i].toString() :
                                  _tabController.index == 3 ? sweatLabValuesData["value"]![i].toString() :sweatLabValuesData["value"]![i].toString() :
                                  _tabController.index == 0 ? bloodLabValuesData["siValue"]![i].toString() :
                                  _tabController.index == 1 ? HematologicLabValuesData["siValue"]![i].toString() :
                                  _tabController.index == 2 ? CerebrospinalLabValuesData["siValue"]![i].toString() :
                                  _tabController.index == 3 ? sweatLabValuesData["siValue"]![i].toString() :sweatLabValuesData["siValue"]![i].toString(),
                                  style: TextStyle(
                                    color: Color(0xff232323),
                                    fontFamily: 'Brandon-med',
                                    fontSize: (MediaQuery.of(context).size.height) *
                                        (20 / 926), //38,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: (MediaQuery.of(context).size.height) *
                              (25 / 926),),
                        ],
                      ),
                ],
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _handleSearchEnd();
      },
      child: new Scaffold(
          key: globalKey,
          appBar: AppBar(toolbarHeight: (MediaQuery.of(context).size.height) *(73.52/926),
              backgroundColor: Color(0xff3F2668),
              elevation: 2,
              centerTitle: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0xff7F1AF1),
                          Color(0xff482384)
                        ])
                ),
              ),
              title: appBarTitle, actions: <Widget>[
            new IconButton(
              icon: icon,
              onPressed: () {
                setState(() {
                  if (this.icon.icon == Icons.search) {
                    this.icon = new Icon(
                      Icons.close,
                      color: Colors.white,
                    );
                    this.appBarTitle = new TextField(
                      controller: _controller,
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                      decoration: new InputDecoration(
                          prefixIcon: new Icon(Icons.search, color: Colors.white),
                          hintText: "Search...",
                          hintStyle: new TextStyle(color: Colors.white)),
                      onChanged: searchOperation,
                    );
                    _handleSearchStart();
                  } else {
                    _handleSearchEnd();
                  }
                });
              },
            ),
          ]),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height) * (30 / 926), bottom: (MediaQuery.of(context).size.height) * (20 / 926),
                          left: (MediaQuery.of(context).size.width) * (20 / 428)),
                      alignment: Alignment.center,
                      child: Text(
                        "Lab Values",
                        style: TextStyle(
                          color: Color(0xff232323),
                          fontFamily: 'Brandon-bld',
                          fontSize: (MediaQuery.of(context).size.height) *
                              (20 / 926), //38,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1,
                          child: Container(
                            height: (MediaQuery.of(context).size.height) *(15/926),
                            child: Switch(
                              value: _siValues,
                              onChanged: (value) {
                                setState(() {
                                  _siValues = value;
                                  // print(_siValues);
                                });
                              },
                              activeColor: Color(0xff3F2668),
                            ),
                          ),
                        ),
                        Container(
                          child: Text("Si Reference Intervals",
                            style: TextStyle(
                                color: Color(0xff483A3A),
                                fontFamily: 'Brandon-med',
                                fontSize: (MediaQuery.of(context).size.height) *(15/926)
                            ),
                          ),
                        ),
                        SizedBox(width: (MediaQuery.of(context).size.width) *(10/428)),

                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: (MediaQuery.of(context).size.width) * (15 / 428), right: (MediaQuery.of(context).size.width) * (15 / 428)),
                  // padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width) * (10 / 428), right: (MediaQuery.of(context).size.width) * (10 / 428)),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey, width: 2))
                  ),
                  child: TabBar(
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    controller: _tabController,
                    tabs: [
                      Tab(icon: Text(
                        "Blood",
                        style: TextStyle(
                          color: Color(0xff232323),
                          fontFamily: 'Brandon-bld',
                          fontSize: (MediaQuery.of(context).size.height) *
                              (15 / 926), //38,
                        ),
                      ),),
                      Tab(icon: Text(
                        "Hematologic",
                        style: TextStyle(
                          color: Color(0xff232323),
                          fontFamily: 'Brandon-bld',
                          fontSize: (MediaQuery.of(context).size.height) *
                              (15 / 926), //38,
                        ),
                      ),),
                      Tab(icon: Text(
                        "Cerebrospinal",
                        style: TextStyle(
                          color: Color(0xff232323),
                          fontFamily: 'Brandon-bld',
                          fontSize: (MediaQuery.of(context).size.height) *
                              (15 / 926), //38,
                        ),
                      ),),
                      Tab(icon: Text(
                        "Sweat",
                        style: TextStyle(
                          color: Color(0xff232323),
                          fontFamily: 'Brandon-bld',
                          fontSize: (MediaQuery.of(context).size.height) *
                              (15 / 926), //38,
                        ),
                      ),),
                    ],
                  ),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height) *
                    (8 / 926),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: ((MediaQuery.of(context).size.width)*(2/3)),
                      padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width) *
                          (20 / 428)),
                      child: Text(
                        _tabController.index == 0 ? "Blood, Plasma, Serum" :
                        _tabController.index == 1 ? "Serum" :
                        _tabController.index == 2 ? "Cerebrospinal Fluid" :
                        _tabController.index == 3 ? "Urine" : "Urine",
                        style: TextStyle(
                          color: Color(0xff232323),
                          fontFamily: 'Brandon-bld',
                          fontSize: (MediaQuery.of(context).size.height) *
                              (15 / 926), //38,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: (MediaQuery.of(context).size.width) *
                          (20 / 428)),
                      child: Text(
                        _siValues == true ? "Si Reference Interval" : "Reference Range",
                        style: TextStyle(
                          color: Color(0xff232323),
                          fontFamily: 'Brandon-bld',
                          fontSize: (MediaQuery.of(context).size.height) *
                              (15 / 926), //38,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width) * (15 / 428), right: (MediaQuery.of(context).size.width) * (15 / 428)),
                    child: Divider(thickness: 0.4, color: Colors.grey,)),
                Container(
                  padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width) * (15 / 428), right: (MediaQuery.of(context).size.width) * (15 / 428)),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      //Tab 1
                      listTiles(),
                      //Tab 2
                      listTiles(),
                      //Tab 3
                      listTiles(),
                      //Tab 4
                      listTiles(),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }


  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search Values",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  }
}
