import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:relatasapp/opportunity/opp_api.dart';
import 'package:relatasapp/opportunity/contacts_api.dart';
import 'package:relatasapp/utils.dart';
import 'sample_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ComplexSample extends StatefulWidget {
  @override
  _ComplexSampleState createState() => _ComplexSampleState();
}

class _ComplexSampleState extends State<ComplexSample> {

  final TextEditingController _typeAheadController = TextEditingController();

  FormGroup buildForm() => fb.group(<String, Object>{
    'oppName': FormControl<String>(
      value: 'Infy Opp for deal room testing',
    ),
    'oppOwner': FormControl<String>(value: 'John Doe'),
    'contactEmailId': FormControl<String>(value: 'naveenpaul@relatas.com'),
    // 'stageName': FormControl<String>(value: 'Lead'),
    // 'region': FormControl<String>(value: 'West'),
    // 'city': FormControl<String>(value: 'Kolkata'),
    // 'type': FormControl<String>(value: 'Renewal'),
    // 'source': FormControl<String>(value: 'Google'),
    // 'businessUnit': FormControl<String>(value: 'Networking'),
    // 'vertical': FormControl<String>(value: 'Heathcare'),
    // 'product': FormControl<String>(value: 'Forcepoint'),
    // 'solution': FormControl<String>(value: 'Security and Governance'),
    // 'competitor': FormControl<String>(value: 'Suzuki'),
    // 'currency': FormControl<String>(value: 'USD'),
    'amount': FormControl<String>(value: '1200'),
    'margin': FormControl<String>(value: '100%'),
    'closeDate': DateTime.now()
  }, [
    // Validators.mustMatch('password', 'passwordConfirmation')
  ]);

  @override
  Widget build(BuildContext context) {

    String selectedStage = "Pre-Sales";
    String selectedVertical = "Heathcare";
    String selectedProduct = "Forcepoint";
    String selectedBu = "Analytics";
    String selectedCity = "Kolkata";
    String selectedRegion = "West";
    String selectedType = "Renewal";
    String selectedSolution = "Public Sector";
    String selectedCurrency = "USD";
    String selectedCompetitor = "Daimler";

    return SampleScreen(
      body: ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          var oppId = "";

          SharedPreferences.getInstance().then((prefs) {
            // SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.getString('oppId');
          });

          return Container(
            child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                  child: Row(
                      children: [
                        Spacer(),
                        ReactiveFormConsumer(
                          builder: (context, form, child) => ElevatedButton(
                            onPressed: form.valid ? () => print(form.value) : null,
                            child: const Text('SAVE'),
                          ),
                        )
                      ]
                  ),
              ),
              label('OPP NAME'),
              inputField('oppName',form),
              const SizedBox(height: 24.0),
              label('OPP OWNER'),
              inputField('oppOwner',form),
              const SizedBox(height: 24.0),
              label('PRIMARY CONTACT'),
              // inputField('contactEmailId',form),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  autofocus: true,
                  controller: this._typeAheadController,
                  decoration: InputDecoration(
                      fillColor: Colors.white, filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white, width: 1),
                      ),
                      hintText: 'Search contact'),
                ),
                suggestionsCallback: (pattern) async {
                  return await ContactServiceV2.getSuggestions(pattern);
                },
                itemBuilder: (context, Map<String, String> suggestion) {
                  return ListTile(
                    title: Text(suggestion['name']!),
                    subtitle: Text('${suggestion['personEmailId']}'),
                  );
                },
                onSuggestionSelected: (Map<String, String> suggestion) {
                  this._typeAheadController.text = suggestion['personEmailId']!;
                  // your implementation here
                },
              ),

              const SizedBox(height: 24.0),
              Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        label('CLOSE DATE'),
                          ReactiveTextField<DateTime>(
                            formControlName: 'closeDate',
                            readOnly: true,
                            decoration: InputDecoration(
                              fillColor: Colors.white, filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.white, width: 1),
                              ),
                              labelText: '',
                              suffixIcon: ReactiveDatePicker<DateTime>(
                                formControlName: 'closeDate',
                                firstDate: DateTime(1985),
                                lastDate: DateTime(2030),
                                builder: (context, picker, child) {
                                  return IconButton(
                                    onPressed: picker.showPicker,
                                    icon: const Icon(Icons.date_range),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                    sizedBoxFormColumn(), // Defaults to flex: 1
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('STAGE'),
                            // inputField('stageName',form),
                            DropDownButtonBox(selectedStage,[
                              'Pre-Sales',
                              'Lead',
                              'Prospecting',
                              'Demo',
                              'Evaluation',
                              'Proposal',
                              'Close Won',
                              'Close Lost'
                            ])
                          ],
                        )
                    ),
                  ]
              ),
              const SizedBox(height: 24.0),
              Row(
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('amount'),
                            inputField('amount',form),
                          ],
                        )
                    ),
                    sizedBoxFormColumn(), // Defaults to flex: 1
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('margin'),
                            inputField('margin',form),
                          ],
                        )
                    ),
                  ]
              ),
              const SizedBox(height: 24.0),
              Row(
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('Region'),
                            DropDownButtonBox(selectedRegion,[
                              'South',
                              'West',
                              'North',
                              'East'
                            ])
                          ],
                        )
                    ),
                    sizedBoxFormColumn(), // Defaults to flex: 1
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('City'),
                            DropDownButtonBox(selectedCity,[
                              'Bangalore',
                              'Delhi',
                              'Hyderabad',
                              'Kolkata',
                            ])
                          ],
                        )
                    ),
                  ]
              ),
              const SizedBox(height: 24.0),
              Row(
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('PRODUCT'),
                            DropDownButtonBox(selectedProduct,[
                              'A10',
                              'Array Networks',
                              'HRM',
                              'Forcepoint'
                            ])
                          ],
                        )
                    ),
                    sizedBoxFormColumn(), // Defaults to flex: 1
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('VERTICAL'),
                            DropDownButtonBox(selectedVertical,[
                              'Enterprise',
                              'Govt',
                              'Heathcare'
                            ])
                          ],
                        )
                    ),
                  ]
              ),
              const SizedBox(height: 24.0),
              Row(
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('currency'),
                            DropDownButtonBox(selectedCurrency,[
                              'USD',
                              'INR',
                            ])
                          ],
                        )
                    ),
                    sizedBoxFormColumn(), // Defaults to flex: 1
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('competitor'),
                            DropDownButtonBox(selectedCompetitor,[
                              'Daimler',
                              'Ford',
                              'Tesla'
                            ])
                          ],
                        )
                    ),
                  ]
              )
            ],
            )
          );
        },
      ),
    );
  }
}

/// Async validator in use emails example
const inUseEmails = ['johndoe@email.com', 'john@email.com'];

/// Async validator example that simulates a request to a server
/// to validate if the email of the user is unique.
Future<Map<String, dynamic>?> _uniqueEmail(
    AbstractControl<dynamic> control) async {
  final error = {'unique': false};

  final emailAlreadyInUse = await Future.delayed(
    const Duration(seconds: 5), // delay to simulate a time consuming operation
        () => inUseEmails.contains(control.value.toString()),
  );

  if (emailAlreadyInUse) {
    control.markAsTouched();
    return error;
  }

  return null;
}