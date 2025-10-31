import '../../utility/extensions.dart';
import 'package:flutter/material.dart';
import '../../utility/app_color.dart';
import '../../widget/custom_text_field.dart';

class MyAddressPage extends StatelessWidget {
  const MyAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.profileProvider;
    profileProvider.retrieveSavedAddress();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          context.dataProvider.translate('my_address'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.darkOrange,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: profileProvider.addressFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  surfaceTintColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          labelText: context.dataProvider.translate('phone'),
                          onSave: (value) {},
                          inputType: TextInputType.number,
                          controller: profileProvider.phoneController,
                          validator: (value) => value!.isEmpty
                              ? context.dataProvider.translate(
                                  'please_enter_phone',
                                )
                              : null,
                        ),
                        CustomTextField(
                          labelText: context.dataProvider.translate('street'),
                          onSave: (val) {},
                          controller: profileProvider.streetController,
                          validator: (value) => value!.isEmpty
                              ? context.dataProvider.translate(
                                  'please_enter_street',
                                )
                              : null,
                        ),
                        CustomTextField(
                          labelText: context.dataProvider.translate('city'),
                          onSave: (value) {},
                          controller: profileProvider.cityController,
                          validator: (value) => value!.isEmpty
                              ? context.dataProvider.translate(
                                  'please_enter_city',
                                )
                              : null,
                        ),
                        CustomTextField(
                          labelText: context.dataProvider.translate('state'),
                          onSave: (value) {},
                          controller: profileProvider.stateController,
                          validator: (value) => value!.isEmpty
                              ? context.dataProvider.translate(
                                  'please_enter_state',
                                )
                              : null,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                labelText: context.dataProvider.translate(
                                  'postal_code',
                                ),
                                onSave: (value) {},
                                inputType: TextInputType.number,
                                controller:
                                    profileProvider.postalCodeController,
                                validator: (value) => value!.isEmpty
                                    ? context.dataProvider.translate(
                                        'please_enter_code',
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                labelText: context.dataProvider.translate(
                                  'country',
                                ),
                                onSave: (value) {},
                                controller: profileProvider.countryController,
                                validator: (value) => value!.isEmpty
                                    ? context.dataProvider.translate(
                                        'please_enter_country',
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.darkOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (profileProvider.addressFormKey.currentState!
                          .validate()) {
                        profileProvider.storeAddress();
                      }
                    },
                    child: Text(
                      context.dataProvider.translate('update_address'),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}