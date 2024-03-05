import 'package:flutter/material.dart';

class MobileAndOTP extends StatefulWidget {
  const MobileAndOTP({Key? key}) : super(key: key);

  @override
  State<MobileAndOTP> createState() => _MobileAndOTPState();
}

class _MobileAndOTPState extends State<MobileAndOTP> {
  int currentStep = 0;
  late TextEditingController phoneNumberController;
  late TextEditingController otpController;

  @override
  void initState() {
    super.initState();
    phoneNumberController = TextEditingController();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text(
                    'Login or Sign Up\nWelcome to DRC!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              ],
            ),
            Stepper(
              type: StepperType.vertical,
              currentStep: currentStep,
              onStepCancel: () {
                setState(() {
                  if (currentStep > 0) {
                    currentStep -= 1;
                  }
                });
              },
              onStepContinue: () {
                setState(() {
                  if (currentStep < 1) {
                    currentStep += 1;
                  }
                });
              },
              steps: [
                Step(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Phone Number\n\n',
                          style: TextStyle(
                            fontFamily: 'Gotham',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'select country and enter your phone',
                          style: TextStyle(
                            fontFamily: 'Gotham',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            prefixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.keyboard_arrow_down_sharp)),
                            suffixIcon: Icon(Icons.call),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'XXXXXXXXXX'),
                      ),
                    ],
                  ),
                  isActive: currentStep >= 0,
                  state: currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Verification Code\n\n',
                          style: TextStyle(
                            fontFamily: 'Gotham',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Enter the Verification code sent to your phone',
                          style: TextStyle(
                            fontFamily: 'Gotham',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Enter OTP'),
                      ),
                    ],
                  ),
                  isActive: currentStep >= 1,
                  state: currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MobileAndOTP(),
  ));
}
